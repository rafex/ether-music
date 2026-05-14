#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Este script debe ejecutarse como root (usa sudo)." >&2
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

CONFIG_FILE="${CONFIG_FILE:-/etc/ether-music-radio.env}"
STATE_DIR="${STATE_DIR:-/var/lib/ether-music-radio}"
STATE_FILE="${STATE_FILE:-${STATE_DIR}/install.state}"
FORCE="${FORCE:-0}"
ALLOW_OVERWRITE="${ALLOW_OVERWRITE:-0}"
NON_INVASIVE="${NON_INVASIVE:-1}"
MANAGED_MARKER="# managed-by=ether-music-radio-installer"
TARGET_USER="${TARGET_USER:-${SUDO_USER:-}}"
MPD_SYSTEMD_SCOPE="${MPD_SYSTEMD_SCOPE:-auto}"
MPD_CONF_PATH="${MPD_CONF_PATH:-}"

if [[ -f "${CONFIG_FILE}" ]]; then
  # shellcheck disable=SC1090
  if ! source "${CONFIG_FILE}"; then
    echo "ERROR: no se pudo cargar ${CONFIG_FILE}. Revisa comillas/espacios en valores." >&2
    echo "Ejemplo válido: MPD_STREAM_DESCRIPTION='Spotify casero MPD + Icecast'" >&2
    exit 4
  fi
fi

ICECAST_SOURCE_PASSWORD="${ICECAST_SOURCE_PASSWORD:-changeme-source}"
ICECAST_ADMIN_PASSWORD="${ICECAST_ADMIN_PASSWORD:-changeme-admin}"
ICECAST_RELAY_PASSWORD="${ICECAST_RELAY_PASSWORD:-changeme-relay}"
ICECAST_HOST="${ICECAST_HOST:-127.0.0.1}"
ICECAST_PORT="${ICECAST_PORT:-8000}"
ICECAST_MOUNT="${ICECAST_MOUNT:-/live}"
MPD_MUSIC_DIR="${MPD_MUSIC_DIR:-/var/lib/mpd/music}"
MPD_STREAM_NAME="${MPD_STREAM_NAME:-Ether Music Radio}"
MPD_STREAM_DESCRIPTION="${MPD_STREAM_DESCRIPTION:-Spotify casero con MPD + Icecast}"

install -d -m 0755 "${STATE_DIR}"

if [[ -z "${TARGET_USER}" ]]; then
  TARGET_USER="$(logname 2>/dev/null || true)"
fi

if [[ "${MPD_SYSTEMD_SCOPE}" == "auto" ]]; then
  if [[ -n "${TARGET_USER}" && -f "/home/${TARGET_USER}/.config/mpd/mpd.conf" ]]; then
    MPD_SYSTEMD_SCOPE="user"
  else
    MPD_SYSTEMD_SCOPE="system"
  fi
fi

if [[ -z "${MPD_CONF_PATH}" ]]; then
  if [[ "${MPD_SYSTEMD_SCOPE}" == "user" ]]; then
    MPD_CONF_PATH="/home/${TARGET_USER}/.config/mpd/mpd.conf"
  else
    MPD_CONF_PATH="/etc/mpd.conf"
  fi
fi

backup_file() {
  local file="$1"
  if [[ -f "${file}" ]]; then
    cp -a "${file}" "${file}.bak.$(date +%Y%m%d%H%M%S)"
  fi
}

write_env_var() {
  local key="$1"
  local value="$2"
  printf "%s=%q\n" "${key}" "${value}"
}

is_managed_file() {
  local file="$1"
  [[ -f "${file}" ]] && grep -qF "${MANAGED_MARKER}" "${file}"
}

require_safe_overwrite() {
  local file="$1"
  local hint="$2"
  if [[ ! -f "${file}" ]]; then
    return 0
  fi
  if is_managed_file "${file}"; then
    return 0
  fi
  if [[ "${FORCE}" == "1" || "${ALLOW_OVERWRITE}" == "1" ]]; then
    return 0
  fi
  echo "ERROR: archivo existente no gestionado detectado: ${file}" >&2
  echo "El script se detuvo para no sobrescribir tu configuración actual." >&2
  echo "Si quieres sobrescribir de forma explícita, ejecuta:" >&2
  echo "  sudo ALLOW_OVERWRITE=1 ./scripts/install_spotify_casero_debian.sh" >&2
  echo "Sugerencia: respalda primero con: cp -a ${file} ${file}.manual.bak" >&2
  echo "Referencia (${hint})" >&2
  exit 2
}

print_config_preview() {
  local file="$1"
  local title="$2"
  echo "----- ${title}: ${file} (preview) -----"
  sed -n '1,120p' "${file}" || true
  echo "----- fin preview ${title} -----"
}

is_pkg_installed() {
  dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q "install ok installed"
}

should_run_step() {
  local step_key="$1"
  local step_hash="$2"

  if [[ "${FORCE}" == "1" ]]; then
    return 0
  fi

  if [[ ! -f "${STATE_FILE}" ]]; then
    return 0
  fi

  local current
  current="$(grep -E "^${step_key}=" "${STATE_FILE}" | head -n1 | cut -d'=' -f2- || true)"
  [[ "${current}" != "${step_hash}" ]]
}

mark_step_done() {
  local step_key="$1"
  local step_hash="$2"

  touch "${STATE_FILE}"
  if grep -qE "^${step_key}=" "${STATE_FILE}"; then
    sed -i "s|^${step_key}=.*|${step_key}=${step_hash}|" "${STATE_FILE}"
  else
    echo "${step_key}=${step_hash}" >>"${STATE_FILE}"
  fi
}

sha_cfg() {
  local input="$1"
  printf "%s" "${input}" | sha256sum | awk '{print $1}'
}

run_user_cmd() {
  local uid
  uid="$(id -u "${TARGET_USER}")"
  runuser -u "${TARGET_USER}" -- env "XDG_RUNTIME_DIR=/run/user/${uid}" "$@"
}

install_missing_packages() {
  local missing=()
  local packages=(mpd mpc icecast2 ca-certificates curl)

  for pkg in "${packages[@]}"; do
    if ! is_pkg_installed "${pkg}"; then
      missing+=("${pkg}")
    fi
  done

  if [[ "${#missing[@]}" -eq 0 ]]; then
    echo "[1/9] Dependencias ya instaladas. Saltando apt."
    mark_step_done "packages" "installed"
    return 0
  fi

  echo "[1/9] Instalando dependencias faltantes: ${missing[*]}"
  apt-get update -y
  apt-get install -y --no-install-recommends "${missing[@]}"
  mark_step_done "packages" "installed"
}

install_missing_packages

echo "[2/9] Creando archivo de configuracion en /etc..."
if [[ ! -f "${CONFIG_FILE}" ]]; then
  {
    write_env_var "ICECAST_SOURCE_PASSWORD" "${ICECAST_SOURCE_PASSWORD}"
    write_env_var "ICECAST_ADMIN_PASSWORD" "${ICECAST_ADMIN_PASSWORD}"
    write_env_var "ICECAST_RELAY_PASSWORD" "${ICECAST_RELAY_PASSWORD}"
    write_env_var "ICECAST_HOST" "${ICECAST_HOST}"
    write_env_var "ICECAST_PORT" "${ICECAST_PORT}"
    write_env_var "ICECAST_MOUNT" "${ICECAST_MOUNT}"
    write_env_var "MPD_MUSIC_DIR" "${MPD_MUSIC_DIR}"
    write_env_var "MPD_STREAM_NAME" "${MPD_STREAM_NAME}"
    write_env_var "MPD_STREAM_DESCRIPTION" "${MPD_STREAM_DESCRIPTION}"
  } >"${CONFIG_FILE}"
  chmod 600 "${CONFIG_FILE}"
fi

echo "[2/9] Archivo de configuración listo: ${CONFIG_FILE}"

echo "[3/9] Asegurando carpetas base de MPD..."
if [[ "${MPD_SYSTEMD_SCOPE}" == "user" ]]; then
  install -d -o "${TARGET_USER}" -g "${TARGET_USER}" -m 0755 "${MPD_MUSIC_DIR}"
  install -d -o "${TARGET_USER}" -g "${TARGET_USER}" -m 0755 "/home/${TARGET_USER}/.config/mpd/playlists"
else
  install -d -o mpd -g audio -m 0755 "${MPD_MUSIC_DIR}"
  install -d -o mpd -g audio -m 0755 /var/lib/mpd/playlists
  install -d -o mpd -g audio -m 0755 /var/log/mpd
  install -d -o mpd -g audio -m 0755 /run/mpd
fi
mark_step_done "mpd_dirs" "$(sha_cfg "${MPD_MUSIC_DIR}")"

APPLY_ICECAST_CONFIG=1
APPLY_MPD_CONFIG=1

if [[ "${NON_INVASIVE}" == "1" && -f "/etc/icecast2/icecast.xml" ]]; then
  echo "[4/9] NON_INVASIVE=1: configuración Icecast existente detectada. No se sobrescribe."
  print_config_preview "/etc/icecast2/icecast.xml" "icecast2"
  APPLY_ICECAST_CONFIG=0
else
  require_safe_overwrite "/etc/icecast2/icecast.xml" "icecast config"
fi

if [[ "${NON_INVASIVE}" == "1" && -f "${MPD_CONF_PATH}" ]]; then
  echo "[6/9] NON_INVASIVE=1: configuración MPD existente detectada. No se sobrescribe."
  print_config_preview "${MPD_CONF_PATH}" "mpd"
  APPLY_MPD_CONFIG=0
else
  require_safe_overwrite "${MPD_CONF_PATH}" "mpd config"
fi

ICECAST_CFG_CONTENT="$(cat <<EOF
${MANAGED_MARKER}
<icecast>
  <location>Debian</location>
  <admin>admin@localhost</admin>

  <limits>
    <clients>200</clients>
    <sources>20</sources>
    <queue-size>524288</queue-size>
    <client-timeout>30</client-timeout>
    <header-timeout>15</header-timeout>
    <source-timeout>10</source-timeout>
    <burst-on-connect>1</burst-on-connect>
    <burst-size>65535</burst-size>
  </limits>

  <authentication>
    <source-password>${ICECAST_SOURCE_PASSWORD}</source-password>
    <relay-password>${ICECAST_RELAY_PASSWORD}</relay-password>
    <admin-user>admin</admin-user>
    <admin-password>${ICECAST_ADMIN_PASSWORD}</admin-password>
  </authentication>

  <hostname>${ICECAST_HOST}</hostname>

  <listen-socket>
    <port>${ICECAST_PORT}</port>
  </listen-socket>

  <mount>
    <mount-name>${ICECAST_MOUNT}</mount-name>
    <public>1</public>
  </mount>

  <fileserve>1</fileserve>

  <paths>
    <basedir>/usr/share/icecast2</basedir>
    <logdir>/var/log/icecast2</logdir>
    <webroot>/usr/share/icecast2/web</webroot>
    <adminroot>/usr/share/icecast2/admin</adminroot>
    <alias source="/" destination="/status.xsl"/>
  </paths>

  <logging>
    <accesslog>access.log</accesslog>
    <errorlog>error.log</errorlog>
    <loglevel>3</loglevel>
    <logsize>10000</logsize>
  </logging>

  <security>
    <chroot>0</chroot>
  </security>
</icecast>
EOF
)"

ICECAST_HASH="$(sha_cfg "${ICECAST_CFG_CONTENT}")"
if [[ "${APPLY_ICECAST_CONFIG}" == "1" ]] && should_run_step "icecast_cfg" "${ICECAST_HASH}"; then
  echo "[4/9] Configurando Icecast..."
  backup_file /etc/icecast2/icecast.xml
  printf "%s\n" "${ICECAST_CFG_CONTENT}" >/etc/icecast2/icecast.xml
  mark_step_done "icecast_cfg" "${ICECAST_HASH}"
elif [[ "${APPLY_ICECAST_CONFIG}" == "0" ]]; then
  mark_step_done "icecast_cfg" "non-invasive-skip"
else
  echo "[4/9] Configuración Icecast sin cambios. Saltando."
fi

if grep -q '^ENABLE=true' /etc/default/icecast2 2>/dev/null; then
  echo "[5/9] icecast2 ya habilitado en /etc/default/icecast2."
else
  echo "[5/9] Habilitando daemon de Icecast..."
  sed -i 's/^ENABLE=.*/ENABLE=true/' /etc/default/icecast2
fi
mark_step_done "icecast_enable" "true"

MPD_CFG_CONTENT="$(cat <<EOF
${MANAGED_MARKER}
music_directory         "${MPD_MUSIC_DIR}"
playlist_directory      "/var/lib/mpd/playlists"
db_file                 "/var/lib/mpd/tag_cache"
log_file                "/var/log/mpd/mpd.log"
pid_file                "/run/mpd/pid"
state_file              "/var/lib/mpd/state"
sticker_file            "/var/lib/mpd/sticker.sql"
bind_to_address         "127.0.0.1"
port                    "6600"
restore_paused          "yes"
auto_update             "yes"
auto_update_depth       "3"
follow_outside_symlinks "yes"
follow_inside_symlinks  "yes"

audio_output {
    type            "shout"
    encoding        "ogg"
    name            "${MPD_STREAM_NAME}"
    host            "${ICECAST_HOST}"
    port            "${ICECAST_PORT}"
    mount           "${ICECAST_MOUNT}"
    password        "${ICECAST_SOURCE_PASSWORD}"
    bitrate         "192"
    format          "44100:16:2"
    description     "${MPD_STREAM_DESCRIPTION}"
    protocol        "icecast2"
    public          "yes"
    mixer_type      "software"
}
EOF
)"

if [[ "${MPD_SYSTEMD_SCOPE}" == "user" ]]; then
MPD_CFG_CONTENT="$(cat <<EOF
${MANAGED_MARKER}
music_directory         "${MPD_MUSIC_DIR}"
playlist_directory      "/home/${TARGET_USER}/.config/mpd/playlists"
db_file                 "/home/${TARGET_USER}/.config/mpd/database"
log_file                "/home/${TARGET_USER}/.config/mpd/log"
pid_file                "/run/user/$(id -u "${TARGET_USER}")/mpd.pid"
state_file              "/home/${TARGET_USER}/.config/mpd/state"
sticker_file            "/home/${TARGET_USER}/.config/mpd/sticker.sql"
bind_to_address         "127.0.0.1"
port                    "6600"
restore_paused          "yes"
auto_update             "yes"
auto_update_depth       "3"
follow_outside_symlinks "yes"
follow_inside_symlinks  "yes"

audio_output {
    type            "shout"
    encoding        "ogg"
    name            "${MPD_STREAM_NAME}"
    host            "${ICECAST_HOST}"
    port            "${ICECAST_PORT}"
    mount           "${ICECAST_MOUNT}"
    password        "${ICECAST_SOURCE_PASSWORD}"
    bitrate         "192"
    format          "44100:16:2"
    description     "${MPD_STREAM_DESCRIPTION}"
    protocol        "icecast2"
    public          "yes"
    mixer_type      "software"
}
EOF
)"
fi

MPD_HASH="$(sha_cfg "${MPD_CFG_CONTENT}")"
if [[ "${APPLY_MPD_CONFIG}" == "1" ]] && should_run_step "mpd_cfg" "${MPD_HASH}"; then
  echo "[6/9] Configurando MPD (${MPD_SYSTEMD_SCOPE}) para emitir a Icecast..."
  backup_file "${MPD_CONF_PATH}"
  printf "%s\n" "${MPD_CFG_CONTENT}" >"${MPD_CONF_PATH}"
  if [[ "${MPD_SYSTEMD_SCOPE}" == "user" ]]; then
    chown "${TARGET_USER}:${TARGET_USER}" "${MPD_CONF_PATH}"
  fi
  mark_step_done "mpd_cfg" "${MPD_HASH}"
elif [[ "${APPLY_MPD_CONFIG}" == "0" ]]; then
  mark_step_done "mpd_cfg" "non-invasive-skip"
else
  echo "[6/9] Configuración MPD sin cambios. Saltando."
fi

SYSTEMD_HASH_INPUT="${ICECAST_HASH}:${MPD_HASH}:$(systemctl is-enabled icecast2.service 2>/dev/null || true):$(systemctl is-enabled mpd.service 2>/dev/null || true)"
SYSTEMD_HASH="$(sha_cfg "${SYSTEMD_HASH_INPUT}")"
if [[ "${NON_INVASIVE}" == "1" && "${APPLY_ICECAST_CONFIG}" == "0" && "${APPLY_MPD_CONFIG}" == "0" ]]; then
  echo "[7/9] NON_INVASIVE=1: configs existentes preservadas. No se reinician servicios."
  mark_step_done "systemd_apply" "non-invasive-skip"
elif should_run_step "systemd_apply" "${SYSTEMD_HASH}"; then
  echo "[7/9] Reiniciando y habilitando servicios systemd..."
  systemctl daemon-reload
  systemctl enable icecast2.service
  systemctl restart icecast2.service
  if [[ "${MPD_SYSTEMD_SCOPE}" == "user" ]]; then
    run_user_cmd systemctl --user daemon-reload || true
    run_user_cmd systemctl --user enable mpd.service || true
    if ! run_user_cmd systemctl --user restart mpd.service; then
      echo "ERROR: mpd.service (user) no pudo iniciar con la configuración aplicada." >&2
      echo "Revisa: sudo -u ${TARGET_USER} XDG_RUNTIME_DIR=/run/user/\$(id -u ${TARGET_USER}) systemctl --user status mpd.service --no-pager" >&2
      echo "Revisa: sudo -u ${TARGET_USER} XDG_RUNTIME_DIR=/run/user/\$(id -u ${TARGET_USER}) journalctl --user -xeu mpd.service --no-pager" >&2
      exit 3
    fi
  else
    systemctl enable mpd.service
    if ! systemctl restart mpd.service; then
      echo "ERROR: mpd.service no pudo iniciar con la configuración aplicada." >&2
      echo "Revisa: systemctl status mpd.service --no-pager" >&2
      echo "Revisa: journalctl -xeu mpd.service --no-pager" >&2
      exit 3
    fi
  fi
  mark_step_done "systemd_apply" "${SYSTEMD_HASH}"
else
  echo "[7/9] Servicios systemd ya aplicados para esta configuración. Saltando restart."
fi

echo "[8/9] Actualizando base de datos de MPD (si hay cambios de música hazlo manual)..."
if should_run_step "mpd_update" "baseline"; then
  if [[ "${MPD_SYSTEMD_SCOPE}" == "user" ]]; then
    if ! run_user_cmd mpc update >/dev/null 2>&1; then
      echo "Aviso: no se pudo ejecutar 'mpc update' como usuario ${TARGET_USER}."
    fi
  else
    if ! runuser -u mpd -- mpc update >/dev/null 2>&1; then
      echo "Aviso: no se pudo ejecutar 'mpc update' como usuario mpd."
    fi
  fi
  mark_step_done "mpd_update" "baseline"
else
  echo "Base de MPD ya inicializada. Saltando update automático."
fi

echo "[9/9] Estado de servicios y endpoints..."
systemctl --no-pager --full status icecast2.service | sed -n '1,20p'
if [[ "${MPD_SYSTEMD_SCOPE}" == "user" ]]; then
  run_user_cmd systemctl --user --no-pager --full status mpd.service | sed -n '1,20p'
else
  systemctl --no-pager --full status mpd.service | sed -n '1,20p'
fi

echo
echo "Instalacion finalizada."
echo "Icecast status page: http://${ICECAST_HOST}:${ICECAST_PORT}/"
echo "Stream mount:        http://${ICECAST_HOST}:${ICECAST_PORT}${ICECAST_MOUNT}"
echo "MPD control socket:  ${ICECAST_HOST}:6600"
echo "Config file:         ${CONFIG_FILE}"
echo "MPD conf:            ${MPD_CONF_PATH}"
echo "MPD scope:           ${MPD_SYSTEMD_SCOPE}"
echo "Non invasive:        ${NON_INVASIVE}"
echo "State cache:         ${STATE_FILE}"
echo
echo "Siguiente paso sugerido:"
echo "1) Coloca archivos de audio en: ${MPD_MUSIC_DIR}"
echo "2) Ejecuta: mpc update"
echo "3) Ejecuta: mpc ls | head"
echo "4) Ejecuta: mpc add / && mpc play"

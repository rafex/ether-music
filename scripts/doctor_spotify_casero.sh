#!/usr/bin/env bash
set -euo pipefail

TARGET_USER="${TARGET_USER:-${SUDO_USER:-${USER:-}}}"
MPD_SYSTEMD_SCOPE="${MPD_SYSTEMD_SCOPE:-auto}"
MPD_CONF_PATH="${MPD_CONF_PATH:-}"
ICECAST_HOST="${ICECAST_HOST:-127.0.0.1}"
ICECAST_PORT="${ICECAST_PORT:-8000}"
ICECAST_MOUNT="${ICECAST_MOUNT:-/live}"
APP_BASE_URL="${APP_BASE_URL:-http://127.0.0.1:8080}"
RADIO_ENV_FILE="${RADIO_ENV_FILE:-/etc/ether-music-radio.env}"

PASS_COUNT=0
WARN_COUNT=0
FAIL_COUNT=0

pass() { echo "[PASS] $*"; PASS_COUNT=$((PASS_COUNT + 1)); }
warn() { echo "[WARN] $*"; WARN_COUNT=$((WARN_COUNT + 1)); }
fail() { echo "[FAIL] $*"; FAIL_COUNT=$((FAIL_COUNT + 1)); }

have_cmd() { command -v "$1" >/dev/null 2>&1; }

extract_mpd_music_dir() {
  local conf="$1"
  [[ -f "${conf}" ]] || return 0
  awk -F'"' '
    /^[[:space:]]*music_directory[[:space:]]*"/ { print $2; exit }
  ' "${conf}"
}

expand_user_path() {
  local raw="$1"
  if [[ "${raw}" == "~" ]]; then
    echo "/home/${TARGET_USER}"
    return
  fi
  if [[ "${raw}" == "~/"* ]]; then
    echo "/home/${TARGET_USER}/${raw#~/}"
    return
  fi
  echo "${raw}"
}

extract_mpd_audio_output_field() {
  local conf="$1"
  local field="$2"
  [[ -f "${conf}" ]] || return 0
  awk -v field="${field}" -F'"' '
    BEGIN { in_block=0; is_shout=0 }
    /^[[:space:]]*audio_output[[:space:]]*{/ { in_block=1; is_shout=0; next }
    in_block && /^[[:space:]]*type[[:space:]]*"/ {
      if ($2 == "shout") { is_shout=1 } else { is_shout=0 }
      next
    }
    in_block && is_shout && $0 ~ "^[[:space:]]*" field "[[:space:]]*\"" {
      print $2; exit
    }
    in_block && /^[[:space:]]*}/ { in_block=0; is_shout=0; next }
  ' "${conf}"
}

run_user_cmd() {
  local uid
  uid="$(id -u "${TARGET_USER}")"
  sudo -u "${TARGET_USER}" env "XDG_RUNTIME_DIR=/run/user/${uid}" "$@"
}

detect_scope_and_conf() {
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
}

check_files() {
  echo "== Archivos de configuración =="
  if [[ -f "${RADIO_ENV_FILE}" ]]; then
    pass "Existe ${RADIO_ENV_FILE}"
  else
    warn "No existe ${RADIO_ENV_FILE} (el instalador lo crea en primera ejecución)"
  fi

  if [[ -f "${MPD_CONF_PATH}" ]]; then
    pass "Existe MPD conf: ${MPD_CONF_PATH}"
    local mdir
    mdir="$(extract_mpd_music_dir "${MPD_CONF_PATH}")"
    if [[ -n "${mdir}" ]]; then
      local expanded_mdir
      expanded_mdir="$(expand_user_path "${mdir}")"
      if [[ -d "${expanded_mdir}" ]]; then
        pass "music_directory detectado y existe: ${expanded_mdir}"
      else
        fail "music_directory detectado pero no existe: ${expanded_mdir}"
      fi
    else
      warn "No se detectó music_directory en ${MPD_CONF_PATH}"
    fi
  else
    fail "No existe MPD conf esperado: ${MPD_CONF_PATH}"
  fi

  if [[ -f "/etc/icecast2/icecast.xml" ]]; then
    pass "Existe /etc/icecast2/icecast.xml"
    if grep -q "<mount-name>${ICECAST_MOUNT}</mount-name>" /etc/icecast2/icecast.xml; then
      pass "Mount ${ICECAST_MOUNT} presente en icecast.xml"
    else
      warn "Mount ${ICECAST_MOUNT} no encontrado en icecast.xml"
    fi
  else
    fail "No existe /etc/icecast2/icecast.xml"
  fi
}

check_services() {
  echo "== Servicios =="
  if systemctl is-active --quiet icecast2; then
    pass "icecast2 activo"
  else
    fail "icecast2 inactivo"
  fi

  if [[ "${MPD_SYSTEMD_SCOPE}" == "user" ]]; then
    if run_user_cmd systemctl --user is-active --quiet mpd; then
      pass "mpd (user) activo para ${TARGET_USER}"
    else
      fail "mpd (user) inactivo para ${TARGET_USER}"
    fi
  else
    if systemctl is-active --quiet mpd; then
      pass "mpd (system) activo"
    else
      fail "mpd (system) inactivo"
    fi
  fi
}

check_mpd_runtime() {
  echo "== Runtime MPD =="
  if ! have_cmd mpc; then
    fail "No está instalado 'mpc'"
    return
  fi

  local out
  if [[ "${MPD_SYSTEMD_SCOPE}" == "user" ]]; then
    out="$(run_user_cmd mpc status 2>&1 || true)"
  else
    out="$(mpc status 2>&1 || true)"
  fi

  if echo "${out}" | grep -qiE "error|failed|connection refused|could not"; then
    fail "mpc status falló: ${out}"
  else
    pass "mpc status responde"
    if echo "${out}" | grep -q "\[playing\]"; then
      pass "MPD está reproduciendo"
    else
      warn "MPD responde pero no está en PLAYING"
    fi
  fi
}

check_icecast_stream() {
  echo "== Stream Icecast =="
  local mpd_host mpd_port mpd_mount url
  mpd_host="$(extract_mpd_audio_output_field "${MPD_CONF_PATH}" "host")"
  mpd_port="$(extract_mpd_audio_output_field "${MPD_CONF_PATH}" "port")"
  mpd_mount="$(extract_mpd_audio_output_field "${MPD_CONF_PATH}" "mount")"
  if [[ -n "${mpd_host}" ]]; then ICECAST_HOST="${mpd_host}"; fi
  if [[ -n "${mpd_port}" ]]; then ICECAST_PORT="${mpd_port}"; fi
  if [[ -n "${mpd_mount}" ]]; then ICECAST_MOUNT="${mpd_mount}"; fi
  url="http://${ICECAST_HOST}:${ICECAST_PORT}${ICECAST_MOUNT}"
  local code
  code="$(curl -sS -o /dev/null -w "%{http_code}" --max-time 5 "${url}" || true)"
  case "${code}" in
    200|206)
      pass "Stream accesible (${url}) HTTP ${code}"
      ;;
    302|301)
      warn "Stream redirige (${url}) HTTP ${code}"
      ;;
    *)
      fail "Stream no accesible (${url}) HTTP ${code:-N/A}"
      ;;
  esac
}

check_app_endpoints() {
  echo "== Endpoints app =="
  local url1="${APP_BASE_URL}/api/radio/status"
  local url2="${APP_BASE_URL}/radio"
  local c1 c2
  c1="$(curl -sS -o /dev/null -w "%{http_code}" --max-time 4 "${url1}" || true)"
  c2="$(curl -sS -o /dev/null -w "%{http_code}" --max-time 4 "${url2}" || true)"

  if [[ "${c1}" == "200" ]]; then
    pass "Endpoint OK: ${url1}"
  else
    warn "Endpoint no disponible: ${url1} (HTTP ${c1:-N/A})"
  fi
  if [[ "${c2}" == "200" ]]; then
    pass "Endpoint OK: ${url2}"
  else
    warn "Endpoint no disponible: ${url2} (HTTP ${c2:-N/A})"
  fi
}

print_summary() {
  echo
  echo "== Resumen doctor =="
  echo "PASS: ${PASS_COUNT}"
  echo "WARN: ${WARN_COUNT}"
  echo "FAIL: ${FAIL_COUNT}"
  echo "MPD scope: ${MPD_SYSTEMD_SCOPE}"
  echo "MPD conf:  ${MPD_CONF_PATH}"
  if [[ "${FAIL_COUNT}" -gt 0 ]]; then
    exit 2
  fi
  exit 0
}

main() {
  detect_scope_and_conf
  check_files
  check_services
  check_mpd_runtime
  check_icecast_stream
  check_app_endpoints
  print_summary
}

main "$@"

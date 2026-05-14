#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Este script debe ejecutarse como root (usa sudo)." >&2
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

CONFIG_FILE="${CONFIG_FILE:-/etc/ether-music-radio.env}"

if [[ -f "${CONFIG_FILE}" ]]; then
  # shellcheck disable=SC1090
  source "${CONFIG_FILE}"
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

backup_file() {
  local file="$1"
  if [[ -f "${file}" ]]; then
    cp -a "${file}" "${file}.bak.$(date +%Y%m%d%H%M%S)"
  fi
}

echo "[1/8] Instalando dependencias en Debian..."
apt-get update -y
apt-get install -y --no-install-recommends \
  mpd mpc icecast2 ca-certificates curl

echo "[2/8] Creando archivo de configuracion en /etc..."
if [[ ! -f "${CONFIG_FILE}" ]]; then
  cat >"${CONFIG_FILE}" <<EOF
ICECAST_SOURCE_PASSWORD=${ICECAST_SOURCE_PASSWORD}
ICECAST_ADMIN_PASSWORD=${ICECAST_ADMIN_PASSWORD}
ICECAST_RELAY_PASSWORD=${ICECAST_RELAY_PASSWORD}
ICECAST_HOST=${ICECAST_HOST}
ICECAST_PORT=${ICECAST_PORT}
ICECAST_MOUNT=${ICECAST_MOUNT}
MPD_MUSIC_DIR=${MPD_MUSIC_DIR}
MPD_STREAM_NAME=${MPD_STREAM_NAME}
MPD_STREAM_DESCRIPTION=${MPD_STREAM_DESCRIPTION}
EOF
  chmod 600 "${CONFIG_FILE}"
fi

echo "[3/8] Asegurando carpetas base de MPD..."
install -d -o mpd -g audio -m 0755 "${MPD_MUSIC_DIR}"
install -d -o mpd -g audio -m 0755 /var/lib/mpd/playlists
install -d -o mpd -g audio -m 0755 /var/log/mpd
install -d -o mpd -g audio -m 0755 /run/mpd

echo "[4/8] Configurando Icecast..."
backup_file /etc/icecast2/icecast.xml
cat >/etc/icecast2/icecast.xml <<EOF
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

echo "[5/8] Habilitando daemon de Icecast..."
sed -i 's/^ENABLE=.*/ENABLE=true/' /etc/default/icecast2

echo "[6/8] Configurando MPD para emitir a Icecast..."
backup_file /etc/mpd.conf
cat >/etc/mpd.conf <<EOF
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

echo "[7/8] Reiniciando y habilitando servicios systemd..."
systemctl daemon-reload
systemctl enable icecast2.service
systemctl enable mpd.service
systemctl restart icecast2.service
systemctl restart mpd.service

echo "[8/8] Actualizando base de datos de MPD..."
if ! sudo -u mpd mpc update >/dev/null 2>&1; then
  echo "Aviso: no se pudo ejecutar 'mpc update' como usuario mpd."
fi

echo "[9/9] Estado de servicios y endpoints..."
systemctl --no-pager --full status icecast2.service | sed -n '1,20p'
systemctl --no-pager --full status mpd.service | sed -n '1,20p'

echo
echo "Instalacion finalizada."
echo "Icecast status page: http://${ICECAST_HOST}:${ICECAST_PORT}/"
echo "Stream mount:        http://${ICECAST_HOST}:${ICECAST_PORT}${ICECAST_MOUNT}"
echo "MPD control socket:  ${ICECAST_HOST}:6600"
echo "Config file:         ${CONFIG_FILE}"
echo
echo "Siguiente paso sugerido:"
echo "1) Coloca archivos de audio en: ${MPD_MUSIC_DIR}"
echo "2) Ejecuta: mpc update"
echo "3) Ejecuta: mpc ls | head"
echo "4) Ejecuta: mpc add / && mpc play"

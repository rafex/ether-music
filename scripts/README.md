# Scripts

Scripts operativos para preparar el stack de "spotify casero" en Debian.

## Contenido

- `install_spotify_casero_debian.sh`:
  instala y configura `mpd` + `icecast2`, habilita servicios en
  `systemd`, y deja un stream montado por defecto.

## Uso rapido

```bash
cd scripts
chmod +x install_spotify_casero_debian.sh
sudo ./install_spotify_casero_debian.sh
```

## Idempotencia y cache

El script ahora:
- detecta paquetes ya instalados y solo instala faltantes
- guarda estado de pasos en:
  `/var/lib/ether-music-radio/install.state`
- recalcula hash de configuración y solo reescribe/reinicia cuando hay
  cambios
- protege configuraciones existentes: si detecta `mpd.conf` o
  `icecast.xml` no gestionados por este script, aborta para no
  sobrescribirlas

Forzar ejecución completa:

```bash
sudo FORCE=1 ./install_spotify_casero_debian.sh
```

Permitir sobrescritura explícita de configs existentes:

```bash
sudo ALLOW_OVERWRITE=1 ./install_spotify_casero_debian.sh
```

## Variables opcionales

Por defecto el script usa un archivo en:

`/etc/ether-music-radio.env`

Si no existe, lo crea automáticamente con valores por defecto.

Puedes editar ese archivo antes o después de instalar. Ejemplo:

```bash
sudo tee /etc/ether-music-radio.env >/dev/null <<'EOF'
ICECAST_SOURCE_PASSWORD=sourcepass
ICECAST_ADMIN_PASSWORD=adminpass
ICECAST_RELAY_PASSWORD=relaypass
ICECAST_HOST=127.0.0.1
ICECAST_PORT=8000
ICECAST_MOUNT=/live
MPD_MUSIC_DIR=/var/lib/mpd/music
MPD_STREAM_NAME=Ether Radio
MPD_STREAM_DESCRIPTION=Spotify casero MPD + Icecast
EOF
```

También puedes usar otro archivo con:

```bash
sudo CONFIG_FILE=/etc/mi-radio.env ./install_spotify_casero_debian.sh
```

## MPD en modo usuario (`systemctl --user`)

Si ya operas MPD en `~/.config/mpd/mpd.conf`:

```bash
sudo TARGET_USER=rafex \
     MPD_SYSTEMD_SCOPE=user \
     MPD_CONF_PATH=/home/rafex/.config/mpd/mpd.conf \
     ./install_spotify_casero_debian.sh
```

Variables relevantes:
- `TARGET_USER`: usuario dueño del servicio MPD
- `MPD_SYSTEMD_SCOPE`: `user` o `system` (default `auto`)
- `MPD_CONF_PATH`: ruta del `mpd.conf` a gestionar

Si lo prefieres, sigue siendo posible sobrescribir por entorno:

```bash
sudo ICECAST_SOURCE_PASSWORD="sourcepass" \
     ICECAST_ADMIN_PASSWORD="adminpass" \
     ICECAST_RELAY_PASSWORD="relaypass" \
     MPD_MUSIC_DIR="/var/lib/mpd/music" \
     MPD_STREAM_NAME="Ether Radio" \
     ./install_spotify_casero_debian.sh
```

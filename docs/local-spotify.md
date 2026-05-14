# Spotify Local de Casa (MPD + Icecast)

Guia para instalar y operar el stack local:

`MPD -> Icecast -> Browser`

en Debian, usando `systemd`.

## 1. Instalar dependencias del sistema

Desde la raiz del repo:

```bash
cd scripts
chmod +x install_spotify_casero_debian.sh
sudo ./install_spotify_casero_debian.sh
```

El script:
- instala `mpd`, `mpc`, `icecast2`
- configura `/etc/mpd.conf`
- configura `/etc/icecast2/icecast.xml`
- habilita y reinicia servicios con `systemd`
- crea o usa `/etc/ether-music-radio.env`
- es idempotente: si no hay cambios, evita repetir pasos

## 1.1 Idempotencia y cache del instalador

El script guarda estado de ejecución en:

`/var/lib/ether-music-radio/install.state`

Comportamiento:
- revisa paquetes ya instalados y solo instala faltantes
- calcula hash de configuración de MPD/Icecast
- solo reescribe configs y reinicia servicios cuando detecta cambios
- si detecta configs existentes no gestionadas por el script, aborta
  para no sobrescribirlas accidentalmente

Forzar ejecución completa:

```bash
cd scripts
sudo FORCE=1 ./install_spotify_casero_debian.sh
```

Permitir sobrescritura explícita (solo si estás seguro):

```bash
cd scripts
sudo ALLOW_OVERWRITE=1 ./install_spotify_casero_debian.sh
```

## 2. Configurar variables en `/etc`

Archivo por defecto:

`/etc/ether-music-radio.env`

Ejemplo recomendado:

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

Si cambias este archivo, vuelve a ejecutar el script:

```bash
cd scripts
sudo ./install_spotify_casero_debian.sh
```

También puedes usar otro archivo de variables:

```bash
cd scripts
sudo CONFIG_FILE=/etc/mi-radio.env ./install_spotify_casero_debian.sh
```

## 2.1 Caso MPD en modo usuario (`systemctl --user`)

Si tu MPD ya vive en `~/.config/mpd/mpd.conf` y corre como servicio de
usuario, ejecuta el instalador así:

```bash
cd scripts
sudo TARGET_USER=rafex \
     MPD_SYSTEMD_SCOPE=user \
     MPD_CONF_PATH=/home/rafex/.config/mpd/mpd.conf \
     ./install_spotify_casero_debian.sh
```

Con eso el script:
- usa `systemctl --user` para MPD
- opera sobre el `mpd.conf` del usuario
- evita mezclarlo con `/etc/mpd.conf`

## 3. Verificar servicios `systemd`

```bash
sudo systemctl status icecast2 --no-pager
sudo systemctl status mpd --no-pager
```

Habilitados al arranque:

```bash
sudo systemctl is-enabled icecast2
sudo systemctl is-enabled mpd
```

Estado de cache:

```bash
sudo ls -l /var/lib/ether-music-radio/install.state
sudo cat /var/lib/ether-music-radio/install.state
```

## 4. Cargar musica y arrancar reproducción

Coloca archivos en `MPD_MUSIC_DIR` (default `/var/lib/mpd/music`):

```bash
sudo cp /ruta/a/tu-musica/*.mp3 /var/lib/mpd/music/
sudo chown -R mpd:audio /var/lib/mpd/music
```

Actualizar base y reproducir:

```bash
mpc update
mpc add /
mpc play
```

## 5. Verificar stream de Icecast

```bash
curl -I http://127.0.0.1:8000/live
```

Panel web de Icecast:

`http://127.0.0.1:8000/`

## 6. Conectar con Ether Music (`/radio`)

La app Java usa estas variables para controlar MPD y reproducir stream:

- `MPD_HOST`
- `MPD_PORT`
- `MPD_TIMEOUT_MS`
- `ICECAST_STREAM_URL`

Ejemplo:

```bash
export MPD_HOST=127.0.0.1
export MPD_PORT=6600
export MPD_TIMEOUT_MS=1500
export ICECAST_STREAM_URL=http://127.0.0.1:8000/live
just run
```

Luego abre:

`http://127.0.0.1:8080/radio`

## 7. Troubleshooting

Si no suena audio:
- confirma que `mpc status` muestre reproducción activa
- revisa logs:

```bash
sudo journalctl -u mpd -n 100 --no-pager
sudo journalctl -u icecast2 -n 100 --no-pager
```

Si `/api/radio/status` marca offline:
- verifica `MPD_HOST` y `MPD_PORT`
- confirma que MPD esté escuchando en `127.0.0.1:6600`

Si ya tenías una instalación previa y quieres volver al estado anterior:

```bash
sudo ls -1 /etc/mpd.conf.bak.*
sudo ls -1 /etc/icecast2/icecast.xml.bak.*
```

Restaurar backup más reciente (ejemplo):

```bash
sudo cp -a /etc/mpd.conf.bak.YYYYmmddHHMMSS /etc/mpd.conf
sudo cp -a /etc/icecast2/icecast.xml.bak.YYYYmmddHHMMSS /etc/icecast2/icecast.xml
sudo systemctl restart mpd icecast2
```

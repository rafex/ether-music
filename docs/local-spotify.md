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

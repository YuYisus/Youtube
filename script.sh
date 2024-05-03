#!/bin/bash
# Comprueba e instala herramientas
install_tools() {
  if ! command -v yt-dlp &>/dev/null; then
    echo "yt-dlp no está instalado. Se va a intsalar ahora"
    sudo apt-get install yt-dlp
  fi

  if ! command -v ffmpeg &>/dev/null; then
    echo "ffmpeg no está instalado. Se va a instalar ahora"
    sudo apt-get install ffmpeg
  fi
}

install_tools

# Pide la URL al usuario
echo "Introduce la URL de YouTube:"
read url

# Lista formatos disponibles
yt-dlp -F $url

echo "Elige el formato del video"
read format

# Descarga el video en el formato seleccionado
yt-dlp -f $format $url -o video.%\(ext\)s

# Extrae el audio a mp3
ffmpeg -i video.* -vn -acodec libmp3lame audio.mp3

# Crea un video sin audio
ffmpeg -i video.* -c:v copy -an video_compressed.mp4

# Muestra informacion
echo "Informacion"
echo "Audio: $(du -h audio.mp3) | Duracion: $(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 audio.mp3)s"
echo "Video: $(du -h video_compressed.mp4)"

#!/bin/bash
set -e

echo "=== Wallpaper Guardian - Instalador ==="
echo

# Verificar requisitos
if ! command -v inotifywait &> /dev/null; then
    echo "❌ Error: inotify-tools no está instalado"
    echo "   Ejecuta: sudo pacman -S inotify-tools"
    exit 1
fi

if ! command -v python3 &> /dev/null; then
    echo "❌ Error: python3 no está instalado"
    exit 1
fi

# Copiar script principal
echo "📦 Instalando wallpaper-guardian..."
install -Dm755 wallpaper-guardian ~/.local/bin/wallpaper-guardian

# Copiar servicio systemd
echo "📦 Instalando servicio systemd..."
install -Dm644 wallpaper-guardian.service ~/.config/systemd/user/wallpaper-guardian.service

# Crear directorios
mkdir -p ~/.config/wallpaper-engine-safe/backups

echo
echo "✅ Instalación completada"
echo
echo "Para activar:"
echo "  systemctl --user enable --now wallpaper-guardian.service"
echo
echo "Para verificar estado:"
echo "  wallpaper-guardian status"
echo

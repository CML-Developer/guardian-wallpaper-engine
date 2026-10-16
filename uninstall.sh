#!/bin/bash
echo "=== Wallpaper Guardian - Desinstalador ==="
echo

systemctl --user stop wallpaper-guardian.service 2>/dev/null || true
systemctl --user disable wallpaper-guardian.service 2>/dev/null || true

rm -f ~/.local/bin/wallpaper-guardian
rm -f ~/.config/systemd/user/wallpaper-guardian.service

systemctl --user daemon-reload

echo "✅ Desinstalado"
echo
echo "Los backups y blacklist se conservan en:"
echo "  ~/.config/wallpaper-engine-safe/"
echo

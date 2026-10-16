# Wallpaper Guardian

**[Español](#español) · [English](#english)**

---

<a name="español"></a>
## Español

**Sistema de protección activa contra wallpapers que crashean KDE Plasma.**

Wallpaper Guardian monitoriza en tiempo real los fondos de Wallpaper Engine y **detiene automáticamente** los que causan crashes o inestabilidad en Plasma, revirtiendo al fondo anterior seguro.

---

### Características

- 🛡️ **Protección automática**: Detecta crashes de plasmashell y revierte al wallpaper anterior
- 📋 **Lista negra persistente**: Bloquea permanentemente wallpapers problemáticos
- 💾 **Backups automáticos**: Guarda configuraciones seguras cada vez que cambias de fondo
- ⚠️ **Alertas de scene wallpapers**: Advierte sobre wallpapers tipo `scene` (inestables en Linux/Wayland)
- 🔄 **Recuperación automática**: Reinicia plasmashell si crashea
- 🧪 **Modo test**: Prueba todos tus wallpapers instalados y genera reporte
- 📊 **Integración con Aura KDE**: Los fondos bloqueados se ocultan automáticamente en [aura-kde](https://github.com/CML-Developer/aura-kde)

---

### Requisitos

- Arch Linux (o derivado: CachyOS, EndeavourOS, Manjaro)
- KDE Plasma 6, sesión Wayland
- [catsout wallpaper-engine-kde-plugin](https://github.com/catsout/wallpaper-engine-kde-plugin) instalado
- Steam + Wallpaper Engine
- `inotify-tools` (para monitorear cambios de configuración)
- `python3` (para parsing de JSON)

```bash
sudo pacman -S inotify-tools python
```

---

### Instalación

#### 1. Clonar el repositorio

```bash
git clone https://github.com/CML-Developer/guardian-wallpaper-engine.git
cd guardian-wallpaper-engine
```

#### 2. Ejecutar el instalador

```bash
./install.sh
```

Esto instalará:
- `/home/camilo/.local/bin/wallpaper-guardian` → script principal
- `/home/camilo/.config/systemd/user/wallpaper-guardian.service` → servicio systemd
- Lista negra en: `~/.config/wallpaper-engine-safe/blacklist.txt`

#### 3. Iniciar el servicio

```bash
systemctl --user enable --now wallpaper-guardian.service
```

---

### Uso

#### Ver estado

```bash
wallpaper-guardian status
```

#### Ver wallpapers bloqueados

```bash
wallpaper-guardian list
```

#### Verificar si un wallpaper es seguro

```bash
wallpaper-guardian check <workshop_id>
```

#### Agregar manualmente a la lista negra

```bash
wallpaper-guardian add <workshop_id>
```

#### Remover de la lista negra

```bash
wallpaper-guardian remove <workshop_id>
```

#### Ver log de actividad

```bash
wallpaper-guardian log
```

#### Restaurar configuración anterior

```bash
wallpaper-guardian restore
```

#### **Probar todos los wallpapers** (genera reporte completo)

```bash
wallpaper-guardian test
```

⚠️ **Advertencia**: El modo test reinicia plasmashell por cada wallpaper. Cierra todas tus aplicaciones antes de ejecutarlo. Genera un reporte en `~/.config/wallpaper-engine-safe/test_*.txt`.

---

### Cómo funciona

Guardian monitoriza dos eventos:

1. **Cambios en el archivo de configuración** (`plasma-org.kde.plasma.desktop-appletsrc`):
   - Cuando cambias de wallpaper, verifica si está en la lista negra
   - Si está bloqueado, revierte al backup anterior automáticamente
   - Si es un wallpaper `scene`, muestra advertencia (inestables en Linux)
   - Hace backup de configuraciones seguras

2. **Crashes de plasmashell**:
   - Si plasmashell crashea inesperadamente, agrega el wallpaper actual a la lista negra
   - Revierte a la última configuración segura
   - Reinicia plasmashell automáticamente

---

### Archivos y directorios

```
~/.config/wallpaper-engine-safe/
├── blacklist.txt              # Lista negra (un ID por línea)
├── guardian_log.txt           # Log de actividad
├── guardian.pid               # PID del proceso activo
├── backups/                   # Últimos 10 backups seguros
│   └── safe_config_*.bak
└── test_*.txt                 # Reportes de tests
```

---

### Desinstalar

```bash
./uninstall.sh
```

Esto detiene y remueve el servicio. Los backups y la blacklist se conservan en `~/.config/wallpaper-engine-safe/`.

---

### Integración con Aura KDE

Si usas [aura-kde](https://github.com/CML-Developer/aura-kde), los wallpapers en la blacklist se **ocultan automáticamente** de la biblioteca y el selector hexagonal, sin configuración adicional.

Guardian solo escribe en `blacklist.txt`. Aura solo lee. No hay conflicto.

---

### Logs y diagnóstico

```bash
# Ver últimos 80 eventos
wallpaper-guardian log

# Seguir log en tiempo real
journalctl --user -u wallpaper-guardian.service -f

# Ver estado del servicio
systemctl --user status wallpaper-guardian.service
```

---

### Notas técnicas

- **Detección de crashes**: Monitorea el PID de plasmashell. Si cambia o desaparece inesperadamente, es un crash.
- **Escritura atómica**: KDE usa `rename()` para actualizar el config (escribe a `.tmp` y renombra). Guardian monitorea eventos `moved_to` y `close_write`.
- **Scene wallpapers**: Tienen un renderer Python (`pyext.py`) separado. Guardian verifica si el proceso hijo muere.
- **Evita loops**: Marca sus propios `kill` de plasmashell con un flag para no auto-blacklistear el wallpaper del backup.
- **Backups**: Solo hace backup si el archivo tiene >500 bytes (evita guardar configs truncados durante escritura).

---

---

<a name="english"></a>
## English

**Active protection system against wallpapers that crash KDE Plasma.**

Wallpaper Guardian monitors Wallpaper Engine wallpapers in real-time and **automatically stops** those that cause crashes or instability in Plasma, reverting to the previous safe wallpaper.

---

### Features

- 🛡️ **Automatic protection**: Detects plasmashell crashes and reverts to previous wallpaper
- 📋 **Persistent blacklist**: Permanently blocks problematic wallpapers
- 💾 **Automatic backups**: Saves safe configurations every time you change wallpaper
- ⚠️ **Scene wallpaper alerts**: Warns about `scene` type wallpapers (unstable on Linux/Wayland)
- 🔄 **Auto-recovery**: Restarts plasmashell if it crashes
- 🧪 **Test mode**: Tests all installed wallpapers and generates report
- 📊 **Aura KDE integration**: Blocked wallpapers are automatically hidden in [aura-kde](https://github.com/CML-Developer/aura-kde)

---

### Requirements

- Arch Linux (or derivative: CachyOS, EndeavourOS, Manjaro)
- KDE Plasma 6, Wayland session
- [catsout wallpaper-engine-kde-plugin](https://github.com/catsout/wallpaper-engine-kde-plugin) installed
- Steam + Wallpaper Engine
- `inotify-tools` (for config file monitoring)
- `python3` (for JSON parsing)

```bash
sudo pacman -S inotify-tools python
```

---

### Installation

#### 1. Clone the repository

```bash
git clone https://github.com/CML-Developer/guardian-wallpaper-engine.git
cd guardian-wallpaper-engine
```

#### 2. Run the installer

```bash
./install.sh
```

This installs:
- `~/.local/bin/wallpaper-guardian` → main script
- `~/.config/systemd/user/wallpaper-guardian.service` → systemd service
- Blacklist at: `~/.config/wallpaper-engine-safe/blacklist.txt`

#### 3. Start the service

```bash
systemctl --user enable --now wallpaper-guardian.service
```

---

### Usage

#### Check status

```bash
wallpaper-guardian status
```

#### List blocked wallpapers

```bash
wallpaper-guardian list
```

#### Check if a wallpaper is safe

```bash
wallpaper-guardian check <workshop_id>
```

#### Manually add to blacklist

```bash
wallpaper-guardian add <workshop_id>
```

#### Remove from blacklist

```bash
wallpaper-guardian remove <workshop_id>
```

#### View activity log

```bash
wallpaper-guardian log
```

#### Restore previous configuration

```bash
wallpaper-guardian restore
```

#### **Test all wallpapers** (generates full report)

```bash
wallpaper-guardian test
```

⚠️ **Warning**: Test mode restarts plasmashell for each wallpaper. Close all your applications before running. Generates a report at `~/.config/wallpaper-engine-safe/test_*.txt`.

---

### How it works

Guardian monitors two events:

1. **Configuration file changes** (`plasma-org.kde.plasma.desktop-appletsrc`):
   - When you change wallpaper, checks if it's blacklisted
   - If blocked, automatically reverts to previous backup
   - If it's a `scene` wallpaper, shows warning (unstable on Linux)
   - Backs up safe configurations

2. **Plasmashell crashes**:
   - If plasmashell crashes unexpectedly, adds current wallpaper to blacklist
   - Reverts to last safe configuration
   - Automatically restarts plasmashell

---

### Files and directories

```
~/.config/wallpaper-engine-safe/
├── blacklist.txt              # Blacklist (one ID per line)
├── guardian_log.txt           # Activity log
├── guardian.pid               # Active process PID
├── backups/                   # Last 10 safe backups
│   └── safe_config_*.bak
└── test_*.txt                 # Test reports
```

---

### Uninstall

```bash
./uninstall.sh
```

This stops and removes the service. Backups and blacklist are preserved in `~/.config/wallpaper-engine-safe/`.

---

### Aura KDE Integration

If you use [aura-kde](https://github.com/CML-Developer/aura-kde), blacklisted wallpapers are **automatically hidden** from the library and hexagonal selector, no additional configuration needed.

Guardian only writes to `blacklist.txt`. Aura only reads. No conflict.

---

### Logs and diagnostics

```bash
# View last 80 events
wallpaper-guardian log

# Follow log in real-time
journalctl --user -u wallpaper-guardian.service -f

# View service status
systemctl --user status wallpaper-guardian.service
```

---

### Technical notes

- **Crash detection**: Monitors plasmashell PID. If it changes or disappears unexpectedly, it's a crash.
- **Atomic writes**: KDE uses `rename()` to update config (writes to `.tmp` then renames). Guardian monitors `moved_to` and `close_write` events.
- **Scene wallpapers**: Have a separate Python renderer (`pyext.py`). Guardian checks if the child process dies.
- **Avoids loops**: Marks its own plasmashell `kill`s with a flag to avoid auto-blacklisting the backup's wallpaper.
- **Backups**: Only backs up if file is >500 bytes (avoids saving truncated configs during write).

---

### License

GPL-3.0

> **Disclaimer**: Not affiliated with or endorsed by Valve, Steam, Wallpaper Engine, or the catsout plugin project.

#!/bin/sh
# Reload apps that don't watch their config files for changes.

# kitty: SIGUSR1 triggers a live config reload
pkill -SIGUSR1 kitty 2>/dev/null

# KDE apps: apply the generated Plasma color scheme.
# Bounce through BreezeLight first — plasma-apply-colorscheme skips the D-Bus
# notification if the scheme name is already active, so this forces a real change
# event that causes Dolphin, QBittorrent, etc. to repaint.
plasma-apply-colorscheme BreezeLight >/dev/null 2>&1
plasma-apply-colorscheme CaelestiaTheme 2>/dev/null

# Neovim: signal each running instance via its server socket.
# Instances started without --listen won't have a socket and are silently skipped.
for socket in /run/user/"$(id -u)"/nvim.*.0 /tmp/nvim.*/nvim.*.0; do
  [ -S "$socket" ] && nvim --server "$socket" \
    --remote-send ':colorscheme caelestia<CR>' 2>/dev/null
done

# Sioyek: fix visual_mark_color (sioyek uses space-separated floats, not hex).
# The template writes a static placeholder; overwrite it with the real value.
_sf="${HOME}/.local/state/caelestia/theme/sioyek.config"
if [ -f "$_sf" ] && [ -n "$SCHEME_COLOURS" ]; then
  _mc=$(python3 -c "
import json, os
h = json.loads(os.environ['SCHEME_COLOURS']).get('tertiary', 'afceb5')
r, g, b = int(h[0:2], 16)/255, int(h[2:4], 16)/255, int(h[4:6], 16)/255
print(f'{r:.8f} {g:.8f} {b:.8f} 0.2')
")
  sed -i "s/^visual_mark_color .*/visual_mark_color $_mc/" "$_sf"
fi

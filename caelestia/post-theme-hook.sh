#!/bin/sh
# Reload apps that don't watch their config files for changes.

# kitty: SIGUSR1 triggers a live config reload
pkill -SIGUSR1 kitty 2>/dev/null

# KDE apps: apply the generated Plasma color scheme.
# Bounce through BreezeLight first — plasma-apply-colorscheme skips the D-Bus
# notification if the scheme name is already active, so this forces a real change
# event that causes Dolphin, QBittorrent, etc. to repaint.
#
# plasma-apply-colorscheme BreezeLight >/dev/null 2>&1
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

# Sioyek: make the running instance re-read its config so the PDF page
# colours (custom_background_color/custom_text_color) follow the scheme.
# sioyek is single-instance and only loads config at process start; it does
# not watch the sourced caelestia.config, so a running instance stays stale.
if command -v sioyek >/dev/null 2>&1 && pgrep -x sioyek >/dev/null 2>&1; then
  sioyek --execute-command reload_config --nofocus >/dev/null 2>&1
fi

# Zen Browser: translate Caelestia colors and update Color Boost
if [ -x "${HOME}/.config/zen-boosts/apply_zen_boost.py" ]; then
  "${HOME}/.config/zen-boosts/apply_zen_boost.py"
fi

# Kvantum: patch the SVG to replace accent blues with caelestia colors,
# then symlink the pair into ~/.config/Kvantum/Caelestia/ so Qt apps see it.
_kvtheme="$HOME/.local/state/caelestia/theme"
_kvconfig_svg="$HOME/.config/Kvantum/WhiteSur/WhiteSurDark.svg"
_kvout="$HOME/.config/Kvantum/Caelestia"
if [ -f "$_kvconfig_svg" ] && [ -n "$SCHEME_COLOURS" ]; then
  python3 -c "
import json, os

c = json.loads(os.environ['SCHEME_COLOURS'])
def g(k, fb):
    v = c.get(k, fb)
    return v if v else fb

pri     = g('primary',            'a0b4f8')
pri_dim = g('primaryFixedDim',    'baa57d')  # lighter than primary
pri_med = g('inversePrimary',     '775a2b')  # darker, richer accent
pri_drk = g('primaryContainer',   '694d20')  # darkest accent (pressed)
sec      = g('secondary',          'b0a08a')
ter      = g('tertiary',           'd4b0a0')

svg = open(os.path.expanduser('$_kvconfig_svg')).read()

# Each original blue mapped to a caelestia equivalent, preserving
# the relative light/dark hierarchy of the original.
# Gradient pairs keep the dark->light direction.
replacements = {
    # --- highlight-level (lightest blue) -> primary ---
    '#5887fc': pri,       # hightlight gradient (selected items)
    '#5294e2': pri,       # dial-handle, menubaritem-pressed
    '#0078f0': pri,       # path7945
    '#67676a': pri,       # lineedit-focused border

    # --- medium accent (medium blue) -> dim/fixed/med ---
    '#31a7e8': pri_dim,   # mdi-restore-normal (window button)
    '#3daee9': pri_dim,   # common-normal, group-normal (elem bg)
    '#315bef': pri_med,   # slider-toggled, combo-toggled/focused
    '#6179df': sec,        # rect6589 (secondary accent)
    '#8591e3': ter,        # rect6745, rect6791 (tertiary accent)
    '#3176bf': sec,        # tab-tear (drag indicator)

    # --- darkest accent (darkest blue) -> primaryContainer ---
    '#144fb8': pri_drk,   # button-pressed

    # --- gradient pairs (dark->light) ---
    '#3458c0': pri_drk,   # dark_checked_bg  start
    '#3d67e3': pri_med,   # dark_checked_bg  end
    '#1759ce': pri_drk,   # toggled button   start
    '#1a62e7': pri_med,   # toggled button   end
    '#245fc4': pri_drk,   # gradient1933     start
    '#286adc': pri_med,   # gradient1933     end
}

for old, new in replacements.items():
    svg = svg.replace(old,      f'#{new}')
    svg = svg.replace(old.upper(), f'#{new}')

open(os.path.expanduser('$_kvtheme/Caelestia.svg'), 'w').write(svg)
"
  mkdir -p "$_kvout"
  ln -sf "$_kvtheme/Caelestia.kvconfig" "$_kvout/Caelestia.kvconfig"
  ln -sf "$_kvtheme/Caelestia.svg" "$_kvout/Caelestia.svg"
fi

# Vicinae: reapply theme after colour regeneration so the running
# instance picks up the newly written theme file.
vicinae theme set caelestia 2>/dev/null

# bat: rebuild the syntax-highlighting theme cache so 'bat' picks up
# the newly generated Caelestia.tmTheme on the next invocation.
if [ -f "$_kvtheme/Caelestia.tmTheme" ]; then
  bat cache --build >/dev/null 2>&1
fi

# Generate Lua scheme file for Hyprland Lua configs.
# caelestia-cli only writes current.conf (hyprlang), but the Lua config
# requires current.lua.  SCHEME_COLOURS provides all colours as JSON.
if [ -n "$SCHEME_COLOURS" ]; then
  python3 -c "
import json, os
colours = json.loads(os.environ['SCHEME_COLOURS'])
path = os.path.expanduser('~/.config/hypr/scheme/current.lua')
lines = ['-- Color scheme - generated by Caelestia',
         '-- This is the Lua port of current.conf',
         'return {']
for k, v in colours.items():
    lines.append(f'    {k} = \"{v}\",')
lines.append('}')
with open(path, 'w') as f:
    f.write('\n'.join(lines) + '\n')
" 2>/dev/null
fi

# ZapZap (WhatsApp): generate CSS that overrides WhatsApp Web's "color-refresh"
# WDS palette primitives so backgrounds + accent follow the scheme and the
# stock WhatsApp green is replaced. WhatsApp's own JS injection is blocked by
# the page CSP, but the WDS primitives live in a :root stylesheet rule (no
# !important), so a CSS override with !important wins. Written here rather than
# via a template because the WDS *-RGB alpha channels need bare "r,g,b" values
# the template engine can't emit. The output path is symlinked into
# ~/.local/share/ZapZap/customizations/accounts/storage-whats/css/zapzap.css.
if [ -n "$SCHEME_COLOURS" ]; then
  python3 -c "
import json, os
c = json.loads(os.environ['SCHEME_COLOURS'])
def rgb(h): return ','.join(str(int(h[i:i+2], 16)) for i in (0, 2, 4))

def mix(a, b, t):
    '''Blend hex colour a towards b by factor t (0..1).'''
    return ''.join(f'{round(int(a[i:i+2],16)*(1-t)+int(b[i:i+2],16)*t):02x}' for i in (0, 2, 4))

primary = c.get('primary', 'ebc2bc')
pcont   = c.get('primaryContainer', '255a5b')

# Surfaces are tinted towards primaryContainer so the wallpaper colour
# shows through the dark backgrounds. TINT is the blend strength.
TINT    = 0.14
surface = mix(c.get('surface', '171312'),              pcont, TINT)
low     = mix(c.get('surfaceContainerLow', '201a19'),  pcont, TINT)
cont    = mix(c.get('surfaceContainer', '241e1d'),     pcont, TINT)
high    = mix(c.get('surfaceContainerHigh', '2f2827'), pcont, TINT)

# backgrounds / surfaces
bg = {'neutral-gray-900': surface, 'neutral-gray-850': low,
      'neutral-gray-800': cont,    'neutral-gray-700': high}
# bright green/emerald accent shades -> primary (kills the green)
accent = ['green-400', 'green-450', 'green-500', 'green-600',
          'emerald-400', 'emerald-500', 'emerald-600']
# dark green shades (incl. outgoing bubble green-750) -> primaryContainer
# (dark accent surface in dark schemes, so light bubble text stays readable)
dark = ['green-700', 'green-750', 'green-800', 'emerald-700', 'emerald-800']
# semantic system tokens: WhatsApp's per-chat-theme classes (.x1umy8rd etc.)
# declare these with LITERAL hex values, bypassing the primitives above —
# they must be overridden directly (:root !important beats their double-class
# selectors because importance trumps specificity)
# chat area behind the messages gets a stronger tint than the rest
chatbg = mix(c.get('surface', '171312'), pcont, 0.35)

sem = {
    'surface-default':                     surface,
    'background-wash-plain':               surface,
    'background-wash-inset':               surface,
    'background-elevated-wash-plain':      low,
    'background-elevated-wash-inset':      low,
    'surface-elevated-default':            low,
    'surface-emphasized':                  cont,
    'surface-elevated-emphasized':         cont,
    'components-surface-nav-bar':          low,
    'systems-chat-background-wallpaper':   chatbg,
    'systems-chat-surface-composer':       low,
    'systems-chat-surface-tray':           surface,
    'systems-bubble-surface-outgoing':     pcont,
    'systems-bubble-surface-incoming':     cont,
    'persistent-always-branded':           primary,
}

lines = []
for k, v in bg.items():
    lines.append(f'  --WDS-{k}:#{v}!important; --WDS-{k}-RGB:{rgb(v)}!important;')
for k in accent:
    lines.append(f'  --WDS-{k}:#{primary}!important; --WDS-{k}-RGB:{rgb(primary)}!important;')
for k in dark:
    lines.append(f'  --WDS-{k}:#{pcont}!important; --WDS-{k}-RGB:{rgb(pcont)}!important;')
for k, v in sem.items():
    lines.append(f'  --WDS-{k}:#{v}!important; --WDS-{k}-RGB:{rgb(v)}!important;')
# doodle pattern over the chat background, tinted with the accent
lines.append(f'  --WDS-systems-chat-foreground-wallpaper:rgba({rgb(primary)},.12)!important;')
# legacy literal-hex fallbacks for non-color-refresh components
lines.append(f'  --bubbleContentUserBackgroundColor:#{pcont}!important;')
lines.append(f'  --buttonSendBackgroundColor:#{primary}!important;')

# '*' (not :root): WhatsApp's theme-class wrapper sits below <html> and
# redeclares the semantic tokens; descendants inherit from it, so the
# override must land on every element to win on the wrapper itself.
css = '/* Caelestia ZapZap theme - generated by post-theme-hook */\n*{\n' + '\n'.join(lines) + '\n}\n'
path = os.path.expanduser('~/.local/state/caelestia/theme/zapzap.css')
os.makedirs(os.path.dirname(path), exist_ok=True)
with open(path, 'w') as f:
    f.write(css)
" 2>/dev/null
fi

# Cider: regenerate the wallpaper theme and live-inject it via CDP (no restart).
# Needs Cider launched with --remote-debugging-port=9223 (cider-themed wrapper);
# silently no-ops if Cider isn't running.
if [ -n "$SCHEME_COLOURS" ]; then
  python3 "${HOME}/.config/caelestia/cider-theme.py" 2>/dev/null
fi

#!/usr/bin/env python3
import os
import sys

def hex2rgb(h):
    h = h.lstrip('#')
    return int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16)

def rgb2hex(r, g, b):
    return f"#{int(r):02x}{int(g):02x}{int(b):02x}"

def blend(c1, c2, alpha):
    r1, g1, b1 = hex2rgb(c1)
    r2, g2, b2 = hex2rgb(c2)
    r = r1 + (r2 - r1) * alpha
    g = g1 + (g2 - g1) * alpha
    b = b1 + (b2 - b1) * alpha
    return rgb2hex(r, g, b)

def desaturate(h, amount):
    r, g, b = hex2rgb(h)
    l = 0.2126 * r + 0.7152 * g + 0.0722 * b
    gray = rgb2hex(l, l, l)
    return blend(h, gray, amount)

in_file = os.path.expanduser("~/.local/state/caelestia/theme/colors-kitty.conf")
out_file = os.path.expanduser("~/.local/state/caelestia/theme/colors-kitty-muted.conf")

if not os.path.exists(in_file):
    sys.exit(0)

with open(in_file, 'r') as f:
    lines = f.readlines()

bg_color = None
for line in lines:
    if line.startswith("background "):
        bg_color = line.split()[1].strip()
        break

if not bg_color:
    sys.exit(0)

r, g, b = hex2rgb(bg_color)
is_dark = (r*0.299 + g*0.587 + b*0.114) < 128

bg_mute = "#1c1c1e" if is_dark else "#f4f4f6"
fg_mute = "#d4d4d8" if is_dark else "#3f3f46"

muted_bg0 = blend(bg_color, bg_mute, 0.5)

out_lines = []
for line in lines:
    if not line.strip() or line.startswith('#') and not line.startswith('# '):
        out_lines.append(line)
        continue
    
    parts = line.split()
    if len(parts) == 2 and parts[1].startswith('#'):
        key, h = parts[0], parts[1]
        
        if key in ["background", "tab_bar_background", "wayland_titlebar_color", "macos_titlebar_color", "inactive_tab_background", "color0"]:
            new_c = blend(h, bg_mute, 0.5)
        elif key in ["foreground", "cursor", "active_tab_foreground", "inactive_tab_foreground", "selection_foreground", "color7", "color15"]:
            new_c = blend(h, fg_mute, 0.3)
        elif key in ["selection_background", "active_tab_background"]:
            m = desaturate(h, 0.10)
            new_c = blend(m, muted_bg0, 0.3)
        elif key.startswith("color") or key in ["url_color", "active_border_color", "bell_border_color"]:
            m = desaturate(h, 0.10)
            new_c = blend(m, muted_bg0, 0.05)
        elif key in ["inactive_border_color", "color8"]:
            new_c = blend(h, muted_bg0, 0.5)
        elif key == "cursor_text_color":
            new_c = blend(h, bg_mute, 0.5)
        else:
            new_c = h
            
        out_lines.append(f"{key} {new_c}\n")
    else:
        out_lines.append(line)

with open(out_file, 'w') as f:
    f.writelines(out_lines)

os.system("killall -USR1 kitty")

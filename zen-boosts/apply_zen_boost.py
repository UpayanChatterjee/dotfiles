#!/usr/bin/env python3
import os
import json
import math

SCHEME_JSON_PATH = os.path.expanduser("~/.local/state/caelestia/scheme.json")
BOOST_JSON_PATH = os.path.expanduser("~/.config/zen-boosts/my_boost.json")


def hex_to_rgb(hex_str):
    hex_str = hex_str.lstrip('#')
    return tuple(int(hex_str[i:i + 2], 16) / 255.0 for i in (0, 2, 4))


def rgb_to_hsl(r, g, b):
    max_c = max(r, g, b)
    min_c = min(r, g, b)
    diff = max_c - min_c

    # Lightness
    l = (max_c + min_c) / 2.0

    # Saturation
    if diff == 0:
        s = 0.0
        h = 0.0
    else:
        if l < 0.5:
            s = diff / (max_c + min_c)
        else:
            s = diff / (2.0 - max_c - min_c)

        # Hue
        if max_c == r:
            h = (g - b) / diff + (6.0 if g < b else 0.0)
        elif max_c == g:
            h = (b - r) / diff + 2.0
        else:
            h = (r - g) / diff + 4.0
        h /= 6.0

    return h * 360.0, s, l


def main():
    if not os.path.exists(SCHEME_JSON_PATH):
        print(f"Error: scheme.json not found at {SCHEME_JSON_PATH}")
        return

    # 1. Read Caelestia scheme colors
    with open(SCHEME_JSON_PATH, "r") as f:
        scheme_data = json.load(f)

    colours = scheme_data.get("colours", {})
    primary_hex = colours.get("primary", "c9c3ed")
    tertiary_hex = colours.get("tertiary", "ebb9d3")

    # 2. HSL conversion for primary
    r_p, g_p, b_p = hex_to_rgb(primary_hex)
    h_p, s_p, l_p = rgb_to_hsl(r_p, g_p, b_p)

    # HSL conversion for tertiary (complementary/secondary accent)
    r_t, g_t, b_t = hex_to_rgb(tertiary_hex)
    h_t, s_t, l_t = rgb_to_hsl(r_t, g_t, b_t)

    # 3. Map to Zen Boost parameters
    # Primary hue
    dotAngleDeg = h_p

    # Boost saturation by 30% to make the colors pop and appear less muted
    vibrancy_factor = 1.3
    boosted_s = min(1.0, s_p * vibrancy_factor)
    saturation = max(0.0, min(1.0, 1.0 - boosted_s))

    # light = 0.1 + 0.9 * brightness => brightness = (light - 0.1) / 0.9
    brightness = max(0.0, min(1.0, (l_p - 0.1) / 0.9))

    # secondaryDotAngleDegDelta
    secondaryDotAngleDegDelta = (h_t - h_p) % 360.0

    # 4. Calculate visual picker dot positions
    factor = 0.3355
    dotDistance = 1.0

    angle_rad = ((dotAngleDeg - 100) * math.pi) / 180.0
    dotPos = {
        "x": 0.5 + math.cos(angle_rad) * factor * dotDistance,
        "y": 0.5 + math.sin(angle_rad) * factor * dotDistance
    }

    angle_sec_rad = ((dotAngleDeg + secondaryDotAngleDegDelta - 100) * math.pi) / 180.0
    secondaryDotPos = {
        "x": 0.5 + math.cos(angle_sec_rad) * factor * dotDistance,
        "y": 0.5 + math.sin(angle_sec_rad) * factor * dotDistance
    }

    # 5. Determine which files to update
    import glob
    boosts_dir = os.path.dirname(BOOST_JSON_PATH)
    # Automatically scan all json files in ~/.config/zen-boosts/
    target_files = glob.glob(os.path.join(boosts_dir, "*.json"))

    # Fallback to my_boost.json if no files found
    if not target_files:
        target_files = [BOOST_JSON_PATH]

    for file_path in target_files:
        boost_data = {}
        if os.path.exists(file_path):
            try:
                with open(file_path, "r") as f:
                    boost_data = json.load(f)
            except Exception as e:
                print(f"Warning: Failed to parse existing boost JSON at {file_path}, overwriting: {e}")

        # Update boost_data with new colors and parameters
        boost_data["boostName"] = boost_data.get("boostName", os.path.basename(file_path).replace(".json", "").replace("_", " ").title())
        boost_data["dotAngleDeg"] = dotAngleDeg
        boost_data["dotPos"] = dotPos
        boost_data["dotDistance"] = dotDistance
        boost_data["secondaryDotAngleDegDelta"] = secondaryDotAngleDegDelta
        boost_data["secondaryDotPos"] = secondaryDotPos
        boost_data["brightness"] = brightness
        boost_data["saturation"] = saturation
        boost_data["contrast"] = boost_data.get("contrast", 0.75)
        boost_data["fontFamily"] = boost_data.get("fontFamily", "JetBrainsMono Nerd Font")
        boost_data["enableColorBoost"] = True
        boost_data["smartInvert"] = boost_data.get("smartInvert", False)
        boost_data["autoTheme"] = False
        boost_data["textCaseOverride"] = boost_data.get("textCaseOverride", "none")
        boost_data["sizeOverride"] = boost_data.get("sizeOverride", 1)
        boost_data["zapSelectors"] = boost_data.get("zapSelectors", [])
        boost_data["customCSS"] = boost_data.get("customCSS", "")
        boost_data["changeWasMade"] = True

        # 6. Write back to file_path
        os.makedirs(os.path.dirname(file_path), exist_ok=True)
        with open(file_path, "w") as f:
            json.dump(boost_data, f, indent=2)

        print(f"Zen Boost successfully updated: {file_path}")
        print(f"  Primary: H={dotAngleDeg:.2f} S={s_p:.2f} L={l_p:.2f} -> dotAngleDeg={dotAngleDeg:.2f} saturation={saturation:.2f} brightness={brightness:.2f}")
        print(f"  Secondary: H={h_t:.2f} -> Delta={secondaryDotAngleDegDelta:.2f}")

    print("Zen Boost successfully updated with Caelestia colors:")
    print(f"  Primary: H={dotAngleDeg:.2f} S={s_p:.2f} L={l_p:.2f} -> dotAngleDeg={dotAngleDeg:.2f} saturation={saturation:.2f} brightness={brightness:.2f}")
    print(f"  Secondary: H={h_t:.2f} -> Delta={secondaryDotAngleDegDelta:.2f}")


if __name__ == "__main__":
    main()

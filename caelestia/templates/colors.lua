local mode = "{{ mode }}"
local function hex2rgb(hex)
  hex = hex:gsub("#", "")
  return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end

local function rgb2hex(r, g, b)
  return string.format("#%02x%02x%02x", math.floor(r), math.floor(g), math.floor(b))
end

local function blend(c1, c2, alpha)
  local r1, g1, b1 = hex2rgb(c1)
  local r2, g2, b2 = hex2rgb(c2)
  local r = r1 + (r2 - r1) * alpha
  local g = g1 + (g2 - g1) * alpha
  local b = b1 + (b2 - b1) * alpha
  return rgb2hex(r, g, b)
end

local function desaturate(hex, amount)
  local r, g, b = hex2rgb(hex)
  local l = 0.2126 * r + 0.7152 * g + 0.0722 * b
  local gray = rgb2hex(l, l, l)
  return blend(hex, gray, amount)
end

local p = {
  bg0 = "#{{ surface.hex }}",
  bg1 = "#{{ surfaceContainerLow.hex }}",
  bg2 = "#{{ surfaceContainer.hex }}",
  bg3 = "#{{ surfaceContainerHigh.hex }}",
  bg4 = "#{{ surfaceContainerHighest.hex }}",
  fg0 = "#{{ onSurface.hex }}",
  fg1 = "#{{ onSurfaceVariant.hex }}",
  fg2 = "#{{ outline.hex }}",
  fg3 = "#{{ outlineVariant.hex }}",
  fg4 = "#{{ outlineVariant.hex }}",
  primary = "#{{ primary.hex }}",
  secondary = "#{{ secondary.hex }}",
  tertiary = "#{{ tertiary.hex }}",
  error = "#{{ error.hex }}",
  primaryContainer = "#{{ primaryContainer.hex }}",
  onPrimaryContainer = "#{{ onPrimaryContainer.hex }}",
  secondaryContainer = "#{{ secondaryContainer.hex }}",
  onSecondaryContainer = "#{{ onSecondaryContainer.hex }}",
  tertiaryContainer = "#{{ tertiaryContainer.hex }}",
  onTertiaryContainer = "#{{ onTertiaryContainer.hex }}",
  errorContainer = "#{{ errorContainer.hex }}",
  onErrorContainer = "#{{ onErrorContainer.hex }}",
}

local is_dark = mode == "dark"

-- 1. Mute background colors heavily towards neutral for less eye strain
local bg_mute = is_dark and "#1c1c1e" or "#f4f4f6"
p.bg0 = blend(p.bg0, bg_mute, 0.5)
p.bg1 = blend(p.bg1, bg_mute, 0.5)
p.bg2 = blend(p.bg2, bg_mute, 0.5)
p.bg3 = blend(p.bg3, bg_mute, 0.5)
p.bg4 = blend(p.bg4, bg_mute, 0.5)

-- 2. Soften foreground slightly to avoid harsh contrast
local fg_mute = is_dark and "#d4d4d8" or "#3f3f46"
p.fg0 = blend(p.fg0, fg_mute, 0.3)
p.fg1 = blend(p.fg1, fg_mute, 0.3)

-- 3. Mute container colors gently so highlights aren't blinding
local function mute_container(hex)
  local m = desaturate(hex, 0.10)
  return blend(m, p.bg0, 0.3)
end
p.primaryContainer = mute_container(p.primaryContainer)
p.secondaryContainer = mute_container(p.secondaryContainer)
p.tertiaryContainer = mute_container(p.tertiaryContainer)
p.errorContainer = mute_container(p.errorContainer)

local bases = {
  red = "#{{ red.hex }}",
  green = "#{{ green.hex }}",
  yellow = "#{{ yellow.hex }}",
  blue = "#{{ blue.hex }}",
  purple = "#{{ mauve.hex }}",
  aqua = "#{{ sky.hex }}",
  orange = "#{{ peach.hex }}",
  pink = "#{{ pink.hex }}",
  teal = "#{{ teal.hex }}"
}

local light_source = is_dark and p.fg0 or p.bg0
local dark_source = is_dark and p.bg0 or p.fg0

for name, hex in pairs(bases) do
  -- Desaturate the base color by 15% (down from 35%) to keep more intrinsic hue
  local muted = desaturate(hex, 0.10)
  -- Blend 10% (down from 25%) towards the background to beautifully harmonize without washing out
  muted = blend(muted, p.bg0, 0.05)
  
  p[name] = muted
  p["neutral_" .. name] = muted
  -- Bright variants get a bit of foreground to pop (pastel effect)
  p["bright_" .. name] = blend(muted, light_source, 0.20)
  -- Faded/Dark variants get background to recede
  p["faded_" .. name] = blend(muted, dark_source, 0.40)
  p["dark_" .. name] = blend(muted, dark_source, 0.70)
end

return {
  mode = mode,
  palette = p
}

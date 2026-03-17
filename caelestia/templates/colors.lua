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

local is_dark = mode == "dark"
local light_source = is_dark and p.fg0 or p.bg0
local dark_source = is_dark and p.bg0 or p.fg0

for name, hex in pairs(bases) do
  p[name] = hex
  p["neutral_" .. name] = hex
  p["bright_" .. name] = blend(hex, light_source, 0.25)
  p["faded_" .. name] = blend(hex, dark_source, 0.35)
  p["dark_" .. name] = blend(hex, dark_source, 0.65)
end

return {
  mode = mode,
  palette = p
}

-- Main Hyprland Lua configuration
-- See https://wiki.hypr.land/Configuring/Start/

-- Color scheme and user variables
local vars = require("variables")

-- Load sub-configurations
require("hyprland.env")
require("hyprland.general")
require("hyprland.input")
require("hyprland.misc")
require("hyprland.animations")
require("hyprland.decoration")
require("hyprland.group")
require("hyprland.gestures")
require("monitors")
require("hyprland.execs")
require("hyprland.rules")
require("hyprland.keybinds")

-- User overrides from ~/.config/caelestia/hypr-vars.lua
local function tryLoadUserConfig(name)
    local path = vars.userConfDir .. "/" .. name .. ".lua"
    local f = io.open(path, "r")
    if f then
        f:close()
        dofile(path)
    end
end

tryLoadUserConfig("hypr-vars")
tryLoadUserConfig("hypr-user")

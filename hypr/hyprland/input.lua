-- Input configuration
local vars = require("variables")

hl.config({
    input = {
        kb_layout = "us",
        numlock_by_default = true,
        repeat_delay = 250,
        repeat_rate = 35,

        follow_mouse = 2,
        focus_on_close = 1,

        touchpad = {
            natural_scroll = true,
            disable_while_typing = vars.touchpadDisableTyping,
            scroll_factor = vars.touchpadScrollFactor,
        },
    },

    binds = {
        scroll_event_delay = 0,
    },

    cursor = {
        hotspot_padding = 1,
        -- no_hardware_cursors = true,
    },
})

-- Per-device input config
hl.device({
    name = "2.4g-receiver-mouse",
    sensitivity = -0.5,
})

hl.device({
    name = "elan1203:00-04f3:307a-touchpad",
    sensitivity = 0.75,
})

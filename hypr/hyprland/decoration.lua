-- Decoration, blur, and shadow configuration
local vars = require("variables")

hl.config({
	decoration = {
		rounding = vars.windowRounding,

		blur = {
			enabled = vars.blurEnabled,
			xray = vars.blurXray,
			special = vars.blurSpecialWs,
			ignore_opacity = true,
			new_optimizations = true,
			popups = vars.blurPopups,
			input_methods = vars.blurInputMethods,
			size = vars.blurSize,
			passes = vars.blurPasses,
			-- dusky
			-- popups_ignorealpha = 0.2,
			noise = 0.0117, -- How much noise to apply [0.0 - 1.0]
			contrast = 0.8916, -- Contrast modulation for blur [0.0 - 2.0]
			brightness = 0.8172, -- Brightness modulation for blur [0.0 - 2.0]
			vibrancy = 0.1696, -- Increase saturation of blurred colors [0.0 - 1.0]
			vibrancy_darkness = 0.0, -- How strong vibrancy effect is on dark areas [0.0 - 1.0]
		},

		shadow = {
			enabled = vars.shadowEnabled,
			range = vars.shadowRange,
			render_power = vars.shadowRenderPower,
			color = vars.shadowColour,
		},

		--dusky
		active_opacity = 0.95, -- Opacity of active windows [0.0 - 1.0]
		inactive_opacity = 0.95, -- Opacity of inactive windows [0.0 - 1.0]
		fullscreen_opacity = 1.0, -- Opacity of fullscreen windows [0.0 - 1.0]
		dim_modal = true, -- Enables dimming of parents of modal windows
		dim_inactive = true, -- Enables dimming of inactive windows
		dim_strength = 0.25, -- How much inactive windows should be dimmed [0.0 - 1.0]
		dim_special = 0.5, -- How much to dim screen when special workspace is open [0.0 - 1.0]
	},
	-- opengl = {
	-- 	force_introspection = true,
	-- },
})

return {
	mode = "{{ mode }}", -- "light" or "dark"
	palette = {
		base00 = "#{{ surface.hex }}", -- Background
		base01 = "#{{ surfaceContainerLow.hex }}", -- Lighter background (Statuslines)
		base02 = "#{{ surfaceVariant.hex }}", -- Selection/Highlight
		base03 = "#{{ outline.hex }}", -- Comments
		base04 = "#{{ onSurfaceVariant.hex }}", -- Darker foreground
		base05 = "#{{ onSurface.hex }}", -- Default text
		base06 = "#{{ onSecondaryContainer.hex }}", -- Lighter text
		base07 = "#{{ inverseOnSurface.hex }}", -- Lightest text
		base08 = "#{{ term1.hex }}", -- Variables, Red-ish
		base09 = "#{{ term3.hex }}", -- Integers, Orange-ish
		base0A = "#{{ term2.hex }}", -- Classes, Yellow-ish
		base0B = "#{{ term4.hex }}", -- Strings, Green-ish
		base0C = "#{{ term6.hex }}", -- Regex/Support, Cyan-ish
		base0D = "#{{ term5.hex }}", -- Functions, Blue-ish
		base0E = "#{{ term7.hex }}", -- Keywords, Purple-ish
		base0F = "#{{ term0.hex }}", -- Deprecated
	},
}

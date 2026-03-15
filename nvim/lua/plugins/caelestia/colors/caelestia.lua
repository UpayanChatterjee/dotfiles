-- caelestia colorscheme
-- Dynamically loads colors from Caelestia shell templates

local theme_file = vim.fn.expand("~/.local/state/caelestia/theme/colors.lua")
local status, theme = pcall(dofile, theme_file)

if not status or not theme then
  vim.notify("Caelestia theme not found. Please run 'caelestia scheme set'", vim.log.levels.WARN)
  return
end

-- Clear highlights and set basics
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

vim.o.termguicolors = true
vim.g.colors_name = "caelestia"
if theme.mode then
  vim.o.background = theme.mode
end

local c = theme.palette

-- A comprehensive set of highlights directly using the full M3 palette.
-- Bypasses base16 entirely to ensure we use all 100+ colors.
local groups = {
  -- Base Backgrounds
  Normal = { fg = c.fg0, bg = c.bg0 },
  NormalFloat = { fg = c.fg0, bg = c.bg1 },
  NormalNC = { fg = c.fg1, bg = c.bg0 },
  ColorColumn = { bg = c.bg1 },
  CursorColumn = { bg = c.bg1 },
  CursorLine = { bg = c.bg1 },
  FoldColumn = { fg = c.fg2, bg = c.bg0 },
  Folded = { fg = c.fg1, bg = c.bg1, italic = true },
  LineNr = { fg = c.fg2 },
  CursorLineNr = { fg = c.secondary, bold = true },
  SignColumn = { bg = c.bg0 },
  VertSplit = { fg = c.fg3, bg = c.bg0 },
  WinSeparator = { fg = c.fg3, bg = c.bg0 },

  -- UI Components
  Cursor = { fg = c.bg0, bg = c.fg0 },
  lCursor = { fg = c.bg0, bg = c.fg0 },
  CursorIM = { fg = c.bg0, bg = c.fg0 },
  TermCursor = { fg = c.bg0, bg = c.fg0 },
  TermCursorNC = { fg = c.bg0, bg = c.fg2 },
  Directory = { fg = c.secondary, bold = true },
  EndOfBuffer = { fg = c.bg0 },
  ErrorMsg = { fg = c.error, bold = true },
  WarningMsg = { fg = c.yellow, bold = true },
  MoreMsg = { fg = c.blue, bold = true },
  ModeMsg = { fg = c.green, bold = true },
  Question = { fg = c.aqua, bold = true },
  Title = { fg = c.primary, bold = true },
  NonText = { fg = c.fg3 },
  Whitespace = { fg = c.fg3 },
  SpecialKey = { fg = c.fg3 },
  Conceal = { fg = c.fg2 },
  MatchParen = { fg = c.primary, bg = c.bg2, bold = true, underline = true },
  Search = { fg = c.onTertiaryContainer, bg = c.tertiaryContainer },
  IncSearch = { fg = c.onPrimaryContainer, bg = c.primaryContainer, bold = true },
  Visual = { bg = c.secondaryContainer },
  VisualNOS = { bg = c.bg2 },

  -- Pmenu
  Pmenu = { fg = c.fg0, bg = c.bg2 },
  PmenuSel = { fg = c.onPrimaryContainer, bg = c.primaryContainer, bold = true },
  PmenuSbar = { bg = c.bg1 },
  PmenuThumb = { bg = c.fg3 },

  -- Statusline / Tabline
  StatusLine = { fg = c.fg0, bg = c.bg2 },
  StatusLineNC = { fg = c.fg1, bg = c.bg1 },
  TabLine = { fg = c.fg1, bg = c.bg1 },
  TabLineFill = { bg = c.bg0 },
  TabLineSel = { fg = c.onPrimaryContainer, bg = c.primaryContainer, bold = true },

  -- Spell
  SpellBad = { sp = c.error, undercurl = true },
  SpellCap = { sp = c.yellow, undercurl = true },
  SpellLocal = { sp = c.blue, undercurl = true },
  SpellRare = { sp = c.purple, undercurl = true },

  -- Standard Syntax
  Comment = { fg = c.fg1, italic = true },
  Constant = { fg = c.purple },
  String = { fg = c.green },
  Character = { fg = c.green },
  Number = { fg = c.purple },
  Boolean = { fg = c.orange },
  Float = { fg = c.purple },

  Identifier = { fg = c.fg0 },
  Function = { fg = c.secondary },

  Statement = { fg = c.primary },
  Conditional = { fg = c.primary },
  Repeat = { fg = c.primary },
  Label = { fg = c.primary },
  Operator = { fg = c.fg1 },
  Keyword = { fg = c.primary },
  Exception = { fg = c.primary },

  PreProc = { fg = c.pink },
  Include = { fg = c.pink },
  Define = { fg = c.pink },
  Macro = { fg = c.pink },
  PreCondit = { fg = c.pink },

  Type = { fg = c.tertiary },
  StorageClass = { fg = c.primary },
  Structure = { fg = c.tertiary },
  Typedef = { fg = c.tertiary },

  Special = { fg = c.orange },
  SpecialChar = { fg = c.pink },
  Tag = { fg = c.secondary },
  Delimiter = { fg = c.fg1 },
  SpecialComment = { fg = c.fg1, italic = true, bold = true },
  Debug = { fg = c.error },

  Underlined = { underline = true },
  Ignore = { fg = c.fg3 },
  Error = { fg = c.error, bg = c.errorContainer, bold = true },
  Todo = { fg = c.bg0, bg = c.yellow, bold = true },

  -- Treesitter
  ["@comment"] = { link = "Comment" },
  ["@comment.todo"] = { link = "Todo" },
  ["@comment.warning"] = { fg = c.bg0, bg = c.yellow, bold = true },
  ["@comment.error"] = { fg = c.bg0, bg = c.error, bold = true },
  ["@none"] = { bg = "NONE", fg = "NONE" },
  ["@preproc"] = { link = "PreProc" },
  ["@define"] = { link = "Define" },
  ["@operator"] = { link = "Operator" },
  ["@punctuation.delimiter"] = { link = "Delimiter" },
  ["@punctuation.bracket"] = { link = "Delimiter" },
  ["@punctuation.special"] = { link = "SpecialChar" },
  ["@string"] = { link = "String" },
  ["@string.regex"] = { fg = c.pink },
  ["@string.escape"] = { fg = c.pink },
  ["@string.special"] = { fg = c.pink },
  ["@character"] = { link = "Character" },
  ["@character.special"] = { link = "SpecialChar" },
  ["@boolean"] = { link = "Boolean" },
  ["@number"] = { link = "Number" },
  ["@float"] = { link = "Float" },
  ["@function"] = { link = "Function" },
  ["@function.builtin"] = { fg = c.secondary, italic = true },
  ["@function.call"] = { link = "Function" },
  ["@function.macro"] = { link = "Macro" },
  ["@method"] = { link = "Function" },
  ["@method.call"] = { link = "Function" },
  ["@constructor"] = { fg = c.tertiary },
  ["@parameter"] = { fg = c.fg0 },
  ["@keyword"] = { link = "Keyword" },
  ["@keyword.function"] = { fg = c.primary, italic = true },
  ["@keyword.operator"] = { link = "Operator" },
  ["@keyword.return"] = { fg = c.primary, bold = true },
  ["@conditional"] = { link = "Conditional" },
  ["@repeat"] = { link = "Repeat" },
  ["@debug"] = { link = "Debug" },
  ["@label"] = { link = "Label" },
  ["@include"] = { link = "Include" },
  ["@exception"] = { link = "Exception" },
  ["@type"] = { link = "Type" },
  ["@type.builtin"] = { fg = c.tertiary, italic = true },
  ["@type.qualifier"] = { link = "Type" },
  ["@type.definition"] = { link = "Typedef" },
  ["@storageclass"] = { link = "StorageClass" },
  ["@attribute"] = { fg = c.yellow },
  ["@field"] = { fg = c.teal },
  ["@property"] = { fg = c.teal },
  ["@variable"] = { fg = c.fg0 },
  ["@variable.builtin"] = { fg = c.blue, italic = true },
  ["@constant"] = { link = "Constant" },
  ["@constant.builtin"] = { fg = c.purple, italic = true },
  ["@constant.macro"] = { link = "Macro" },
  ["@namespace"] = { fg = c.fg1 },
  ["@symbol"] = { fg = c.orange },
  ["@tag"] = { link = "Tag" },
  ["@tag.attribute"] = { fg = c.teal },
  ["@tag.delimiter"] = { link = "Delimiter" },
  ["@text"] = { fg = c.fg0 },
  ["@text.strong"] = { bold = true },
  ["@text.emphasis"] = { italic = true },
  ["@text.underline"] = { underline = true },
  ["@text.strike"] = { strikethrough = true },
  ["@text.title"] = { fg = c.primary, bold = true },
  ["@text.literal"] = { fg = c.green },
  ["@text.uri"] = { fg = c.blue, underline = true },
  ["@text.math"] = { fg = c.aqua },
  ["@text.environment"] = { link = "Macro" },
  ["@text.environment.name"] = { link = "Type" },
  ["@text.reference"] = { fg = c.purple, bold = true },
  ["@text.note"] = { fg = c.bg0, bg = c.blue, bold = true },
  ["@text.warning"] = { fg = c.bg0, bg = c.yellow, bold = true },
  ["@text.danger"] = { fg = c.bg0, bg = c.error, bold = true },

  -- LSP Semantic Tokens
  ["@lsp.type.class"] = { link = "@type" },
  ["@lsp.type.comment"] = { link = "@comment" },
  ["@lsp.type.decorator"] = { link = "@macro" },
  ["@lsp.type.enum"] = { link = "@type" },
  ["@lsp.type.enumMember"] = { link = "@constant" },
  ["@lsp.type.events"] = { link = "@label" },
  ["@lsp.type.function"] = { link = "@function" },
  ["@lsp.type.interface"] = { link = "@type" },
  ["@lsp.type.keyword"] = { link = "@keyword" },
  ["@lsp.type.macro"] = { link = "@macro" },
  ["@lsp.type.method"] = { link = "@method" },
  ["@lsp.type.modifier"] = { link = "@type.qualifier" },
  ["@lsp.type.namespace"] = { link = "@namespace" },
  ["@lsp.type.number"] = { link = "@number" },
  ["@lsp.type.operator"] = { link = "@operator" },
  ["@lsp.type.parameter"] = { link = "@parameter" },
  ["@lsp.type.property"] = { link = "@property" },
  ["@lsp.type.regexp"] = { link = "@string.regex" },
  ["@lsp.type.string"] = { link = "@string" },
  ["@lsp.type.struct"] = { link = "@type" },
  ["@lsp.type.type"] = { link = "@type" },
  ["@lsp.type.typeParameter"] = { link = "@type.definition" },
  ["@lsp.type.variable"] = { link = "@variable" },

  -- Diagnostics
  DiagnosticError = { fg = c.error },
  DiagnosticWarn = { fg = c.yellow },
  DiagnosticInfo = { fg = c.blue },
  DiagnosticHint = { fg = c.aqua },
  DiagnosticUnderlineError = { sp = c.error, undercurl = true },
  DiagnosticUnderlineWarn = { sp = c.yellow, undercurl = true },
  DiagnosticUnderlineInfo = { sp = c.blue, undercurl = true },
  DiagnosticUnderlineHint = { sp = c.aqua, undercurl = true },
  DiagnosticSignError = { fg = c.error },
  DiagnosticSignWarn = { fg = c.yellow },
  DiagnosticSignInfo = { fg = c.blue },
  DiagnosticSignHint = { fg = c.aqua },

  -- Git
  diffAdded = { fg = c.green },
  diffRemoved = { fg = c.red },
  diffChanged = { fg = c.blue },
  DiffAdd = { bg = c.bg2, fg = c.green },
  DiffChange = { bg = c.bg2, fg = c.blue },
  DiffDelete = { bg = c.bg2, fg = c.red },
  DiffText = { bg = c.tertiaryContainer, fg = c.onTertiaryContainer },
  GitSignsAdd = { fg = c.green },
  GitSignsChange = { fg = c.blue },
  GitSignsDelete = { fg = c.red },

  -- Telescope
  TelescopeBorder = { fg = c.fg3 },
  TelescopePromptBorder = { fg = c.primary },
  TelescopeResultsBorder = { fg = c.fg3 },
  TelescopePreviewBorder = { fg = c.fg3 },
  TelescopeMatching = { fg = c.onPrimaryContainer, bg = c.primaryContainer, bold = true },
  TelescopePromptPrefix = { fg = c.primary },
  TelescopeSelection = { bg = c.bg2, bold = true },
  TelescopeSelectionCaret = { fg = c.secondary, bg = c.bg2 },
  
  -- Neo-tree
  NeoTreeDirectoryIcon = { fg = c.secondary },
  NeoTreeDirectoryName = { fg = c.secondary, bold = true },
  NeoTreeFileName = { fg = c.fg0 },
  NeoTreeSymbolicLinkTarget = { fg = c.aqua, italic = true },
  NeoTreeRootName = { fg = c.primary, bold = true },
  NeoTreeGitAdded = { fg = c.green },
  NeoTreeGitModified = { fg = c.blue },
  NeoTreeGitDeleted = { fg = c.red },
  NeoTreeGitUntracked = { fg = c.orange },
  NeoTreeGitConflict = { fg = c.error, bold = true },

  -- Mini
  MiniStatuslineModeNormal = { fg = c.bg0, bg = c.primary, bold = true },
  MiniStatuslineModeInsert = { fg = c.bg0, bg = c.secondary, bold = true },
  MiniStatuslineModeVisual = { fg = c.bg0, bg = c.green, bold = true },
  MiniStatuslineModeReplace = { fg = c.bg0, bg = c.red, bold = true },
  MiniStatuslineModeCommand = { fg = c.bg0, bg = c.yellow, bold = true },
  MiniStatuslineFilename = { fg = c.fg0, bg = c.bg1 },
  MiniStatuslineFileinfo = { fg = c.fg0, bg = c.bg1 },
}

-- Apply Highlights
for group, settings in pairs(groups) do
  vim.api.nvim_set_hl(0, group, settings)
end

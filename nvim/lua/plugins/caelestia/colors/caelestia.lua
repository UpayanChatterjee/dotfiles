-- caelestia colorscheme
-- A comprehensive, high-contrast, Gruvbox-inspired Material 3 theme

local theme_file = vim.fn.expand("~/.local/state/caelestia/theme/colors.lua")
local status, theme = pcall(dofile, theme_file)

if not status or not theme then
  vim.notify("Caelestia theme not found. Please run 'caelestia scheme set'", vim.log.levels.WARN)
  return
end

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

-- Terminal Colors
local term_colors = {
  c.bg0,
  c.neutral_red,
  c.neutral_green,
  c.neutral_yellow,
  c.neutral_blue,
  c.neutral_purple,
  c.neutral_aqua,
  c.fg4,
  c.fg2,
  c.bright_red,
  c.bright_green,
  c.bright_yellow,
  c.bright_blue,
  c.bright_purple,
  c.bright_aqua,
  c.fg1,
}
for i, color in ipairs(term_colors) do
  vim.g["terminal_color_" .. i - 1] = color
end

-- Comprehensive Mappings
local groups = {
  -- Base UI
  Normal = { fg = c.fg0, bg = c.bg0 },
  NormalFloat = { fg = c.fg0, bg = c.bg1 },
  NormalNC = { fg = c.fg1, bg = c.bg0 },
  Cursor = { fg = c.bg0, bg = c.fg0 },
  lCursor = { fg = c.bg0, bg = c.fg0 },
  CursorIM = { fg = c.bg0, bg = c.fg0 },
  TermCursor = { fg = c.bg0, bg = c.fg0 },
  TermCursorNC = { fg = c.bg0, bg = c.fg2 },
  ColorColumn = { bg = c.bg1 },
  CursorColumn = { bg = c.bg1 },
  CursorLine = { bg = c.bg1 },
  CursorLineNr = { fg = c.bright_yellow, bold = true },
  LineNr = { fg = c.fg3 },
  SignColumn = { bg = c.bg0 },
  FoldColumn = { fg = c.fg3, bg = c.bg0 },
  Folded = { fg = c.fg2, bg = c.bg1, italic = true },
  VertSplit = { fg = c.bg3, bg = c.bg0 },
  WinSeparator = { fg = c.bg3, bg = c.bg0 },
  EndOfBuffer = { fg = c.bg0 },

  -- Prompts & Messages
  ErrorMsg = { fg = c.bright_red, bold = true },
  WarningMsg = { fg = c.bright_yellow, bold = true },
  MoreMsg = { fg = c.bright_blue, bold = true },
  ModeMsg = { fg = c.bright_green, bold = true },
  Question = { fg = c.bright_aqua, bold = true },
  Title = { fg = c.bright_orange, bold = true },
  Directory = { fg = c.bright_blue, bold = true },

  -- Selection & Search
  Visual = { bg = c.fg4 },
  VisualNOS = { bg = c.bg4 },
  Search = { fg = c.onTertiaryContainer, bg = c.tertiaryContainer },
  IncSearch = { fg = c.onPrimaryContainer, bg = c.primaryContainer, bold = true },
  MatchParen = { fg = c.bright_orange, bg = c.bg3, bold = true, underline = true },
  Conceal = { fg = c.fg2 },
  NonText = { fg = c.fg4 },
  Whitespace = { fg = c.fg4 },
  SpecialKey = { fg = c.fg4 },

  -- Pmenu
  Pmenu = { fg = c.fg0, bg = c.bg2 },
  PmenuSel = { fg = c.onSecondaryContainer, bg = c.secondaryContainer, bold = true },
  PmenuSbar = { bg = c.bg1 },
  PmenuThumb = { bg = c.fg3 },

  -- Tabline
  TabLine = { fg = c.fg1, bg = c.bg1 },
  TabLineFill = { bg = c.bg0 },
  TabLineSel = { fg = c.onSecondaryContainer, bg = c.secondaryContainer, bold = true },

  -- Statusline
  StatusLine = { fg = c.fg0, bg = c.bg2 },
  StatusLineNC = { fg = c.fg1, bg = c.bg1 },

  -- Spelling
  SpellBad = { sp = c.bright_red, undercurl = true },
  SpellCap = { sp = c.bright_yellow, undercurl = true },
  SpellLocal = { sp = c.bright_blue, undercurl = true },
  SpellRare = { sp = c.bright_purple, undercurl = true },

  -- Syntax (The Gruvbox Approach)
  Comment = { fg = c.fg2, italic = true },
  SpecialComment = { fg = c.faded_purple, italic = true, bold = true },
  Todo = { fg = c.bg0, bg = c.bright_yellow, bold = true },

  Constant = { fg = c.bright_purple },
  String = { fg = c.bright_green },
  Character = { fg = c.bright_green },
  Number = { fg = c.bright_purple },
  Boolean = { fg = c.bright_purple },
  Float = { fg = c.bright_purple },

  Identifier = { fg = c.bright_blue },
  Function = { fg = c.bright_green, bold = true },

  Statement = { fg = c.bright_red },
  Conditional = { fg = c.bright_red },
  Repeat = { fg = c.bright_red },
  Label = { fg = c.bright_red },
  Operator = { fg = c.bright_orange },
  Keyword = { fg = c.bright_red },
  Exception = { fg = c.bright_red },

  PreProc = { fg = c.bright_aqua },
  Include = { fg = c.bright_aqua },
  Define = { fg = c.bright_aqua },
  Macro = { fg = c.bright_aqua },
  PreCondit = { fg = c.bright_aqua },

  Type = { fg = c.bright_yellow },
  StorageClass = { fg = c.bright_orange },
  Structure = { fg = c.bright_aqua },
  Typedef = { fg = c.bright_yellow },

  Special = { fg = c.bright_orange },
  SpecialChar = { fg = c.bright_red },
  Tag = { fg = c.bright_aqua },
  Delimiter = { fg = c.fg1 },
  Debug = { fg = c.bright_red },
  Underlined = { underline = true },
  Ignore = { fg = c.fg4 },
  Error = { fg = c.bright_red, bg = c.errorContainer, bold = true },

  -- Treesitter
  ["@comment"] = { link = "Comment" },
  ["@none"] = { bg = "NONE", fg = "NONE" },
  ["@preproc"] = { link = "PreProc" },
  ["@define"] = { link = "Define" },
  ["@operator"] = { link = "Operator" },
  ["@punctuation.delimiter"] = { link = "Delimiter" },
  ["@punctuation.bracket"] = { fg = c.fg1 },
  ["@punctuation.special"] = { fg = c.bright_orange },

  ["@string"] = { link = "String" },
  ["@string.regex"] = { fg = c.bright_aqua },
  ["@string.escape"] = { fg = c.bright_red },
  ["@string.special"] = { fg = c.bright_red },

  ["@character"] = { link = "Character" },
  ["@character.special"] = { fg = c.bright_red },

  ["@boolean"] = { link = "Boolean" },
  ["@number"] = { link = "Number" },
  ["@float"] = { link = "Float" },

  ["@function"] = { link = "Function" },
  ["@function.builtin"] = { fg = c.bright_yellow, italic = true },
  ["@function.call"] = { link = "Function" },
  ["@function.macro"] = { link = "Macro" },

  ["@method"] = { link = "Function" },
  ["@method.call"] = { link = "Function" },
  ["@constructor"] = { fg = c.bright_yellow, bold = true },
  ["@parameter"] = { fg = c.bright_blue },

  ["@keyword"] = { link = "Keyword" },
  ["@keyword.function"] = { fg = c.bright_red, italic = true },
  ["@keyword.operator"] = { link = "Operator" },
  ["@keyword.return"] = { fg = c.bright_red, bold = true },

  ["@conditional"] = { link = "Conditional" },
  ["@repeat"] = { link = "Repeat" },
  ["@debug"] = { link = "Debug" },
  ["@label"] = { link = "Label" },
  ["@include"] = { link = "Include" },
  ["@exception"] = { link = "Exception" },

  ["@type"] = { link = "Type" },
  ["@type.builtin"] = { fg = c.bright_yellow, italic = true },
  ["@type.qualifier"] = { link = "Type" },
  ["@type.definition"] = { link = "Typedef" },
  ["@storageclass"] = { link = "StorageClass" },

  ["@attribute"] = { fg = c.bright_aqua },
  ["@field"] = { fg = c.bright_blue },
  ["@property"] = { fg = c.bright_blue },

  ["@variable"] = { fg = c.fg0 },
  ["@variable.builtin"] = { fg = c.bright_orange, italic = true },

  ["@constant"] = { link = "Constant" },
  ["@constant.builtin"] = { fg = c.bright_purple, italic = true },
  ["@constant.macro"] = { link = "Macro" },

  ["@namespace"] = { fg = c.fg1 },
  ["@symbol"] = { fg = c.bright_orange },
  ["@tag"] = { link = "Tag" },
  ["@tag.attribute"] = { fg = c.bright_aqua },
  ["@tag.delimiter"] = { link = "Delimiter" },

  ["@text"] = { fg = c.fg0 },
  ["@text.strong"] = { bold = true },
  ["@text.emphasis"] = { italic = true },
  ["@text.underline"] = { underline = true },
  ["@text.strike"] = { strikethrough = true },
  ["@text.title"] = { fg = c.bright_orange, bold = true },
  ["@text.literal"] = { fg = c.bright_green },
  ["@text.uri"] = { fg = c.bright_blue, underline = true },
  ["@text.math"] = { fg = c.bright_aqua },
  ["@text.environment"] = { link = "Macro" },
  ["@text.environment.name"] = { link = "Type" },
  ["@text.reference"] = { fg = c.bright_purple, bold = true },
  ["@text.note"] = { fg = c.bg0, bg = c.bright_blue, bold = true },
  ["@text.warning"] = { fg = c.bg0, bg = c.bright_yellow, bold = true },
  ["@text.danger"] = { fg = c.bg0, bg = c.bright_red, bold = true },

  -- LSP Semantic Tokens
  ["@lsp.type.class"] = { link = "Type" },
  ["@lsp.type.comment"] = { link = "@comment" },
  ["@lsp.type.decorator"] = { link = "@macro" },
  ["@lsp.type.enum"] = { link = "Type" },
  ["@lsp.type.enumMember"] = { link = "Constant" },
  ["@lsp.type.events"] = { link = "Label" },
  ["@lsp.type.function"] = { link = "Function" },
  ["@lsp.type.interface"] = { link = "Type" },
  ["@lsp.type.keyword"] = { link = "Keyword" },
  ["@lsp.type.macro"] = { link = "Macro" },
  ["@lsp.type.method"] = { link = "Function" },
  ["@lsp.type.modifier"] = { link = "Type" },
  ["@lsp.type.namespace"] = { link = "@namespace" },
  ["@lsp.type.number"] = { link = "Number" },
  ["@lsp.type.operator"] = { link = "Operator" },
  ["@lsp.type.parameter"] = { link = "@parameter" },
  ["@lsp.type.property"] = { link = "@property" },
  ["@lsp.type.regexp"] = { link = "String" },
  ["@lsp.type.string"] = { link = "String" },
  ["@lsp.type.struct"] = { link = "Type" },
  ["@lsp.type.type"] = { link = "Type" },
  ["@lsp.type.typeParameter"] = { link = "Type" },
  ["@lsp.type.variable"] = { link = "@variable" },

  -- Diagnostics
  DiagnosticError = { fg = c.bright_red },
  DiagnosticWarn = { fg = c.bright_yellow },
  DiagnosticInfo = { fg = c.bright_blue },
  DiagnosticHint = { fg = c.bright_aqua },
  DiagnosticUnderlineError = { sp = c.bright_red, undercurl = true },
  DiagnosticUnderlineWarn = { sp = c.bright_yellow, undercurl = true },
  DiagnosticUnderlineInfo = { sp = c.bright_blue, undercurl = true },
  DiagnosticUnderlineHint = { sp = c.bright_aqua, undercurl = true },
  DiagnosticSignError = { fg = c.bright_red },
  DiagnosticSignWarn = { fg = c.bright_yellow },
  DiagnosticSignInfo = { fg = c.bright_blue },
  DiagnosticSignHint = { fg = c.bright_aqua },
  DiagnosticFloatingError = { fg = c.bright_red, bg = c.bg1 },
  DiagnosticFloatingWarn = { fg = c.bright_yellow, bg = c.bg1 },
  DiagnosticFloatingInfo = { fg = c.bright_blue, bg = c.bg1 },
  DiagnosticFloatingHint = { fg = c.bright_aqua, bg = c.bg1 },

  -- Git / Diff
  diffAdded = { fg = c.bright_green },
  diffRemoved = { fg = c.bright_red },
  diffChanged = { fg = c.bright_aqua },
  DiffAdd = { bg = c.bg1, fg = c.bright_green },
  DiffChange = { bg = c.bg1, fg = c.bright_aqua },
  DiffDelete = { bg = c.bg1, fg = c.bright_red },
  DiffText = { bg = c.tertiaryContainer, fg = c.onTertiaryContainer },

  -- GitSigns
  GitSignsAdd = { fg = c.bright_green },
  GitSignsChange = { fg = c.bright_aqua },
  GitSignsDelete = { fg = c.bright_red },
  GitSignsAddLn = { bg = c.bg1 },
  GitSignsChangeLn = { bg = c.bg1 },
  GitSignsDeleteLn = { bg = c.bg1 },

  -- Telescope
  TelescopeBorder = { fg = c.fg3 },
  TelescopePromptBorder = { fg = c.primary },
  TelescopeMatching = { fg = c.onPrimaryContainer, bg = c.primaryContainer, bold = true },
  TelescopeSelection = { fg = c.onSecondaryContainer, bg = c.secondaryContainer, bold = true },
  TelescopeSelectionCaret = { fg = c.primary, bg = c.secondaryContainer },
  TelescopeResultsComment = { link = "Comment" },
  TelescopeTitle = { fg = c.bg0, bg = c.primary, bold = true },

  -- Snacks Picker
  SnacksPickerSelected = { fg = c.fg0, bg = c.bg4, bold = true },
  SnacksPickerListCursorLine = { bg = c.bg4 },
  SnacksPickerDirectory = { fg = c.bright_blue },
  SnacksPickerDir = { fg = c.fg2 },
  SnacksPickerPath = { fg = c.fg2 },
  SnacksPickerFile = { fg = c.fg0 },
  SnacksPickerSelectedDir = { fg = c.fg1, bg = c.bg4 },
  SnacksPickerSelectedPath = { fg = c.fg1, bg = c.bg4 },
  SnacksPickerSelectedFile = { fg = c.fg0, bg = c.bg4, bold = true },
  SnacksPickerSelectedIcon = { fg = c.bright_blue, bg = c.bg4 },
  SnacksPickerTitle = { fg = c.bg0, bg = c.primary, bold = true },
  SnacksPickerBorder = { fg = c.fg3 },
  SnacksPickerMatch = { fg = c.onPrimaryContainer, bg = c.primaryContainer, bold = true },

  -- FzfLua
  FzfLuaSelection = { fg = c.onSecondaryContainer, bg = c.secondaryContainer, bold = true },
  FzfLuaBorder = { fg = c.fg3 },
  FzfLuaTitle = { fg = c.bg0, bg = c.primary, bold = true },
  FzfLuaMatch = { fg = c.onPrimaryContainer, bg = c.primaryContainer, bold = true },

  -- Neo-tree
  NeoTreeDirectoryIcon = { fg = c.bright_blue },
  NeoTreeDirectoryName = { fg = c.bright_blue, bold = true },
  NeoTreeFileName = { fg = c.fg0 },
  NeoTreeRootName = { fg = c.bright_orange, bold = true },
  NeoTreeSymbolicLinkTarget = { fg = c.bright_aqua, italic = true },
  NeoTreeGitAdded = { fg = c.bright_green },
  NeoTreeGitModified = { fg = c.bright_blue },
  NeoTreeGitDeleted = { fg = c.bright_red },
  NeoTreeGitUntracked = { fg = c.bright_yellow },
  NeoTreeGitConflict = { fg = c.bright_red, bold = true },

  -- Mason
  MasonHighlight = { fg = c.bright_aqua },
  MasonHighlightBlock = { fg = c.bg0, bg = c.bright_blue },
  MasonHighlightBlockBold = { fg = c.bg0, bg = c.bright_blue, bold = true },
  MasonHeader = { fg = c.bg0, bg = c.bright_yellow, bold = true },
  MasonMuted = { fg = c.fg4 },
  MasonMutedBlock = { fg = c.bg0, bg = c.fg4 },

  -- Notify
  NotifyERRORBorder = { fg = c.bright_red },
  NotifyERRORIcon = { fg = c.bright_red },
  NotifyERRORTitle = { fg = c.bright_red },
  NotifyINFOBorder = { fg = c.bright_blue },
  NotifyINFOIcon = { fg = c.bright_blue },
  NotifyINFOTitle = { fg = c.bright_blue },
  NotifyWARNBorder = { fg = c.bright_yellow },
  NotifyWARNIcon = { fg = c.bright_yellow },
  NotifyWARNTitle = { fg = c.bright_yellow },

  -- Noice
  NoiceCmdlinePopupBorder = { fg = c.bright_blue },
  NoiceCmdlineIcon = { fg = c.bright_blue },
  NoiceCmdlinePopupBorderSearch = { fg = c.bright_yellow },
  NoiceCmdlineIconSearch = { fg = c.bright_yellow },

  -- WhichKey
  WhichKey = { fg = c.bright_pink },
  WhichKeyGroup = { fg = c.bright_blue, bold = true },
  WhichKeyDesc = { fg = c.bright_aqua },
  WhichKeySeparator = { fg = c.fg3 },

  -- Dashboard
  DashboardHeader = { fg = c.bright_aqua },
  DashboardCenter = { fg = c.bright_yellow },
  DashboardFooter = { fg = c.faded_purple, italic = true },
  DashboardShortCut = { fg = c.bright_orange },

  -- Mini
  MiniStatuslineModeNormal = { fg = c.bg0, bg = c.fg1, bold = true },
  MiniStatuslineModeInsert = { fg = c.bg0, bg = c.bright_blue, bold = true },
  MiniStatuslineModeVisual = { fg = c.bg0, bg = c.bright_green, bold = true },
  MiniStatuslineModeReplace = { fg = c.bg0, bg = c.bright_red, bold = true },
  MiniStatuslineModeCommand = { fg = c.bg0, bg = c.bright_yellow, bold = true },
  MiniStatuslineFilename = { fg = c.fg0, bg = c.bg1 },
  MiniStatuslineFileinfo = { fg = c.fg0, bg = c.bg1 },
  MiniCursorword = { underline = true },
  MiniCursorwordCurrent = { underline = true },
  MiniIndentscopeSymbol = { fg = c.fg4 },
  MiniIndentscopeSymbolOff = { fg = c.bright_yellow },

  -- LspSaga
  LspSagaCodeActionTitle = { fg = c.bright_orange, bold = true },
  LspSagaCodeActionBorder = { fg = c.fg1 },
  LspSagaCodeActionContent = { fg = c.bright_green },
  LspSagaHoverBorder = { fg = c.bright_orange },
  LspSagaRenameBorder = { fg = c.bright_blue },
  LspSagaDiagnosticBorder = { fg = c.bright_purple },
  LspSagaDiagnosticHeader = { fg = c.bright_green },

  -- Lazy
  LazyProgressDone = { fg = c.bright_green },
  LazyProgressTodo = { fg = c.fg3 },
  LazyButton = { bg = c.bg2 },
  LazyButtonActive = { bg = c.secondaryContainer, fg = c.onSecondaryContainer },
}

-- Apply Highlights
for group, settings in pairs(groups) do
  vim.api.nvim_set_hl(0, group, settings)
end


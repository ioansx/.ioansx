-- istheme — a brighter dark scheme: soft white ink on neutral graphite.
-- Lighter and higher-contrast than the default Neovim theme. Code mostly
-- stays ink-colored; a small muted palette marks functions, types, strings,
-- and literals. Local, no dependency. Mirrored in ghostty/themes/istheme.

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
end
vim.o.termguicolors = true
vim.o.background = "dark"
vim.g.colors_name = "istheme"

local p = {
    bg        = "#24272C", -- the slate (neutral graphite)
    bg_cur    = "#2B2F35", -- cursorline / current line
    bg_alt    = "#2E323A", -- floats, statusline, pmenu, signcolumn
    bg_sel    = "#3E4450", -- visual selection
    search    = "#544928", -- search highlight (dim gold)
    gray_nt   = "#4A4F57", -- nontext, whitespace, indent, inactive line nr
    gray      = "#828992", -- comments, line numbers
    gray_lt   = "#B6BBC3", -- punctuation, subtle text
    fg        = "#E6E8EB", -- soft white ink: foreground, most code
    fg_br     = "#F5F6F8", -- bright, for emphasis
    red       = "#EE8B80", -- errors, deletions
    green     = "#B2E084", -- strings, additions
    gold      = "#E0C088", -- functions, types
    purple    = "#C8A8EA", -- numbers, constants, booleans
    cyan      = "#82D2C6", -- special chars, escapes
    orange    = "#E89A70", -- warnings, search accents
}

local function hi(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- ── Editor UI ───────────────────────────────────────────────────────────────
hi("Normal",          { fg = p.fg, bg = p.bg })
hi("NormalNC",        { fg = p.fg, bg = p.bg })
hi("NormalFloat",     { fg = p.fg, bg = p.bg_alt })
hi("FloatBorder",     { fg = p.gray, bg = p.bg_alt })
hi("FloatTitle",      { fg = p.fg_br, bg = p.bg_alt, bold = true })
hi("Cursor",          { fg = p.bg, bg = p.fg })
hi("CursorLine",      { bg = p.bg_cur })
hi("CursorColumn",    { bg = p.bg_cur })
hi("ColorColumn",     { bg = p.bg_alt })
hi("CursorLineNr",    { fg = p.fg, bg = p.bg_cur, bold = true })
hi("LineNr",          { fg = p.gray_nt })
hi("SignColumn",      { fg = p.gray, bg = p.bg })
hi("FoldColumn",      { fg = p.gray, bg = p.bg })
hi("Folded",          { fg = p.gray_lt, bg = p.bg_alt })
hi("Visual",          { bg = p.bg_sel })
hi("VisualNOS",       { bg = p.bg_sel })
hi("Search",          { fg = p.fg_br, bg = p.search })
hi("IncSearch",       { fg = p.bg, bg = p.orange })
hi("CurSearch",       { fg = p.bg, bg = p.orange })
hi("MatchParen",      { fg = p.fg_br, bg = p.bg_sel, bold = true })
hi("NonText",         { fg = p.gray_nt })
hi("Whitespace",      { fg = p.gray_nt })
hi("SpecialKey",      { fg = p.gray_nt })
hi("EndOfBuffer",     { fg = p.gray_nt })
hi("Conceal",         { fg = p.gray })
hi("Directory",       { fg = p.gold })
hi("Title",           { fg = p.fg_br, bold = true })
hi("WinSeparator",    { fg = p.gray_nt, bg = p.bg })
hi("VertSplit",       { fg = p.gray_nt, bg = p.bg })
hi("StatusLine",      { fg = p.fg, bg = p.bg_alt })
hi("StatusLineNC",    { fg = p.gray, bg = p.bg_alt })
hi("TabLine",         { fg = p.gray, bg = p.bg_alt })
hi("TabLineFill",     { bg = p.bg })
hi("TabLineSel",      { fg = p.fg_br, bg = p.bg, bold = true })
hi("WildMenu",        { fg = p.bg, bg = p.gold })
hi("QuickFixLine",    { bg = p.bg_cur })
hi("ModeMsg",         { fg = p.fg })
hi("MoreMsg",         { fg = p.green })
hi("Question",        { fg = p.green })
hi("ErrorMsg",        { fg = p.red })
hi("WarningMsg",      { fg = p.orange })
hi("MsgArea",         { fg = p.fg })
hi("MsgSeparator",    { fg = p.gray_nt, bg = p.bg_alt })

-- Popup menu (completion, snacks, etc.)
hi("Pmenu",           { fg = p.fg, bg = p.bg_alt })
hi("PmenuSel",        { fg = p.bg, bg = p.gold })
hi("PmenuKind",       { fg = p.purple, bg = p.bg_alt })
hi("PmenuKindSel",    { fg = p.bg, bg = p.gold })
hi("PmenuExtra",      { fg = p.gray, bg = p.bg_alt })
hi("PmenuExtraSel",   { fg = p.bg, bg = p.gold })
hi("PmenuSbar",       { bg = p.bg_alt })
hi("PmenuThumb",      { bg = p.gray_nt })

-- Snacks picker. Its defaults point these at NonText, which is meant for
-- invisibles and disappears on the float background — a path you can't read.
hi("SnacksPickerDir",         { fg = p.gray })
hi("SnacksPickerPathHidden",  { fg = p.gray })
hi("SnacksPickerPathIgnored", { fg = p.gray })

-- ── Legacy syntax ─────────────────────────────────────────────────────────--
hi("Comment",         { fg = p.gray })
hi("Constant",        { fg = p.purple })
hi("String",          { fg = p.green })
hi("Character",       { fg = p.green })
hi("Number",          { fg = p.purple })
hi("Float",           { fg = p.purple })
hi("Boolean",         { fg = p.purple })
hi("Identifier",      { fg = p.fg })
hi("Function",        { fg = p.gold })
hi("Statement",       { fg = p.fg })
hi("Conditional",     { fg = p.fg })
hi("Repeat",          { fg = p.fg })
hi("Label",           { fg = p.fg })
hi("Operator",        { fg = p.fg })
hi("Keyword",         { fg = p.fg })
hi("Exception",       { fg = p.red })
hi("PreProc",         { fg = p.purple })
hi("Include",         { fg = p.fg })
hi("Define",          { fg = p.purple })
hi("Macro",           { fg = p.purple })
hi("PreCondit",       { fg = p.purple })
hi("Type",            { fg = p.gold })
hi("StorageClass",    { fg = p.fg })
hi("Structure",       { fg = p.gold })
hi("Typedef",         { fg = p.gold })
hi("Special",         { fg = p.cyan })
hi("SpecialChar",     { fg = p.cyan })
hi("Tag",             { fg = p.gold })
hi("Delimiter",       { fg = p.gray_lt })
hi("SpecialComment",  { fg = p.gray_lt })
hi("Debug",           { fg = p.red })
hi("Underlined",      { fg = p.gold, underline = true })
hi("Ignore",          { fg = p.gray_nt })
hi("Error",           { fg = p.bg, bg = p.red })
hi("Todo",            { fg = p.bg, bg = p.orange, bold = true })

-- ── Treesitter ───────────────────────────────────────────────────────────--
hi("@variable",               { fg = p.fg })
hi("@variable.builtin",       { fg = p.fg })
hi("@variable.parameter",     { fg = p.fg })
hi("@variable.member",        { fg = p.fg })
hi("@property",               { fg = p.fg })
hi("@field",                  { fg = p.fg })
hi("@constant",               { fg = p.purple })
hi("@constant.builtin",       { fg = p.purple })
hi("@constant.macro",         { fg = p.purple })
hi("@module",                 { fg = p.fg })
hi("@namespace",              { fg = p.fg })
hi("@string",                 { fg = p.green })
hi("@string.escape",          { fg = p.cyan })
hi("@string.special",         { fg = p.cyan })
hi("@string.regexp",          { fg = p.cyan })
hi("@character",              { fg = p.green })
hi("@number",                 { fg = p.purple })
hi("@boolean",                { fg = p.purple })
hi("@float",                  { fg = p.purple })
hi("@function",               { fg = p.gold })
hi("@function.builtin",       { fg = p.gold })
hi("@function.call",          { fg = p.gold })
hi("@function.method",        { fg = p.gold })
hi("@function.method.call",   { fg = p.gold })
hi("@constructor",            { fg = p.gold })
hi("@keyword",                { fg = p.fg })
hi("@keyword.function",       { fg = p.fg })
hi("@keyword.operator",       { fg = p.fg })
hi("@keyword.return",         { fg = p.fg })
hi("@keyword.import",         { fg = p.fg })
hi("@keyword.conditional",    { fg = p.fg })
hi("@keyword.repeat",         { fg = p.fg })
hi("@keyword.exception",      { fg = p.red })
hi("@operator",               { fg = p.fg })
hi("@type",                   { fg = p.gold })
hi("@type.builtin",           { fg = p.gold })
hi("@type.definition",        { fg = p.gold })
hi("@attribute",              { fg = p.purple })
hi("@comment",                { fg = p.gray })
hi("@comment.error",          { fg = p.red })
hi("@comment.warning",        { fg = p.orange })
hi("@comment.todo",           { fg = p.bg, bg = p.orange, bold = true })
hi("@comment.note",           { fg = p.bg, bg = p.cyan, bold = true })
hi("@punctuation",            { fg = p.gray_lt })
hi("@punctuation.bracket",    { fg = p.gray_lt })
hi("@punctuation.delimiter",  { fg = p.gray_lt })
hi("@punctuation.special",    { fg = p.cyan })
hi("@tag",                    { fg = p.gold })
hi("@tag.attribute",          { fg = p.purple })
hi("@tag.delimiter",          { fg = p.gray_lt })

-- Markup (markdown, help, etc.)
hi("@markup.heading",         { fg = p.fg_br, bold = true })
hi("@markup.strong",          { fg = p.fg_br, bold = true })
hi("@markup.italic",          { fg = p.fg, italic = true })
hi("@markup.link",            { fg = p.gold, underline = true })
hi("@markup.link.url",        { fg = p.gray_lt, underline = true })
hi("@markup.raw",             { fg = p.green })
hi("@markup.list",            { fg = p.gold })
hi("@markup.quote",           { fg = p.gray_lt })

-- ── LSP semantic tokens ──────────────────────────────────────────────────--
hi("@lsp.type.variable",      { link = "@variable" })
hi("@lsp.type.parameter",     { link = "@variable.parameter" })
hi("@lsp.type.property",      { link = "@property" })
hi("@lsp.type.function",      { link = "@function" })
hi("@lsp.type.method",        { link = "@function.method" })
hi("@lsp.type.namespace",     { link = "@module" })
hi("@lsp.type.type",          { link = "@type" })
hi("@lsp.type.class",         { link = "@type" })
hi("@lsp.type.enum",          { link = "@type" })
hi("@lsp.type.interface",     { link = "@type" })
hi("@lsp.type.struct",        { link = "@type" })
hi("@lsp.type.keyword",       { link = "@keyword" })
hi("@lsp.type.comment",       { link = "@comment" })
hi("LspReferenceText",        { bg = p.bg_sel })
hi("LspReferenceRead",        { bg = p.bg_sel })
hi("LspReferenceWrite",       { bg = p.bg_sel })
hi("LspInlayHint",            { fg = p.gray, bg = p.bg_alt })
hi("LspSignatureActiveParameter", { fg = p.orange, bold = true })

-- ── Diagnostics ──────────────────────────────────────────────────────────--
hi("DiagnosticError",         { fg = p.red })
hi("DiagnosticWarn",          { fg = p.orange })
hi("DiagnosticInfo",          { fg = p.cyan })
hi("DiagnosticHint",          { fg = p.gray })
hi("DiagnosticOk",            { fg = p.green })
hi("DiagnosticUnderlineError", { sp = p.red, undercurl = true })
hi("DiagnosticUnderlineWarn",  { sp = p.orange, undercurl = true })
hi("DiagnosticUnderlineInfo",  { sp = p.cyan, undercurl = true })
hi("DiagnosticUnderlineHint",  { sp = p.gray, undercurl = true })
hi("DiagnosticVirtualTextError", { fg = p.red, bg = p.bg_alt })
hi("DiagnosticVirtualTextWarn",  { fg = p.orange, bg = p.bg_alt })
hi("DiagnosticVirtualTextInfo",  { fg = p.cyan, bg = p.bg_alt })
hi("DiagnosticVirtualTextHint",  { fg = p.gray, bg = p.bg_alt })

-- ── Diff / Git ───────────────────────────────────────────────────────────--
hi("DiffAdd",      { bg = "#2C3A2C" })
hi("DiffChange",   { bg = "#37352A" })
hi("DiffDelete",   { fg = p.red, bg = "#3E2C2A" })
hi("DiffText",     { bg = "#2E4155" })
hi("diffAdded",    { fg = p.green })
hi("diffRemoved",  { fg = p.red })
hi("diffChanged",  { fg = p.orange })
hi("Added",        { fg = p.green })
hi("Removed",      { fg = p.red })
hi("Changed",      { fg = p.orange })
hi("GitSignsAdd",      { fg = p.green })
hi("GitSignsChange",   { fg = p.orange })
hi("GitSignsDelete",   { fg = p.red })

-- ── Spell ────────────────────────────────────────────────────────────────--
hi("SpellBad",     { sp = p.red, undercurl = true })
hi("SpellCap",     { sp = p.orange, undercurl = true })
hi("SpellRare",    { sp = p.purple, undercurl = true })
hi("SpellLocal",   { sp = p.cyan, undercurl = true })

-- ── Terminal palette ─────────────────────────────────────────────────────--
vim.g.terminal_color_0  = "#3A3F46"
vim.g.terminal_color_1  = p.red
vim.g.terminal_color_2  = p.green
vim.g.terminal_color_3  = p.orange
vim.g.terminal_color_4  = p.gold
vim.g.terminal_color_5  = p.purple
vim.g.terminal_color_6  = p.cyan
vim.g.terminal_color_7  = p.fg
vim.g.terminal_color_8  = p.gray
vim.g.terminal_color_9  = "#F7A198"
vim.g.terminal_color_10 = "#C4EA98"
vim.g.terminal_color_11 = "#F2B28C"
vim.g.terminal_color_12 = "#F0D4A4"
vim.g.terminal_color_13 = "#D8C0F4"
vim.g.terminal_color_14 = "#98E2D6"
vim.g.terminal_color_15 = "#F5F6F8"

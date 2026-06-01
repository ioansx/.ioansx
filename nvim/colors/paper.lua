-- paper — a light, paper-inspired colorscheme: black ink on a cream page.
-- Code mostly stays black so it reads like prose; only comments, strings, and
-- literals get a restrained tint. Local, no dependency. (Inspired by vim-paper.)

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
end
vim.o.termguicolors = true
vim.o.background = "light"
vim.g.colors_name = "paper"

local p = {
    bg        = "#F2EEDE", -- the page (cream)
    bg_cur    = "#EAE5D2", -- cursorline / current line
    bg_alt    = "#E4DFCC", -- floats, statusline, pmenu, signcolumn
    bg_sel    = "#DAD3BB", -- visual selection
    search    = "#E9DFA6", -- search highlight (pale gold)
    gray_nt   = "#B8B3A0", -- nontext, whitespace, indent, inactive line nr
    gray      = "#8E8D80", -- comments, line numbers
    gray_dk   = "#5C5B50", -- inactive fg, subtle text
    fg        = "#000000", -- black ink: foreground, most code
    fg_alt    = "#1C1B16", -- near-black
    red       = "#CC3E28", -- errors, deletions
    green     = "#216609", -- strings, additions
    blue      = "#1E6FCC", -- functions, types
    purple    = "#5C21A5", -- numbers, constants, booleans
    cyan      = "#158C86", -- special chars, escapes
    yellow    = "#B58900", -- warnings, search accents
}

local function hi(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- ── Editor UI ───────────────────────────────────────────────────────────────
hi("Normal",          { fg = p.fg, bg = p.bg })
hi("NormalNC",        { fg = p.fg, bg = p.bg })
hi("NormalFloat",     { fg = p.fg, bg = p.bg_alt })
hi("FloatBorder",     { fg = p.gray, bg = p.bg_alt })
hi("FloatTitle",      { fg = p.fg, bg = p.bg_alt, bold = true })
hi("Cursor",          { fg = p.bg, bg = p.fg })
hi("CursorLine",      { bg = p.bg_cur })
hi("CursorColumn",    { bg = p.bg_cur })
hi("ColorColumn",     { bg = p.bg_alt })
hi("CursorLineNr",    { fg = p.fg, bg = p.bg_cur, bold = true })
hi("LineNr",          { fg = p.gray_nt })
hi("SignColumn",      { fg = p.gray, bg = p.bg })
hi("FoldColumn",      { fg = p.gray, bg = p.bg })
hi("Folded",          { fg = p.gray_dk, bg = p.bg_alt })
hi("Visual",          { bg = p.bg_sel })
hi("VisualNOS",       { bg = p.bg_sel })
hi("Search",          { fg = p.fg, bg = p.search })
hi("IncSearch",       { fg = p.bg, bg = p.yellow })
hi("CurSearch",       { fg = p.bg, bg = p.yellow })
hi("MatchParen",      { fg = p.fg, bg = p.bg_sel, bold = true })
hi("NonText",         { fg = p.gray_nt })
hi("Whitespace",      { fg = p.gray_nt })
hi("SpecialKey",      { fg = p.gray_nt })
hi("EndOfBuffer",     { fg = p.gray_nt })
hi("Conceal",         { fg = p.gray })
hi("Directory",       { fg = p.blue })
hi("Title",           { fg = p.fg, bold = true })
hi("WinSeparator",    { fg = p.gray_nt, bg = p.bg })
hi("VertSplit",       { fg = p.gray_nt, bg = p.bg })
hi("StatusLine",      { fg = p.fg, bg = p.bg_alt })
hi("StatusLineNC",    { fg = p.gray_dk, bg = p.bg_alt })
hi("TabLine",         { fg = p.gray_dk, bg = p.bg_alt })
hi("TabLineFill",     { bg = p.bg })
hi("TabLineSel",      { fg = p.fg, bg = p.bg, bold = true })
hi("WildMenu",        { fg = p.bg, bg = p.blue })
hi("QuickFixLine",    { bg = p.bg_cur })
hi("ModeMsg",         { fg = p.fg })
hi("MoreMsg",         { fg = p.green })
hi("Question",        { fg = p.green })
hi("ErrorMsg",        { fg = p.red })
hi("WarningMsg",      { fg = p.yellow })
hi("MsgArea",         { fg = p.fg })
hi("MsgSeparator",    { fg = p.gray_nt, bg = p.bg_alt })

-- Popup menu (completion, snacks, etc.)
hi("Pmenu",           { fg = p.fg, bg = p.bg_alt })
hi("PmenuSel",        { fg = p.bg, bg = p.blue })
hi("PmenuKind",       { fg = p.purple, bg = p.bg_alt })
hi("PmenuKindSel",    { fg = p.bg, bg = p.blue })
hi("PmenuExtra",      { fg = p.gray_dk, bg = p.bg_alt })
hi("PmenuExtraSel",   { fg = p.bg, bg = p.blue })
hi("PmenuSbar",       { bg = p.bg_alt })
hi("PmenuThumb",      { bg = p.gray_nt })

-- ── Legacy syntax ─────────────────────────────────────────────────────────--
hi("Comment",         { fg = p.gray })
hi("Constant",        { fg = p.purple })
hi("String",          { fg = p.green })
hi("Character",       { fg = p.green })
hi("Number",          { fg = p.purple })
hi("Float",           { fg = p.purple })
hi("Boolean",         { fg = p.purple })
hi("Identifier",      { fg = p.fg })
hi("Function",        { fg = p.blue })
hi("Statement",       { fg = p.fg })
hi("Conditional",     { fg = p.fg })
hi("Repeat",          { fg = p.fg })
hi("Label",           { fg = p.fg })
hi("Operator",        { fg = p.fg })
hi("Keyword",         { fg = p.fg })
hi("Exception",       { fg = p.red })
hi("PreProc",         { fg = p.purple })
hi("Include",         { fg = p.blue })
hi("Define",          { fg = p.purple })
hi("Macro",           { fg = p.purple })
hi("PreCondit",       { fg = p.purple })
hi("Type",            { fg = p.blue })
hi("StorageClass",    { fg = p.fg })
hi("Structure",       { fg = p.blue })
hi("Typedef",         { fg = p.blue })
hi("Special",         { fg = p.cyan })
hi("SpecialChar",     { fg = p.cyan })
hi("Tag",             { fg = p.blue })
hi("Delimiter",       { fg = p.gray_dk })
hi("SpecialComment",  { fg = p.gray_dk })
hi("Debug",           { fg = p.red })
hi("Underlined",      { fg = p.blue, underline = true })
hi("Ignore",          { fg = p.gray_nt })
hi("Error",           { fg = p.bg, bg = p.red })
hi("Todo",            { fg = p.bg, bg = p.yellow, bold = true })

-- ── Treesitter ───────────────────────────────────────────────────────────--
hi("@variable",               { fg = p.fg })
hi("@variable.builtin",       { fg = p.red })
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
hi("@function",               { fg = p.blue })
hi("@function.builtin",       { fg = p.blue })
hi("@function.call",          { fg = p.blue })
hi("@function.method",        { fg = p.blue })
hi("@function.method.call",   { fg = p.blue })
hi("@constructor",            { fg = p.blue })
hi("@keyword",                { fg = p.fg })
hi("@keyword.function",       { fg = p.fg })
hi("@keyword.operator",       { fg = p.fg })
hi("@keyword.return",         { fg = p.fg })
hi("@keyword.import",         { fg = p.blue })
hi("@keyword.conditional",    { fg = p.fg })
hi("@keyword.repeat",         { fg = p.fg })
hi("@keyword.exception",      { fg = p.red })
hi("@operator",               { fg = p.fg })
hi("@type",                   { fg = p.blue })
hi("@type.builtin",           { fg = p.blue })
hi("@type.definition",        { fg = p.blue })
hi("@attribute",              { fg = p.purple })
hi("@comment",                { fg = p.gray })
hi("@comment.error",          { fg = p.red })
hi("@comment.warning",        { fg = p.yellow })
hi("@comment.todo",           { fg = p.bg, bg = p.yellow, bold = true })
hi("@comment.note",           { fg = p.bg, bg = p.blue, bold = true })
hi("@punctuation",            { fg = p.gray_dk })
hi("@punctuation.bracket",    { fg = p.gray_dk })
hi("@punctuation.delimiter",  { fg = p.gray_dk })
hi("@punctuation.special",    { fg = p.cyan })
hi("@tag",                    { fg = p.blue })
hi("@tag.attribute",          { fg = p.purple })
hi("@tag.delimiter",          { fg = p.gray_dk })

-- Markup (markdown, help, etc.)
hi("@markup.heading",         { fg = p.fg, bold = true })
hi("@markup.strong",          { fg = p.fg, bold = true })
hi("@markup.italic",          { fg = p.fg, italic = true })
hi("@markup.link",            { fg = p.blue, underline = true })
hi("@markup.link.url",        { fg = p.gray_dk, underline = true })
hi("@markup.raw",             { fg = p.green })
hi("@markup.list",            { fg = p.blue })
hi("@markup.quote",           { fg = p.gray_dk })

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
hi("LspSignatureActiveParameter", { fg = p.yellow, bold = true })

-- ── Diagnostics ──────────────────────────────────────────────────────────--
hi("DiagnosticError",         { fg = p.red })
hi("DiagnosticWarn",          { fg = p.yellow })
hi("DiagnosticInfo",          { fg = p.blue })
hi("DiagnosticHint",          { fg = p.cyan })
hi("DiagnosticOk",            { fg = p.green })
hi("DiagnosticUnderlineError", { sp = p.red, undercurl = true })
hi("DiagnosticUnderlineWarn",  { sp = p.yellow, undercurl = true })
hi("DiagnosticUnderlineInfo",  { sp = p.blue, undercurl = true })
hi("DiagnosticUnderlineHint",  { sp = p.cyan, undercurl = true })
hi("DiagnosticVirtualTextError", { fg = p.red, bg = p.bg_alt })
hi("DiagnosticVirtualTextWarn",  { fg = p.yellow, bg = p.bg_alt })
hi("DiagnosticVirtualTextInfo",  { fg = p.blue, bg = p.bg_alt })
hi("DiagnosticVirtualTextHint",  { fg = p.cyan, bg = p.bg_alt })

-- ── Diff / Git ───────────────────────────────────────────────────────────--
hi("DiffAdd",      { bg = "#DCE8CC" })
hi("DiffChange",   { bg = "#E4DFCC" })
hi("DiffDelete",   { fg = p.red, bg = "#EED9D2" })
hi("DiffText",     { bg = "#CFE0EE" })
hi("diffAdded",    { fg = p.green })
hi("diffRemoved",  { fg = p.red })
hi("diffChanged",  { fg = p.yellow })
hi("Added",        { fg = p.green })
hi("Removed",      { fg = p.red })
hi("Changed",      { fg = p.yellow })
hi("GitSignsAdd",      { fg = p.green })
hi("GitSignsChange",   { fg = p.yellow })
hi("GitSignsDelete",   { fg = p.red })

-- ── Spell ────────────────────────────────────────────────────────────────--
hi("SpellBad",     { sp = p.red, undercurl = true })
hi("SpellCap",     { sp = p.yellow, undercurl = true })
hi("SpellRare",    { sp = p.purple, undercurl = true })
hi("SpellLocal",   { sp = p.cyan, undercurl = true })

-- ── Terminal palette ─────────────────────────────────────────────────────--
vim.g.terminal_color_0  = p.fg
vim.g.terminal_color_1  = p.red
vim.g.terminal_color_2  = p.green
vim.g.terminal_color_3  = p.yellow
vim.g.terminal_color_4  = p.blue
vim.g.terminal_color_5  = p.purple
vim.g.terminal_color_6  = p.cyan
vim.g.terminal_color_7  = p.gray_dk
vim.g.terminal_color_8  = p.gray
vim.g.terminal_color_9  = p.red
vim.g.terminal_color_10 = p.green
vim.g.terminal_color_11 = p.yellow
vim.g.terminal_color_12 = p.blue
vim.g.terminal_color_13 = p.purple
vim.g.terminal_color_14 = p.cyan
vim.g.terminal_color_15 = p.fg

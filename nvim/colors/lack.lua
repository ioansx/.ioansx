-- lack — a near-monochrome, lackluster-inspired colorscheme.
-- Almost everything is gray; sage (lack) is the one real accent, with a warm
-- tan for literals and a soft red kept only for errors. Local, no dependency.

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
end
vim.o.termguicolors = true
vim.o.background = "dark"
vim.g.colors_name = "lack"

local p = {
    bg       = "#0e0e0e", -- default background
    bg_alt   = "#161616", -- floats, statusline, pmenu
    bg_cur   = "#1c1c1c", -- cursorline / current line
    bg_sel   = "#2a2a2a", -- visual selection
    gray_dim = "#3a3a3a", -- end-of-buffer, indent guides
    gray_nt  = "#4a4a4a", -- nontext, whitespace, line numbers
    gray_cmt = "#5e5e5e", -- comments
    gray_pun = "#7a7a7a", -- punctuation, delimiters, inactive fg
    gray     = "#9a9a9a", -- keywords, types, operators (recede)
    fg       = "#dadada", -- luster: main foreground, variables
    fg_hi    = "#ededed", -- titles, emphasis
    lack     = "#7a8478", -- sage accent: functions, headings
    string   = "#8a9a82", -- soft sage-green for strings
    orange   = "#ccb38c", -- numbers, constants, booleans
    red      = "#cc6666", -- errors (soft)
    red_bg   = "#241616", -- diff delete bg
    add_bg   = "#16241a", -- diff add bg
    chg_bg   = "#1c2030", -- diff change bg
}

local function hi(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- ── Editor UI ───────────────────────────────────────────────────────────────
hi("Normal",          { fg = p.fg, bg = p.bg })
hi("NormalNC",        { fg = p.fg, bg = p.bg })
hi("NormalFloat",     { fg = p.fg, bg = p.bg_alt })
hi("FloatBorder",     { fg = p.gray_nt, bg = p.bg_alt })
hi("FloatTitle",      { fg = p.fg_hi, bg = p.bg_alt, bold = true })
hi("Cursor",          { fg = p.bg, bg = p.fg })
hi("CursorLine",      { bg = p.bg_cur })
hi("CursorColumn",    { bg = p.bg_cur })
hi("ColorColumn",     { bg = p.bg_alt })
hi("CursorLineNr",    { fg = p.fg, bg = p.bg_cur })
hi("LineNr",          { fg = p.gray_nt })
hi("SignColumn",      { fg = p.gray_nt, bg = p.bg })
hi("FoldColumn",      { fg = p.gray_nt, bg = p.bg })
hi("Folded",          { fg = p.gray_pun, bg = p.bg_alt })
hi("Visual",          { bg = p.bg_sel })
hi("VisualNOS",       { bg = p.bg_sel })
hi("Search",          { fg = p.bg, bg = p.lack })
hi("IncSearch",       { fg = p.bg, bg = p.orange })
hi("CurSearch",       { fg = p.bg, bg = p.orange })
hi("MatchParen",      { fg = p.fg_hi, bg = p.bg_sel, bold = true })
hi("NonText",         { fg = p.gray_nt })
hi("Whitespace",      { fg = p.gray_dim })
hi("SpecialKey",      { fg = p.gray_dim })
hi("EndOfBuffer",     { fg = p.gray_dim })
hi("Conceal",         { fg = p.gray_pun })
hi("Directory",       { fg = p.lack })
hi("Title",           { fg = p.fg_hi, bold = true })
hi("WinSeparator",    { fg = p.gray_dim, bg = p.bg })
hi("VertSplit",       { fg = p.gray_dim, bg = p.bg })
hi("StatusLine",      { fg = p.fg, bg = p.bg_alt })
hi("StatusLineNC",    { fg = p.gray_pun, bg = p.bg_alt })
hi("TabLine",         { fg = p.gray_pun, bg = p.bg_alt })
hi("TabLineFill",     { bg = p.bg })
hi("TabLineSel",      { fg = p.fg, bg = p.bg, bold = true })
hi("WildMenu",        { fg = p.bg, bg = p.lack })
hi("QuickFixLine",    { bg = p.bg_cur })
hi("ModeMsg",         { fg = p.fg })
hi("MoreMsg",         { fg = p.lack })
hi("Question",        { fg = p.lack })
hi("ErrorMsg",        { fg = p.red })
hi("WarningMsg",      { fg = p.orange })
hi("MsgArea",         { fg = p.fg })
hi("MsgSeparator",    { fg = p.gray_dim, bg = p.bg_alt })

-- Popup menu (completion, snacks, etc.)
hi("Pmenu",           { fg = p.fg, bg = p.bg_alt })
hi("PmenuSel",        { fg = p.bg, bg = p.lack })
hi("PmenuKind",       { fg = p.gray, bg = p.bg_alt })
hi("PmenuKindSel",    { fg = p.bg, bg = p.lack })
hi("PmenuExtra",      { fg = p.gray_pun, bg = p.bg_alt })
hi("PmenuExtraSel",   { fg = p.bg, bg = p.lack })
hi("PmenuSbar",       { bg = p.bg_alt })
hi("PmenuThumb",      { bg = p.gray_nt })

-- ── Legacy syntax ─────────────────────────────────────────────────────────--
hi("Comment",         { fg = p.gray_cmt })
hi("Constant",        { fg = p.orange })
hi("String",          { fg = p.string })
hi("Character",       { fg = p.string })
hi("Number",          { fg = p.orange })
hi("Float",           { fg = p.orange })
hi("Boolean",         { fg = p.orange })
hi("Identifier",      { fg = p.fg })
hi("Function",        { fg = p.lack })
hi("Statement",       { fg = p.gray })
hi("Conditional",     { fg = p.gray })
hi("Repeat",          { fg = p.gray })
hi("Label",           { fg = p.gray })
hi("Operator",        { fg = p.gray })
hi("Keyword",         { fg = p.gray })
hi("Exception",       { fg = p.gray })
hi("PreProc",         { fg = p.gray_pun })
hi("Include",         { fg = p.gray })
hi("Define",          { fg = p.gray_pun })
hi("Macro",           { fg = p.gray_pun })
hi("PreCondit",       { fg = p.gray_pun })
hi("Type",            { fg = p.gray })
hi("StorageClass",    { fg = p.gray })
hi("Structure",       { fg = p.gray })
hi("Typedef",         { fg = p.gray })
hi("Special",         { fg = p.lack })
hi("SpecialChar",     { fg = p.orange })
hi("Tag",             { fg = p.gray })
hi("Delimiter",       { fg = p.gray_pun })
hi("SpecialComment",  { fg = p.gray_pun })
hi("Debug",           { fg = p.orange })
hi("Underlined",      { fg = p.lack, underline = true })
hi("Ignore",          { fg = p.gray_dim })
hi("Error",           { fg = p.red })
hi("Todo",            { fg = p.bg, bg = p.orange, bold = true })

-- ── Treesitter ───────────────────────────────────────────────────────────--
hi("@variable",               { fg = p.fg })
hi("@variable.builtin",       { fg = p.gray })
hi("@variable.parameter",     { fg = p.fg })
hi("@variable.member",        { fg = p.fg })
hi("@property",               { fg = p.fg })
hi("@field",                  { fg = p.fg })
hi("@constant",               { fg = p.orange })
hi("@constant.builtin",       { fg = p.orange })
hi("@constant.macro",         { fg = p.gray_pun })
hi("@module",                 { fg = p.fg })
hi("@namespace",              { fg = p.fg })
hi("@string",                 { fg = p.string })
hi("@string.escape",          { fg = p.orange })
hi("@string.special",         { fg = p.orange })
hi("@string.regexp",          { fg = p.string })
hi("@character",              { fg = p.string })
hi("@number",                 { fg = p.orange })
hi("@boolean",                { fg = p.orange })
hi("@float",                  { fg = p.orange })
hi("@function",               { fg = p.lack })
hi("@function.builtin",       { fg = p.lack })
hi("@function.call",          { fg = p.lack })
hi("@function.method",        { fg = p.lack })
hi("@function.method.call",   { fg = p.lack })
hi("@constructor",            { fg = p.lack })
hi("@keyword",                { fg = p.gray })
hi("@keyword.function",       { fg = p.gray })
hi("@keyword.operator",       { fg = p.gray })
hi("@keyword.return",         { fg = p.gray })
hi("@keyword.import",         { fg = p.gray })
hi("@keyword.conditional",    { fg = p.gray })
hi("@keyword.repeat",         { fg = p.gray })
hi("@keyword.exception",      { fg = p.gray })
hi("@operator",               { fg = p.gray })
hi("@type",                   { fg = p.gray })
hi("@type.builtin",           { fg = p.gray })
hi("@type.definition",        { fg = p.gray })
hi("@attribute",              { fg = p.gray_pun })
hi("@comment",                { fg = p.gray_cmt })
hi("@comment.error",          { fg = p.red })
hi("@comment.warning",        { fg = p.orange })
hi("@comment.todo",           { fg = p.bg, bg = p.orange, bold = true })
hi("@comment.note",           { fg = p.bg, bg = p.lack, bold = true })
hi("@punctuation",            { fg = p.gray_pun })
hi("@punctuation.bracket",    { fg = p.gray_pun })
hi("@punctuation.delimiter",  { fg = p.gray_pun })
hi("@punctuation.special",    { fg = p.lack })
hi("@tag",                    { fg = p.gray })
hi("@tag.attribute",          { fg = p.fg })
hi("@tag.delimiter",          { fg = p.gray_pun })

-- Markup (markdown, help, etc.)
hi("@markup.heading",         { fg = p.fg_hi, bold = true })
hi("@markup.strong",          { fg = p.fg_hi, bold = true })
hi("@markup.italic",          { fg = p.fg, italic = true })
hi("@markup.link",            { fg = p.lack, underline = true })
hi("@markup.link.url",        { fg = p.gray_pun, underline = true })
hi("@markup.raw",             { fg = p.string })
hi("@markup.list",            { fg = p.lack })
hi("@markup.quote",           { fg = p.gray_pun })

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
hi("LspInlayHint",            { fg = p.gray_nt, bg = p.bg_alt })
hi("LspSignatureActiveParameter", { fg = p.orange, bold = true })

-- ── Diagnostics ──────────────────────────────────────────────────────────--
hi("DiagnosticError",         { fg = p.red })
hi("DiagnosticWarn",          { fg = p.orange })
hi("DiagnosticInfo",          { fg = p.gray })
hi("DiagnosticHint",          { fg = p.lack })
hi("DiagnosticOk",            { fg = p.lack })
hi("DiagnosticUnderlineError", { sp = p.red, undercurl = true })
hi("DiagnosticUnderlineWarn",  { sp = p.orange, undercurl = true })
hi("DiagnosticUnderlineInfo",  { sp = p.gray, undercurl = true })
hi("DiagnosticUnderlineHint",  { sp = p.lack, undercurl = true })
hi("DiagnosticVirtualTextError", { fg = p.red, bg = p.bg_alt })
hi("DiagnosticVirtualTextWarn",  { fg = p.orange, bg = p.bg_alt })
hi("DiagnosticVirtualTextInfo",  { fg = p.gray, bg = p.bg_alt })
hi("DiagnosticVirtualTextHint",  { fg = p.lack, bg = p.bg_alt })

-- ── Diff / Git ───────────────────────────────────────────────────────────--
hi("DiffAdd",      { bg = p.add_bg })
hi("DiffChange",   { bg = p.chg_bg })
hi("DiffDelete",   { fg = p.red, bg = p.red_bg })
hi("DiffText",     { bg = "#243046" })
hi("diffAdded",    { fg = p.lack })
hi("diffRemoved",  { fg = p.red })
hi("diffChanged",  { fg = p.orange })
hi("Added",        { fg = p.lack })
hi("Removed",      { fg = p.red })
hi("Changed",      { fg = p.orange })
hi("GitSignsAdd",      { fg = p.lack })
hi("GitSignsChange",   { fg = p.orange })
hi("GitSignsDelete",   { fg = p.red })

-- ── Spell ────────────────────────────────────────────────────────────────--
hi("SpellBad",     { sp = p.red, undercurl = true })
hi("SpellCap",     { sp = p.orange, undercurl = true })
hi("SpellRare",    { sp = p.gray, undercurl = true })
hi("SpellLocal",   { sp = p.lack, undercurl = true })

-- ── Terminal palette ─────────────────────────────────────────────────────--
vim.g.terminal_color_0  = p.bg
vim.g.terminal_color_1  = p.red
vim.g.terminal_color_2  = p.lack
vim.g.terminal_color_3  = p.orange
vim.g.terminal_color_4  = p.gray
vim.g.terminal_color_5  = p.gray_pun
vim.g.terminal_color_6  = p.string
vim.g.terminal_color_7  = p.fg
vim.g.terminal_color_8  = p.gray_nt
vim.g.terminal_color_9  = p.red
vim.g.terminal_color_10 = p.lack
vim.g.terminal_color_11 = p.orange
vim.g.terminal_color_12 = p.gray
vim.g.terminal_color_13 = p.gray_pun
vim.g.terminal_color_14 = p.string
vim.g.terminal_color_15 = p.fg_hi

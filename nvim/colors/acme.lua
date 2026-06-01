-- acme — an Acme-inspired light scheme (Rob Pike / Plan 9), designed together.
-- Cream page, pale-cyan tag bars, olive borders, gold selection. Code stays
-- black like Acme; only comments (warm tan) and strings (dark olive) are tinted.
-- Earthy accents (sienna/ochre/brick) are reserved for non-code UI: diagnostics,
-- diff, git. Local, no dependency.

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
end
vim.o.termguicolors = true
vim.o.background = "light"
vim.g.colors_name = "acme"

local p = {
    -- Acme foundation (fixed identity)
    bg        = "#FFFFEA", -- body: cream page
    fg        = "#000000", -- black ink
    tag_bg    = "#EAFFFF", -- pale cyan: statusline, tabline, floats, pmenu
    tag_hi    = "#9EEEEE", -- darker cyan: pmenu selection, tag highlight
    border    = "#99994C", -- olive: splits, borders
    sel       = "#EEEE9E", -- gold: visual selection, search
    cur_line  = "#F4F0D2", -- subtle warm tint for the current line
    line_nr   = "#B6AE8A", -- muted line numbers
    faint     = "#C9C2A0", -- nontext, whitespace, end-of-buffer
    ui_dim    = "#5A5A4A", -- inactive UI text
    -- earthy accents
    tan       = "#A89070", -- comments
    olive     = "#556B2F", -- strings
    sienna    = "#8B4513", -- diagnostics info
    ochre     = "#8A5A00", -- warnings, git change
    brick     = "#8B3A3A", -- errors, deletions
    moss      = "#5F6B3A", -- hints
}

local function hi(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- ── Editor UI ───────────────────────────────────────────────────────────────
hi("Normal",          { fg = p.fg, bg = p.bg })
hi("NormalNC",        { fg = p.fg, bg = p.bg })
hi("NormalFloat",     { fg = p.fg, bg = p.tag_bg })
hi("FloatBorder",     { fg = p.border, bg = p.tag_bg })
hi("FloatTitle",      { fg = p.fg, bg = p.tag_bg, bold = true })
hi("Cursor",          { fg = p.bg, bg = p.fg })
hi("CursorLine",      { bg = p.cur_line })
hi("CursorColumn",    { bg = p.cur_line })
hi("ColorColumn",     { bg = p.cur_line })
hi("CursorLineNr",    { fg = p.fg, bg = p.cur_line, bold = true })
hi("LineNr",          { fg = p.line_nr })
hi("SignColumn",      { fg = p.line_nr, bg = p.bg })
hi("FoldColumn",      { fg = p.line_nr, bg = p.bg })
hi("Folded",          { fg = p.ui_dim, bg = p.tag_bg })
hi("Visual",          { bg = p.sel })
hi("VisualNOS",       { bg = p.sel })
hi("Search",          { fg = p.fg, bg = p.sel })
hi("IncSearch",       { fg = p.fg, bg = "#E5C84A" })
hi("CurSearch",       { fg = p.fg, bg = "#E5C84A" })
hi("MatchParen",      { bg = p.sel, bold = true })
hi("NonText",         { fg = p.faint })
hi("Whitespace",      { fg = p.faint })
hi("SpecialKey",      { fg = p.faint })
hi("EndOfBuffer",     { fg = p.faint })
hi("Conceal",         { fg = p.ui_dim })
hi("Directory",       { fg = p.fg })
hi("Title",           { fg = p.fg, bold = true })
hi("WinSeparator",    { fg = p.border, bg = p.bg })
hi("VertSplit",       { fg = p.border, bg = p.bg })
hi("StatusLine",      { fg = p.fg, bg = p.tag_bg })
hi("StatusLineNC",    { fg = p.ui_dim, bg = p.tag_bg })
hi("TabLine",         { fg = p.ui_dim, bg = p.tag_bg })
hi("TabLineFill",     { bg = p.tag_bg })
hi("TabLineSel",      { fg = p.fg, bg = p.bg, bold = true })
hi("WildMenu",        { fg = p.fg, bg = p.tag_hi })
hi("QuickFixLine",    { bg = p.cur_line })
hi("ModeMsg",         { fg = p.fg })
hi("MoreMsg",         { fg = p.olive })
hi("Question",        { fg = p.olive })
hi("ErrorMsg",        { fg = p.brick })
hi("WarningMsg",      { fg = p.ochre })
hi("MsgArea",         { fg = p.fg })
hi("MsgSeparator",    { fg = p.border, bg = p.tag_bg })

-- Popup menu (completion, snacks, etc.)
hi("Pmenu",           { fg = p.fg, bg = p.tag_bg })
hi("PmenuSel",        { fg = p.fg, bg = p.tag_hi })
hi("PmenuKind",       { fg = p.ui_dim, bg = p.tag_bg })
hi("PmenuKindSel",    { fg = p.fg, bg = p.tag_hi })
hi("PmenuExtra",      { fg = p.ui_dim, bg = p.tag_bg })
hi("PmenuExtraSel",   { fg = p.fg, bg = p.tag_hi })
hi("PmenuSbar",       { bg = p.cur_line })
hi("PmenuThumb",      { bg = p.border })

-- ── Syntax — minimal: only comments and strings are tinted; the rest is ink ──
hi("Comment",         { fg = p.tan })
hi("SpecialComment",  { fg = p.tan })
hi("String",          { fg = p.olive })
hi("Character",       { fg = p.olive })
hi("Constant",        { fg = p.fg })
hi("Number",          { fg = p.fg })
hi("Float",           { fg = p.fg })
hi("Boolean",         { fg = p.fg })
hi("Identifier",      { fg = p.fg })
hi("Function",        { fg = p.fg })
hi("Statement",       { fg = p.fg, bold = true })
hi("Conditional",     { fg = p.fg, bold = true })
hi("Repeat",          { fg = p.fg, bold = true })
hi("Label",           { fg = p.fg })
hi("Operator",        { fg = p.fg })
hi("Keyword",         { fg = p.fg, bold = true })
hi("Exception",       { fg = p.fg, bold = true })
hi("PreProc",         { fg = p.fg })
hi("Include",         { fg = p.fg })
hi("Define",          { fg = p.fg })
hi("Macro",           { fg = p.fg })
hi("PreCondit",       { fg = p.fg })
hi("Type",            { fg = p.fg })
hi("StorageClass",    { fg = p.fg })
hi("Structure",       { fg = p.fg })
hi("Typedef",         { fg = p.fg })
hi("Special",         { fg = p.fg })
hi("SpecialChar",     { fg = p.fg })
hi("Tag",             { fg = p.fg })
hi("Delimiter",       { fg = p.fg })
hi("Debug",           { fg = p.fg })
hi("Underlined",      { fg = p.fg, underline = true })
hi("Ignore",          { fg = p.faint })
hi("Error",           { fg = p.brick })
hi("Todo",            { fg = p.fg, bg = p.sel, bold = true })

-- ── Treesitter (mirror the minimal mapping; everything inherits ink) ─────────
hi("@comment",                { fg = p.tan })
hi("@comment.documentation",  { fg = p.tan })
hi("@comment.error",          { fg = p.brick })
hi("@comment.warning",        { fg = p.ochre })
hi("@comment.todo",           { fg = p.fg, bg = p.sel, bold = true })
hi("@comment.note",           { fg = p.fg, bg = p.tag_hi, bold = true })
hi("@string",                 { fg = p.olive })
hi("@string.regexp",          { fg = p.olive })
hi("@string.special",         { fg = p.olive })
hi("@string.escape",          { fg = p.fg }) -- black, so escapes pop inside olive strings
hi("@character",              { fg = p.olive })
hi("@variable",               { fg = p.fg })
hi("@variable.builtin",       { fg = p.fg })
hi("@variable.parameter",     { fg = p.fg })
hi("@variable.member",        { fg = p.fg })
hi("@property",               { fg = p.fg })
hi("@field",                  { fg = p.fg })
hi("@constant",               { fg = p.fg })
hi("@constant.builtin",       { fg = p.fg })
hi("@module",                 { fg = p.fg })
hi("@number",                 { fg = p.fg })
hi("@boolean",                { fg = p.fg })
hi("@function",               { fg = p.fg })
hi("@function.builtin",       { fg = p.fg })
hi("@function.call",          { fg = p.fg })
hi("@function.method",        { fg = p.fg })
hi("@constructor",            { fg = p.fg })
hi("@keyword",                { fg = p.fg, bold = true })
hi("@keyword.function",       { fg = p.fg, bold = true })
hi("@keyword.return",         { fg = p.fg, bold = true })
hi("@keyword.import",         { fg = p.fg, bold = true })
hi("@keyword.conditional",    { fg = p.fg, bold = true })
hi("@keyword.repeat",         { fg = p.fg, bold = true })
hi("@keyword.exception",      { fg = p.fg, bold = true })
hi("@keyword.operator",       { fg = p.fg, bold = true })
hi("@operator",               { fg = p.fg })
hi("@type",                   { fg = p.fg })
hi("@type.builtin",           { fg = p.fg })
hi("@attribute",              { fg = p.fg })
hi("@punctuation",            { fg = p.fg })
hi("@punctuation.bracket",    { fg = p.fg })
hi("@punctuation.delimiter",  { fg = p.fg })
hi("@punctuation.special",    { fg = p.fg })
hi("@tag",                    { fg = p.fg })
hi("@tag.attribute",          { fg = p.fg })
hi("@tag.delimiter",          { fg = p.fg })

-- Markup (markdown, help): headings/emphasis via weight, links via olive
hi("@markup.heading",         { fg = p.fg, bold = true })
hi("@markup.strong",          { fg = p.fg, bold = true })
hi("@markup.italic",          { fg = p.fg, italic = true })
hi("@markup.link",            { fg = p.olive, underline = true })
hi("@markup.link.url",        { fg = p.tan, underline = true })
hi("@markup.raw",             { fg = p.olive })
hi("@markup.list",            { fg = p.fg })
hi("@markup.quote",           { fg = p.tan })

-- ── LSP semantic tokens — pin to ink so servers don't re-colorize ────────────
hi("@lsp.type.variable",      { fg = p.fg })
hi("@lsp.type.parameter",     { fg = p.fg })
hi("@lsp.type.property",      { fg = p.fg })
hi("@lsp.type.function",      { fg = p.fg })
hi("@lsp.type.method",        { fg = p.fg })
hi("@lsp.type.namespace",     { fg = p.fg })
hi("@lsp.type.type",          { fg = p.fg })
hi("@lsp.type.class",         { fg = p.fg })
hi("@lsp.type.enum",          { fg = p.fg })
hi("@lsp.type.interface",     { fg = p.fg })
hi("@lsp.type.struct",        { fg = p.fg })
hi("@lsp.type.keyword",       { fg = p.fg, bold = true })
hi("@lsp.type.comment",       { fg = p.tan })
hi("LspReferenceText",        { bg = p.sel })
hi("LspReferenceRead",        { bg = p.sel })
hi("LspReferenceWrite",       { bg = p.sel })
hi("LspInlayHint",            { fg = p.ui_dim, bg = p.tag_bg })
hi("LspSignatureActiveParameter", { fg = p.fg, bold = true })

-- ── Diagnostics ──────────────────────────────────────────────────────────--
hi("DiagnosticError",         { fg = p.brick })
hi("DiagnosticWarn",          { fg = p.ochre })
hi("DiagnosticInfo",          { fg = p.sienna })
hi("DiagnosticHint",          { fg = p.moss })
hi("DiagnosticOk",            { fg = p.olive })
hi("DiagnosticUnderlineError", { sp = p.brick, undercurl = true })
hi("DiagnosticUnderlineWarn",  { sp = p.ochre, undercurl = true })
hi("DiagnosticUnderlineInfo",  { sp = p.sienna, undercurl = true })
hi("DiagnosticUnderlineHint",  { sp = p.moss, undercurl = true })
hi("DiagnosticVirtualTextError", { fg = p.brick, bg = p.tag_bg })
hi("DiagnosticVirtualTextWarn",  { fg = p.ochre, bg = p.tag_bg })
hi("DiagnosticVirtualTextInfo",  { fg = p.sienna, bg = p.tag_bg })
hi("DiagnosticVirtualTextHint",  { fg = p.moss, bg = p.tag_bg })

-- ── Diff / Git ───────────────────────────────────────────────────────────--
hi("DiffAdd",      { bg = "#E2EBD0" })
hi("DiffChange",   { bg = "#ECE6CC" })
hi("DiffDelete",   { fg = p.brick, bg = "#F0DCD2" })
hi("DiffText",     { bg = "#DCE8C0" })
hi("diffAdded",    { fg = p.olive })
hi("diffRemoved",  { fg = p.brick })
hi("diffChanged",  { fg = p.ochre })
hi("Added",        { fg = p.olive })
hi("Removed",      { fg = p.brick })
hi("Changed",      { fg = p.ochre })
hi("GitSignsAdd",      { fg = p.olive })
hi("GitSignsChange",   { fg = p.ochre })
hi("GitSignsDelete",   { fg = p.brick })

-- ── Spell ────────────────────────────────────────────────────────────────--
hi("SpellBad",     { sp = p.brick, undercurl = true })
hi("SpellCap",     { sp = p.ochre, undercurl = true })
hi("SpellRare",    { sp = p.moss, undercurl = true })
hi("SpellLocal",   { sp = p.sienna, undercurl = true })

-- ── Terminal palette ─────────────────────────────────────────────────────--
vim.g.terminal_color_0  = p.fg
vim.g.terminal_color_1  = p.brick
vim.g.terminal_color_2  = p.olive
vim.g.terminal_color_3  = p.ochre
vim.g.terminal_color_4  = "#3A5A8A"
vim.g.terminal_color_5  = "#7A3E9D"
vim.g.terminal_color_6  = "#2F7A6A"
vim.g.terminal_color_7  = p.ui_dim
vim.g.terminal_color_8  = p.tan
vim.g.terminal_color_9  = p.brick
vim.g.terminal_color_10 = p.olive
vim.g.terminal_color_11 = p.ochre
vim.g.terminal_color_12 = "#3A5A8A"
vim.g.terminal_color_13 = "#7A3E9D"
vim.g.terminal_color_14 = "#2F7A6A"
vim.g.terminal_color_15 = p.fg

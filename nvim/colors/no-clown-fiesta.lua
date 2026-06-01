-- no-clown-fiesta — a from-scratch port of aktersnurra's no-clown-fiesta (dark).
-- A deliberately muted, low-noise dark theme: most code stays foreground-white,
-- with a small set of desaturated accents. Local, no dependency.
-- Palette and group assignments transcribed from the upstream theme.

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
end
vim.o.termguicolors = true
vim.o.background = "dark"
vim.g.colors_name = "no-clown-fiesta"

local c = {
    none                 = "NONE",
    fg                   = "#e0e1e4", -- matches ghostty No Clown Fiesta foreground
    bg                   = "#101010", -- matches ghostty No Clown Fiesta background (blacker)
    alt_bg               = "#171717", -- kept lighter: cursorline, floats, pmenu read as panels
    accent               = "#202020", -- kept lighter: pmenu, quickfix line
    gray                 = "#373737",
    medium_gray          = "#727272",
    light_gray           = "#AFAFAF",
    blue                 = "#BAD7FF",
    gray_blue            = "#7E97AB",
    medium_gray_blue     = "#A2B5C1",
    cyan                 = "#88afa2",
    red                  = "#b46958",
    green                = "#90A959",
    yellow               = "#F4BF75",
    orange               = "#FFA557",
    purple               = "#AA749F",
    magenta              = "#AA759F",
    cursor_fg            = "#18191b", -- matches ghostty cursor-text
    cursor_bg            = "#e0e1e4", -- matches ghostty cursor-color
    selection            = "#696d79", -- matches ghostty selection-background
    sign_add             = "#586935",
    sign_change          = "#51657B",
    sign_delete          = "#984936",
    error                = "#984936",
    warning              = "#ab8550",
    info                 = "#ab8550",
    hint                 = "#576f82",
    todo                 = "#578266",
    accent_lighter_blue  = "#38404f",
    accent_blue          = "#18191B",
    accent_green         = "#181B18",
    accent_red           = "#1B1818",
}

local function hi(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- ── Editor UI ───────────────────────────────────────────────────────────────
hi("Normal",          { fg = c.fg, bg = c.bg })
hi("NormalNC",        { fg = c.fg, bg = c.bg })
hi("NormalFloat",     { bg = c.alt_bg })
hi("FloatBorder",     { fg = c.light_gray })
hi("SignColumn",      { bg = c.bg })
hi("MsgArea",         { fg = c.fg, bg = c.bg })
hi("ModeMsg",         { fg = c.fg, bg = c.bg })
hi("MsgSeparator",    { fg = c.fg, bg = c.bg })
hi("Pmenu",           { fg = c.light_gray, bg = c.accent })
hi("PmenuSel",        { bg = c.blue, fg = c.gray, reverse = true })
hi("PmenuMatchSel",   { bg = c.yellow, fg = c.gray, reverse = true })
hi("PmenuSbar",       { bg = c.alt_bg })
hi("PmenuThumb",      { bg = c.light_gray })
hi("WildMenu",        { fg = c.blue, bg = c.alt_bg })
hi("CursorLineNr",    { fg = c.light_gray, bold = true })
hi("LineNr",          { fg = c.medium_gray })
hi("Folded",          { fg = c.light_gray, bg = c.alt_bg })
hi("FoldColumn",      { fg = c.light_gray, bg = c.alt_bg })
hi("Whitespace",      { fg = c.gray })
hi("VertSplit",       { fg = c.bg, bg = c.accent })
hi("WinSeparator",    { fg = c.medium_gray, bg = c.bg })
hi("CursorLine",      { bg = c.alt_bg })
hi("CursorColumn",    { bg = c.alt_bg })
hi("ColorColumn",     { bg = c.alt_bg })
hi("Visual",          { bg = c.selection })
hi("VisualNOS",       { bg = c.alt_bg })
hi("QuickFixLine",    { bg = c.accent })
hi("MatchParen",      { fg = c.blue, bg = c.bg, underline = true })
hi("Cursor",          { fg = c.cursor_fg, bg = c.cursor_bg })
hi("lCursor",         { fg = c.cursor_fg, bg = c.cursor_bg })
hi("CursorIM",        { fg = c.cursor_fg, bg = c.cursor_bg })
hi("TermCursor",      { fg = c.cursor_fg, bg = c.cursor_bg, reverse = false })
hi("TermCursorNC",    { fg = c.alt_bg, reverse = false })
hi("Conceal",         { fg = c.fg })
hi("Directory",       { fg = c.blue })
hi("SpecialKey",      { fg = c.blue })
hi("Title",           { fg = c.blue })
hi("Search",          { fg = c.orange, bg = c.alt_bg })
hi("IncSearch",       { fg = c.alt_bg, bg = c.orange })
hi("CurSearch",       { fg = c.alt_bg, bg = c.orange })
hi("Substitute",      { fg = c.alt_bg, bg = c.orange })
hi("MoreMsg",         { fg = c.cyan })
hi("Question",        { fg = c.cyan })
hi("EndOfBuffer",     { fg = c.gray })
hi("NonText",         { fg = c.fg })
hi("ErrorMsg",        { fg = c.error, bg = c.bg, bold = true })
hi("WarningMsg",      { fg = c.error, bg = c.bg })
hi("StatusLine",      { fg = c.fg, bg = c.alt_bg })
hi("StatusLineNC",    { fg = c.gray, bg = c.alt_bg })
hi("TabLine",         { fg = c.gray, bg = c.alt_bg })
hi("TabLineSel",      { fg = c.fg, bg = c.alt_bg })
hi("TabLineFill",     { fg = c.fg, bg = c.alt_bg })

-- ── Legacy syntax ─────────────────────────────────────────────────────────--
hi("Comment",         { fg = c.medium_gray })
hi("SpecialComment",  { fg = c.medium_gray })
hi("Variable",        { fg = c.fg })
hi("String",          { fg = c.medium_gray_blue })
hi("Character",       { fg = c.green })
hi("Constant",        { fg = c.fg })
hi("Number",          { fg = c.red })
hi("Boolean",         { fg = c.red })
hi("Float",           { fg = c.red })
hi("Identifier",      { fg = c.fg })
hi("Function",        { fg = c.cyan })
hi("Operator",        { fg = c.fg })
hi("Type",            { fg = c.fg })
hi("StorageClass",    { fg = c.gray_blue })
hi("Structure",       { fg = c.gray_blue })
hi("Typedef",         { fg = c.fg })
hi("Keyword",         { fg = c.gray_blue })
hi("Statement",       { fg = c.gray_blue })
hi("Conditional",     { fg = c.gray_blue })
hi("Repeat",          { fg = c.gray_blue })
hi("Label",           { fg = c.fg })
hi("Exception",       { fg = c.red })
hi("Include",         { fg = c.red })
hi("PreProc",         { fg = c.fg })
hi("Define",          { fg = c.red })
hi("Macro",           { fg = c.cyan })
hi("PreCondit",       { fg = c.medium_gray })
hi("Special",         { fg = c.fg })
hi("SpecialChar",     { fg = c.medium_gray_blue })
hi("Tag",             { fg = c.blue })
hi("Debug",           { fg = c.red })
hi("Delimiter",       { fg = c.fg })
hi("Underlined",      { underline = true })
hi("Bold",            { bold = true })
hi("Italic",          { italic = true })
hi("Ignore",          { fg = c.cyan, bg = c.bg, bold = true })
hi("Todo",            { fg = c.red, bg = c.bg, bold = true })
hi("Error",           { fg = c.error, bg = c.bg, bold = true })

-- ── Treesitter ───────────────────────────────────────────────────────────--
hi("@annotation",             { fg = c.fg })
hi("@attribute",              { fg = c.fg })
hi("@boolean",                { fg = c.red })
hi("@character",              { fg = c.green })
hi("@comment",                { link = "Comment" })
hi("@comment.documentation",  { fg = c.medium_gray })
hi("@comment.error",          { fg = c.error })
hi("@comment.note",           { fg = c.light_gray })
hi("@comment.todo",           { fg = c.todo })
hi("@comment.warning",        { fg = c.warning })
hi("@const.builtin",          { fg = c.red })
hi("@const.macro",            { fg = c.cyan })
hi("@constant",               { fg = c.fg })
hi("@constructor",            { fg = c.cyan })
hi("@diff.delta",             { fg = c.gray_blue, bg = c.accent_blue, bold = true })
hi("@error",                  { fg = c.error })
hi("@function",               { fg = c.cyan })
hi("@function.builtin",       { fg = c.cyan })
hi("@function.macro",         { fg = c.cyan })
hi("@function.method",        { fg = c.cyan })
hi("@function.method.call",   { fg = c.cyan })
hi("@keyword",                { fg = c.gray_blue })
hi("@keyword.conditional",    { fg = c.gray_blue })
hi("@keyword.coroutine",      { fg = c.gray_blue })
hi("@keyword.exception",      { fg = c.red })
hi("@keyword.function",       { fg = c.gray_blue })
hi("@keyword.import",         { fg = c.red })
hi("@keyword.operator",       { fg = c.gray_blue })
hi("@keyword.repeat",         { fg = c.gray_blue })
hi("@label",                  { fg = c.fg })
hi("@lsp.type.comment",       {})
hi("@markup",                 { fg = c.fg })
hi("@markup.italic",          { italic = true })
hi("@markup.link",            { fg = c.medium_gray_blue })
hi("@markup.list",            { fg = c.fg })
hi("@markup.list.unchecked",  { fg = c.fg })
hi("@markup.literal",         { fg = c.medium_gray })
hi("@markup.strong",          { fg = c.medium_gray })
hi("@markup.title",           { fg = c.medium_gray })
hi("@markup.underline",       { underline = true })
hi("@module",                 { fg = c.fg })
hi("@number",                 { fg = c.red })
hi("@number.float",           { fg = c.red })
hi("@operator",               { fg = c.fg })
hi("@property",               { fg = c.fg })
hi("@punctuation.bracket",    { fg = c.fg })
hi("@punctuation.delimiter",  { fg = c.fg })
hi("@string",                 { fg = c.medium_gray_blue })
hi("@string.escape",          { fg = c.medium_gray_blue })
hi("@string.regexp",          { fg = c.medium_gray_blue })
hi("@string.special.path",    { fg = c.light_gray })
hi("@string.special.symbol",  { fg = c.medium_gray })
hi("@tag",                    { fg = c.blue })
hi("@tag.attribute",          { fg = c.fg })
hi("@tag.delimiter",          { fg = c.fg })
hi("@text.uri",               { fg = c.light_gray })
hi("@type",                   { fg = c.fg })
hi("@type.builtin",           { fg = c.fg })
hi("@variable",               { fg = c.fg })
hi("@variable.builtin",       { fg = c.fg })
hi("@variable.field",         { fg = c.fg })
hi("@variable.parameter",     { fg = c.fg })
hi("@variable.parameter.reference", { fg = c.fg })

-- ── LSP / Diagnostics ────────────────────────────────────────────────────--
hi("LspReferenceRead",        { bg = "#36383F" })
hi("LspReferenceText",        { bg = "#36383F" })
hi("LspReferenceWrite",       { bg = "#36383f" })
hi("DiagnosticError",         { fg = c.error })
hi("DiagnosticWarn",          { fg = c.warning })
hi("DiagnosticInfo",          { fg = c.info })
hi("DiagnosticHint",          { fg = c.hint })
hi("DiagnosticFloatingError", { fg = c.error })
hi("DiagnosticVirtualTextError", { fg = c.error })
hi("DiagnosticVirtualTextWarn",  { fg = c.warning })
hi("DiagnosticVirtualTextInfo",  { fg = c.info })
hi("DiagnosticVirtualTextHint",  { fg = c.hint })
hi("DiagnosticUnderlineError", { sp = c.error, undercurl = true })
hi("DiagnosticUnderlineWarn",  { sp = c.warning, undercurl = true })
hi("DiagnosticUnderlineInfo",  { sp = c.info, undercurl = true })
hi("DiagnosticUnderlineHint",  { sp = c.hint, undercurl = true })
hi("LspSignatureActiveParameter", { bg = c.alt_bg, bold = true })
hi("LspInlayHint",            { bg = c.hint })

-- ── Diff / Git ───────────────────────────────────────────────────────────--
hi("DiffAdd",         { bg = c.accent_green })
hi("DiffChange",      { fg = c.sign_change, bg = c.accent_blue })
hi("DiffDelete",      { fg = c.sign_delete, bg = c.accent_red })
hi("DiffText",        { fg = c.fg, bg = c.accent_lighter_blue })
hi("Changed",         { fg = c.sign_change })
hi("SignAdd",         { fg = c.sign_add })
hi("SignChange",      { fg = c.sign_change })
hi("SignDelete",      { fg = c.sign_delete })
hi("GitSignsAdd",     { fg = c.sign_add })
hi("GitSignsChange",  { fg = c.sign_change })
hi("GitSignsDelete",  { fg = c.sign_delete })
hi("GitSignsCurrentLineBlame", { fg = c.gray })

-- ── Spell ────────────────────────────────────────────────────────────────--
hi("SpellBad",        { sp = c.error, undercurl = true })
hi("SpellCap",        { sp = c.yellow, undercurl = true })
hi("SpellLocal",      { sp = c.sign_add, undercurl = true })
hi("SpellRare",       { sp = c.purple, undercurl = true })

-- ── Terminal palette ─────────────────────────────────────────────────────--
vim.g.terminal_color_0  = c.bg
vim.g.terminal_color_1  = c.red
vim.g.terminal_color_2  = c.green
vim.g.terminal_color_3  = c.yellow
vim.g.terminal_color_4  = c.gray_blue
vim.g.terminal_color_5  = c.purple
vim.g.terminal_color_6  = c.cyan
vim.g.terminal_color_7  = c.light_gray
vim.g.terminal_color_8  = c.medium_gray
vim.g.terminal_color_9  = c.red
vim.g.terminal_color_10 = c.green
vim.g.terminal_color_11 = c.orange
vim.g.terminal_color_12 = c.blue
vim.g.terminal_color_13 = c.magenta
vim.g.terminal_color_14 = c.cyan
vim.g.terminal_color_15 = c.fg

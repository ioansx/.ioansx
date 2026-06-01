-- black-metal-immortal — a from-scratch port of the base16 black-metal
-- (immortal) palette. Pure-black, grayscale-dominant, with a cold green accent,
-- a desaturated teal, and near-white strings. Local, no dependency.

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
end
vim.o.termguicolors = true
vim.o.background = "dark"
vim.g.colors_name = "black-metal-immortal"

-- base16 palette (immortal). Only base0A (accent) differs across black-metal
-- variants; everything else is the shared black-metal base.
local c = {
    base00 = "#000000", -- background
    base01 = "#121212", -- lighter bg: cursorline, floats, statusline
    base02 = "#222222", -- selection
    base03 = "#333333", -- comments, invisibles
    base04 = "#999999", -- dark fg: line numbers active, statusline fg
    base05 = "#C1C1C1", -- default foreground
    base06 = "#999999", -- light fg
    base07 = "#C1C1C1", -- light bg / bright fg
    base08 = "#5F8787", -- teal: variables, diff delete, errors
    base09 = "#AAAAAA", -- numbers, constants, booleans
    base0A = "#556D56", -- cold green accent: types, search, classes
    base0B = "#ECEEE3", -- near-white: strings, diff add
    base0C = "#AAAAAA", -- escapes, regex, support
    base0D = "#888888", -- functions, headings
    base0E = "#999999", -- keywords, operators
    base0F = "#444444", -- delimiters, deprecated
}

local function hi(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- ── Editor UI ───────────────────────────────────────────────────────────────
hi("Normal",          { fg = c.base05, bg = c.base00 })
hi("NormalNC",        { fg = c.base05, bg = c.base00 })
hi("NormalFloat",     { fg = c.base05, bg = c.base01 })
hi("FloatBorder",     { fg = c.base03, bg = c.base01 })
hi("FloatTitle",      { fg = c.base07, bg = c.base01, bold = true })
hi("Cursor",          { fg = c.base00, bg = c.base05 })
hi("CursorLine",      { bg = c.base01 })
hi("CursorColumn",    { bg = c.base01 })
hi("ColorColumn",     { bg = c.base01 })
hi("CursorLineNr",    { fg = c.base04, bg = c.base01 })
hi("LineNr",          { fg = c.base03 })
hi("SignColumn",      { fg = c.base03, bg = c.base00 })
hi("FoldColumn",      { fg = c.base0C, bg = c.base00 })
hi("Folded",          { fg = c.base03, bg = c.base01 })
hi("Visual",          { bg = c.base02 })
hi("VisualNOS",       { bg = c.base02 })
hi("Search",          { fg = c.base01, bg = c.base0A })
hi("IncSearch",       { fg = c.base01, bg = c.base09 })
hi("CurSearch",       { fg = c.base01, bg = c.base09 })
hi("MatchParen",      { fg = c.base07, bg = c.base03, bold = true })
hi("NonText",         { fg = c.base03 })
hi("Whitespace",      { fg = c.base02 })
hi("SpecialKey",      { fg = c.base03 })
hi("EndOfBuffer",     { fg = c.base02 })
hi("Conceal",         { fg = c.base04 })
hi("Directory",       { fg = c.base0D })
hi("Title",           { fg = c.base0D, bold = true })
hi("WinSeparator",    { fg = c.base02, bg = c.base00 })
hi("VertSplit",       { fg = c.base02, bg = c.base00 })
hi("StatusLine",      { fg = c.base04, bg = c.base02 })
hi("StatusLineNC",    { fg = c.base03, bg = c.base01 })
hi("TabLine",         { fg = c.base03, bg = c.base01 })
hi("TabLineFill",     { bg = c.base00 })
hi("TabLineSel",      { fg = c.base05, bg = c.base00, bold = true })
hi("WildMenu",        { fg = c.base01, bg = c.base0A })
hi("QuickFixLine",    { bg = c.base01 })
hi("ModeMsg",         { fg = c.base05 })
hi("MoreMsg",         { fg = c.base0B })
hi("Question",        { fg = c.base0B })
hi("ErrorMsg",        { fg = c.base08 })
hi("WarningMsg",      { fg = c.base08 })
hi("MsgArea",         { fg = c.base05 })
hi("MsgSeparator",    { fg = c.base02, bg = c.base01 })

-- Popup menu (completion, snacks, etc.)
hi("Pmenu",           { fg = c.base05, bg = c.base01 })
hi("PmenuSel",        { fg = c.base01, bg = c.base0A })
hi("PmenuKind",       { fg = c.base0D, bg = c.base01 })
hi("PmenuKindSel",    { fg = c.base01, bg = c.base0A })
hi("PmenuExtra",      { fg = c.base04, bg = c.base01 })
hi("PmenuExtraSel",   { fg = c.base01, bg = c.base0A })
hi("PmenuSbar",       { bg = c.base01 })
hi("PmenuThumb",      { bg = c.base03 })

-- ── Legacy syntax ─────────────────────────────────────────────────────────--
hi("Comment",         { fg = c.base03 })
hi("Constant",        { fg = c.base09 })
hi("String",          { fg = c.base0B })
hi("Character",       { fg = c.base08 })
hi("Number",          { fg = c.base09 })
hi("Float",           { fg = c.base09 })
hi("Boolean",         { fg = c.base09 })
hi("Identifier",      { fg = c.base08 })
hi("Function",        { fg = c.base0D })
hi("Statement",       { fg = c.base0E })
hi("Conditional",     { fg = c.base0E })
hi("Repeat",          { fg = c.base0E })
hi("Label",           { fg = c.base0A })
hi("Operator",        { fg = c.base05 })
hi("Keyword",         { fg = c.base0E })
hi("Exception",       { fg = c.base08 })
hi("PreProc",         { fg = c.base0A })
hi("Include",         { fg = c.base0D })
hi("Define",          { fg = c.base0E })
hi("Macro",           { fg = c.base08 })
hi("PreCondit",       { fg = c.base0A })
hi("Type",            { fg = c.base0A })
hi("StorageClass",    { fg = c.base0A })
hi("Structure",       { fg = c.base0E })
hi("Typedef",         { fg = c.base0A })
hi("Special",         { fg = c.base0C })
hi("SpecialChar",     { fg = c.base0F })
hi("Tag",             { fg = c.base0A })
hi("Delimiter",       { fg = c.base0F })
hi("SpecialComment",  { fg = c.base0F })
hi("Debug",           { fg = c.base08 })
hi("Underlined",      { fg = c.base08, underline = true })
hi("Ignore",          { fg = c.base02 })
hi("Error",           { fg = c.base00, bg = c.base08 })
hi("Todo",            { fg = c.base0A, bg = c.base01, bold = true })

-- ── Treesitter ───────────────────────────────────────────────────────────--
hi("@variable",               { fg = c.base05 })
hi("@variable.builtin",       { fg = c.base08 })
hi("@variable.parameter",     { fg = c.base05 })
hi("@variable.member",        { fg = c.base05 })
hi("@property",               { fg = c.base05 })
hi("@field",                  { fg = c.base05 })
hi("@constant",               { fg = c.base09 })
hi("@constant.builtin",       { fg = c.base09 })
hi("@constant.macro",         { fg = c.base08 })
hi("@module",                 { fg = c.base05 })
hi("@namespace",              { fg = c.base05 })
hi("@string",                 { fg = c.base0B })
hi("@string.escape",          { fg = c.base0C })
hi("@string.special",         { fg = c.base0C })
hi("@string.regexp",          { fg = c.base0C })
hi("@character",              { fg = c.base08 })
hi("@number",                 { fg = c.base09 })
hi("@boolean",                { fg = c.base09 })
hi("@float",                  { fg = c.base09 })
hi("@function",               { fg = c.base0D })
hi("@function.builtin",       { fg = c.base0D })
hi("@function.call",          { fg = c.base0D })
hi("@function.method",        { fg = c.base0D })
hi("@function.method.call",   { fg = c.base0D })
hi("@constructor",            { fg = c.base0A })
hi("@keyword",                { fg = c.base0E })
hi("@keyword.function",       { fg = c.base0E })
hi("@keyword.operator",       { fg = c.base0E })
hi("@keyword.return",         { fg = c.base0E })
hi("@keyword.import",         { fg = c.base0D })
hi("@keyword.conditional",    { fg = c.base0E })
hi("@keyword.repeat",         { fg = c.base0E })
hi("@keyword.exception",      { fg = c.base08 })
hi("@operator",               { fg = c.base05 })
hi("@type",                   { fg = c.base0A })
hi("@type.builtin",           { fg = c.base0A })
hi("@type.definition",        { fg = c.base0A })
hi("@attribute",              { fg = c.base0A })
hi("@comment",                { fg = c.base03 })
hi("@comment.error",          { fg = c.base08 })
hi("@comment.warning",        { fg = c.base0A })
hi("@comment.todo",           { fg = c.base0A, bg = c.base01, bold = true })
hi("@comment.note",           { fg = c.base0D, bg = c.base01, bold = true })
hi("@punctuation",            { fg = c.base0F })
hi("@punctuation.bracket",    { fg = c.base0F })
hi("@punctuation.delimiter",  { fg = c.base0F })
hi("@punctuation.special",    { fg = c.base0C })
hi("@tag",                    { fg = c.base0A })
hi("@tag.attribute",          { fg = c.base05 })
hi("@tag.delimiter",          { fg = c.base0F })

-- Markup (markdown, help, etc.)
hi("@markup.heading",         { fg = c.base0D, bold = true })
hi("@markup.strong",          { fg = c.base07, bold = true })
hi("@markup.italic",          { fg = c.base05, italic = true })
hi("@markup.link",            { fg = c.base0A, underline = true })
hi("@markup.link.url",        { fg = c.base04, underline = true })
hi("@markup.raw",             { fg = c.base0B })
hi("@markup.list",            { fg = c.base0A })
hi("@markup.quote",           { fg = c.base04 })

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
hi("LspReferenceText",        { bg = c.base02 })
hi("LspReferenceRead",        { bg = c.base02 })
hi("LspReferenceWrite",       { bg = c.base02 })
hi("LspInlayHint",            { fg = c.base03, bg = c.base01 })
hi("LspSignatureActiveParameter", { fg = c.base0A, bold = true })

-- ── Diagnostics ──────────────────────────────────────────────────────────--
hi("DiagnosticError",         { fg = c.base08 })
hi("DiagnosticWarn",          { fg = c.base0A })
hi("DiagnosticInfo",          { fg = c.base0D })
hi("DiagnosticHint",          { fg = c.base0C })
hi("DiagnosticOk",            { fg = c.base0B })
hi("DiagnosticUnderlineError", { sp = c.base08, undercurl = true })
hi("DiagnosticUnderlineWarn",  { sp = c.base0A, undercurl = true })
hi("DiagnosticUnderlineInfo",  { sp = c.base0D, undercurl = true })
hi("DiagnosticUnderlineHint",  { sp = c.base0C, undercurl = true })
hi("DiagnosticVirtualTextError", { fg = c.base08, bg = c.base01 })
hi("DiagnosticVirtualTextWarn",  { fg = c.base0A, bg = c.base01 })
hi("DiagnosticVirtualTextInfo",  { fg = c.base0D, bg = c.base01 })
hi("DiagnosticVirtualTextHint",  { fg = c.base0C, bg = c.base01 })

-- ── Diff / Git ───────────────────────────────────────────────────────────--
hi("DiffAdd",      { fg = c.base0B, bg = c.base01 })
hi("DiffChange",   { fg = c.base03, bg = c.base01 })
hi("DiffDelete",   { fg = c.base08, bg = c.base01 })
hi("DiffText",     { fg = c.base0D, bg = c.base01 })
hi("diffAdded",    { fg = c.base0B })
hi("diffRemoved",  { fg = c.base08 })
hi("diffChanged",  { fg = c.base0A })
hi("Added",        { fg = c.base0B })
hi("Removed",      { fg = c.base08 })
hi("Changed",      { fg = c.base0A })
hi("GitSignsAdd",      { fg = c.base0A })
hi("GitSignsChange",   { fg = c.base0D })
hi("GitSignsDelete",   { fg = c.base08 })

-- ── Spell ────────────────────────────────────────────────────────────────--
hi("SpellBad",     { sp = c.base08, undercurl = true })
hi("SpellCap",     { sp = c.base0A, undercurl = true })
hi("SpellRare",    { sp = c.base0E, undercurl = true })
hi("SpellLocal",   { sp = c.base0C, undercurl = true })

-- ── Terminal palette ─────────────────────────────────────────────────────--
vim.g.terminal_color_0  = c.base00
vim.g.terminal_color_1  = c.base08
vim.g.terminal_color_2  = c.base0A
vim.g.terminal_color_3  = c.base09
vim.g.terminal_color_4  = c.base0D
vim.g.terminal_color_5  = c.base0E
vim.g.terminal_color_6  = c.base0C
vim.g.terminal_color_7  = c.base05
vim.g.terminal_color_8  = c.base03
vim.g.terminal_color_9  = c.base08
vim.g.terminal_color_10 = c.base0A
vim.g.terminal_color_11 = c.base09
vim.g.terminal_color_12 = c.base0D
vim.g.terminal_color_13 = c.base0E
vim.g.terminal_color_14 = c.base0C
vim.g.terminal_color_15 = c.base07

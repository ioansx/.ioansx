-- -------
-- Options
-- -------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.gdefault = true

vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

vim.opt.breakindent = true
vim.opt.smartindent = true

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.background = "dark"
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = "menu,menuone,noinsert,popup"
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.undofile = true

vim.opt.wrap = false
vim.wo.signcolumn = "yes:2"
vim.opt.winborder = "single"

-- Quick normal mode mapping.
local function nmap(lhs, rhs, opts)
    vim.keymap.set("n", lhs, rhs, opts)
end

-- ---------------
-- Smart movements
-- ---------------
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
nmap("j", "gj", { silent = true })
nmap("k", "gk", { silent = true })
nmap("n", "nzzzv", { silent = true })
nmap("N", "Nzzzv", { silent = true })
nmap("<C-d>", "<C-d>zz")
nmap("<C-u>", "<C-u>zz")

-- ------
-- Toggle
-- ------
local function toggle_inlay_hints()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(nil))
end

local function toggle_quickfix_list()
    if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
        vim.cmd("cclose")
    else
        vim.cmd("copen")
    end
end

local function toggle_location_list()
    if vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 then
        vim.cmd("lclose")
    else
        vim.cmd("lopen")
    end
end

nmap("<leader>tn", ":set rnu!<CR>", { desc = "toggle relativenumber" })
nmap("<leader>tw", ":set wrap!<CR>", { desc = "toggle wrap" })
nmap("<leader>tk", toggle_inlay_hints, { desc = "toggle inlay hints" })
nmap("<leader>tq", toggle_quickfix_list, { noremap = true, silent = true, desc = "toggle quickfix list" })
nmap("<leader>tl", toggle_location_list, { noremap = true, silent = true, desc = "toggle location list" })

-- -----------
-- Smart paste
-- -----------
vim.keymap.set({ "n", "v" }, "<leader>p", '"0p', { desc = "paste yanked" })

-- ---------
-- File yank
-- ---------
nmap("<leader>Ya", ":let @+ = expand('%:p')<CR>", { desc = "yank absolute file path" })
nmap("<leader>Yc", ":let @+ = join([expand('%:.'),  line('.')], ':')<CR>", { desc = "yank relative file path:line" })
nmap("<leader>Yf", ":let @+ = expand('%:t')<CR>", { desc = "yank file name" })
nmap("<leader>Yr", ":let @+ = expand('%:.')<CR>", { desc = "yank relative file path" })

-- -----------
-- Diagnostics
-- -----------
vim.diagnostic.config({ severity_sort = true, virtual_text = true })

local function diagnostic_copen_errors()
    vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.ERROR })
end

vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "diagnostics lopen" })
vim.keymap.set("n", "<leader>de", diagnostic_copen_errors, { desc = "diagnostics copen errors" })
vim.keymap.set("n", "<leader>da", vim.diagnostic.setqflist, { desc = "diagnostics copen all" })

nmap("gD", vim.lsp.buf.declaration, { desc = "vim.lsp.buf.declaration()" })
nmap("gd", vim.lsp.buf.definition, { desc = "vim.lsp.buf.definition()" })
nmap("grs", vim.lsp.buf.workspace_symbol, { desc = "vim.lsp.buf.workspace_symbol()" })
nmap("grX", function() vim.lsp.stop_client(vim.lsp.get_clients()) end, { desc = "LSP: stop clients" })

-- ----
-- Lazy
-- ----
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then
        error("Error cloning lazy.nvim:\n" .. out)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    'tpope/vim-sleuth',
    -- { "j-hui/fidget.nvim",  opts = {} },
    { "Saecki/crates.nvim", event = { "BufRead Cargo.toml" }, opts = {} },

    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            require("gruvbox").setup({
                italic = {
                    strings = false,
                    emphasis = false,
                    comments = false,
                    operators = false,
                    folds = false,
                },
                contrast = "hard",
            })
            vim.cmd("colorscheme gruvbox")
        end
    },

    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                on_attach = function(bufnr)
                    local gitsigns = require('gitsigns')

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    map('n', ']h', function()
                        if vim.wo.diff then
                            vim.cmd.normal({ ']h', bang = true })
                        else
                            gitsigns.nav_hunk('next')
                        end
                    end, { desc = "(Git) go to next hunk" })

                    map('n', '[h', function()
                        if vim.wo.diff then
                            vim.cmd.normal({ '[h', bang = true })
                        else
                            gitsigns.nav_hunk('prev')
                        end
                    end, { desc = "(Git) go to previous hunk" })

                    map('n', '<leader>gr', gitsigns.reset_hunk, { desc = "(Git) reset hunk" })
                    map('n', '<leader>gR', gitsigns.reset_buffer, { desc = "(Git) reset buffer" })
                    map('v', '<leader>gr', function()
                        gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
                    end, { desc = "(Git) reset hunk (visual)" })

                    map('n', '<leader>gp', gitsigns.preview_hunk, { desc = "(Git) preview hunk" })
                    map('n', '<leader>gi', gitsigns.preview_hunk_inline, { desc = "(Git) preview hunk inline" })
                    map('n', '<leader>gb', function() gitsigns.blame_line({ full = true }) end,
                        { desc = "(Git) blame line" })

                    map('n', '<leader>gd', gitsigns.diffthis, { desc = "(Git) diff this" })
                    map('n', '<leader>gD', function()
                        gitsigns.diffthis('~')
                    end, { desc = "(Git) diff this vs. previous" })

                    map('n', '<leader>gB', gitsigns.toggle_current_line_blame, { desc = "(Git) toggle blame" })
                    map('n', '<leader>gw', gitsigns.toggle_word_diff, { desc = "(Git) toggle word diff" })
                    map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { desc = "(Git) select hunk" })
                end
            })
        end
    },

    {
        "nvim-mini/mini.nvim",
        version = false,
        config = function()
            require("mini.icons").setup()
            require("mini.splitjoin").setup()
        end
    },

    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = { enabled = true },
            indent = { enabled = true, animate = { enabled = false } },
            picker = {
                enabled = true,
                layout = {
                    preset = "vertical",
                    layout = {
                        backdrop = true,
                        width = 0.9,
                        height = 0.9,
                    }
                },
            },
        },
        keys = {
            { "<leader>/",       function() Snacks.picker.grep() end,                                   desc = "Grep" },
            { "<leader>f",       function() Snacks.picker.files({ hidden = true }) end,                 desc = "Find Files" },
            { "<leader>F",       function() Snacks.picker.files({ hidden = true, ignored = true }) end, desc = "Find Files (incl. ignored)" },
            { "<leader><space>", function() Snacks.picker.buffers({ sort_lastused = true }) end,        desc = "Find Buffers" },
            { "<leader>gf",      function() Snacks.picker.git_log_file() end,                           desc = "Git Log File" },
            { "<leader>gs",      function() Snacks.picker.git_status() end,                             desc = "Git Status" },
            { "<leader>se",      function() Snacks.picker.recent() end,                                 desc = "Recent" },
            { "<leader>sr",      function() Snacks.picker.resume() end,                                 desc = "Resume" },
            { "<leader>ss",      function() Snacks.picker.lsp_workspace_symbols() end,                  desc = "LSP Workspace Symbols" },
            { "<leader>su",      function() Snacks.picker.undo() end,                                   desc = "Undo History" },
            { "<leader>sk",      function() Snacks.picker.keymaps() end,                                desc = "Keymaps" },
            { "<leader>sw",      function() Snacks.picker.grep_word() end,                              desc = "Visual selection or word" },
        }
    },

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            local wk = require("which-key")
            wk.setup({
                preset = "helix",
                delay = 1000,
            })
            nmap("<leader>?", function() wk.show({ global = false }) end, { desc = "Buffer Local Keymaps (which-key)" })
        end,
    },

    {
        "stevearc/oil.nvim",
        config = function()
            require("oil").setup({
                columns = { "icon" },
                delete_to_trash = true,
                view_options = { show_hidden = true },
            })
            nmap("-", "<CMD>Oil<CR>", { desc = "Oil (open)" })
        end,
    },

    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
            filetypes = {
                markdown = true,
                help = true,
            },
        },
    },

    {
        "saghen/blink.cmp",
        dependencies = { "fang2hou/blink-copilot" },
        version = "1.*",
        opts = {
            keymap = { preset = "default" },
            cmdline = { enabled = false },
            signature = { enabled = true },
            appearance = { nerd_font_variant = "mono" },
            completion = {
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 0,
                },
                accept = { auto_brackets = { enabled = false } },
                list = { selection = { auto_insert = false } }
            },
            sources = {
                default = { "lsp", "path", "buffer", "copilot" },
                providers = {
                    copilot = {
                        name = "copilot",
                        module = "blink-copilot",
                        score_offset = 100,
                        async = true,
                        opts = {
                            max_completions = 1,
                            max_attempts = 2,
                        }
                    },
                },
            },
            fuzzy = { implementation = "prefer_rust_with_warning" }
        },
        opts_extend = { "sources.default" },
    },

    -- {
    --     "stevearc/conform.nvim",
    --     opts = {
    --         default_format_opts = { lsp_format = "fallback" },
    --         format_on_save = { timeout_ms = 500 },
    --         formatters_by_ft = {
    --             javascript = { "npx prettier" },
    --             typescript = { "npx prettier" },
    --             svelte = { "npx prettier" },
    --             css = { "npx prettier" },
    --             json = { "prettier" },
    --             yaml = { "prettier" },
    --         },
    --     },
    -- },

    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "bashls",
                    "cssls",
                    "eslint",
                    "gopls",
                    "lua_ls",
                    "rust_analyzer",
                    "superhtml",
                    "svelte",
                    "tailwindcss",
                    "taplo",
                    "ts_ls",
                    "zls",
                },
                automatic_enable = true
            })

            vim.lsp.config["lua_ls"] = {
                settings = {
                    Lua = {
                        diagnostics = {
                            disable = { "missing-fields" },
                            globals = { "vim", "Snacks" },
                        },
                    }
                }
            }

            vim.lsp.config["rust_analyzer"] = {
                settings = {
                    ["rust-analyzer"] = {
                        completion = {
                            postfix = { enable = false },
                        },
                        check = {
                            command = "check",
                        },
                        cargo = {
                            targetDir = true,
                        }
                    }
                }

            }
        end
    },

    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local langs = {
                "bash",
                "c",
                "commonlisp",
                "css",
                "csv",
                "fish",
                "go",
                "html",
                "javascript",
                "jsdoc",
                "json",
                "lua",
                "markdown",
                "markdown_inline",
                "nu",
                "python",
                "racket",
                "rust",
                "sql",
                "svelte",
                "toml",
                "typescript",
                "vim",
                "vimdoc",
                "xml",
                "yaml",
            };
            require("nvim-treesitter.configs").setup({
                ensure_installed = langs,
                auto_install = false,
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end
    },
}, {})

-- -----------------
-- Highlight on yank
-- -----------------
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

-- ---------------
-- Format on save
-- ---------------
local prettier_ft = {
    javascript = true,
    typescript = true,
    svelte = true,
    css = true,
    json = true,
    yaml = true
}

local function find_formatter(start_dir)
    if vim.fn.executable("prettierd") == 1 then return "prettierd" end
    local dir = start_dir
    while dir and dir ~= "/" do
        local bin = dir .. "/node_modules/.bin/prettier"
        if vim.fn.executable(bin) == 1 then return bin end
        dir = vim.fn.fnamemodify(dir, ":h")
    end
    return nil
end

vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        if not prettier_ft[vim.bo.filetype] then
            vim.lsp.buf.format({ timeout_ms = 500 })
            return
        end
        local filepath = vim.api.nvim_buf_get_name(0)
        local formatter = find_formatter(vim.fn.fnamemodify(filepath, ":h"))
        if not formatter then
            vim.lsp.buf.format({ timeout_ms = 500 })
            return
        end

        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local result = vim.fn.system({ formatter, "--stdin-filepath", filepath }, table.concat(lines, "\n") .. "\n")
        if vim.v.shell_error == 0 then
            local new_lines = vim.split(result, "\n")
            if new_lines[#new_lines] == "" then table.remove(new_lines) end
            if new_lines[1] and new_lines[1]:match("^/%*!.*%*/") then table.remove(new_lines, 1) end -- strip daisyUI banner
            vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)
        end
    end,
})

-- --------
-- Shutdown
-- --------
vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        -- It's possible to stop prettierd but it's not necessary.
        -- vim.fn.system("prettierd --stop")
    end,
})

-- ------------------------
-- Highlight trailing space
-- ------------------------
vim.api.nvim_create_autocmd("BufWinEnter", {
    callback = function()
        if vim.bo.buftype == "" then
            vim.fn.matchadd("ErrorMsg", [[\s\+$]])
        end
    end
})

-- ------------
-- LSP progress
-- ------------
---@type { win: integer?, buf: integer?, timer: table? }
local LspProgress = { win = nil, buf = nil, timer = nil }

local function lsp_progress_close()
    if LspProgress.timer then
        LspProgress.timer:stop()
        LspProgress.timer = nil
    end
    if LspProgress.win and vim.api.nvim_win_is_valid(LspProgress.win) then
        vim.api.nvim_win_close(LspProgress.win, true)
    end
    LspProgress.win = nil
end

local function lsp_progress_show(title, message, percentage)
    if not LspProgress.buf or not vim.api.nvim_buf_is_valid(LspProgress.buf) then
        LspProgress.buf = vim.api.nvim_create_buf(false, true)
    end

    local max_width = math.floor(vim.o.columns * 0.5)

    local function rpad(s)
        return string.rep(" ", max_width - vim.fn.strdisplaywidth(s)) .. s
    end

    local t = title or ""
    if percentage then
        t = t .. " (" .. percentage .. "%)"
    end
    local title_line = rpad(t:sub(1, max_width))
    local msg = message or ""
    if #msg > max_width then
        msg = msg:sub(1, max_width - 1) .. "…"
    end
    local detail_line = rpad(msg:sub(1, max_width))

    vim.api.nvim_buf_set_lines(LspProgress.buf, 0, -1, false, { title_line, detail_line })
    vim.api.nvim_buf_clear_namespace(LspProgress.buf, -1, 0, -1)
    local ns = vim.api.nvim_create_namespace("lsp_progress")
    vim.api.nvim_buf_add_highlight(LspProgress.buf, ns, "Title", 0, 0, -1)
    vim.api.nvim_buf_add_highlight(LspProgress.buf, ns, "Comment", 1, 0, -1)

    local opts = {
        relative = "editor",
        width = max_width,
        height = 2,
        col = vim.o.columns - max_width,
        row = vim.o.lines - 4,
        style = "minimal",
        border = "none",
        noautocmd = true,
        focusable = false,
    }

    if LspProgress.win and vim.api.nvim_win_is_valid(LspProgress.win) then
        opts.noautocmd = nil
        vim.api.nvim_win_set_config(LspProgress.win, opts)
    else
        LspProgress.win = vim.api.nvim_open_win(LspProgress.buf, false, opts)
        vim.wo[LspProgress.win].winblend = 80
        vim.wo[LspProgress.win].winhighlight = "NormalFloat:Normal"
    end

    if LspProgress.timer then LspProgress.timer:stop() end
    LspProgress.timer = vim.defer_fn(lsp_progress_close, 2000)
end

vim.api.nvim_create_autocmd("LspProgress", {
    callback = function(ev)
        local data = ev.data.params.value
        lsp_progress_show(data.title, data.message, data.percentage)
    end,
})

-- --------------------------------
-- P(ers)i(stent) floating terminal
-- --------------------------------
local PiTermState = { win = nil, buf = nil }

local function PiTerminalOpen()
    -- If window is open, just hide it (don't kill the terminal).
    if PiTermState.win and vim.api.nvim_win_is_valid(PiTermState.win) then
        vim.api.nvim_win_close(PiTermState.win, false)
        PiTermState.win = nil
        return
    end

    -- Reuse existing buffer if still valid, otherwise create new one.
    if not PiTermState.buf or not vim.api.nvim_buf_is_valid(PiTermState.buf) then
        PiTermState.buf = vim.api.nvim_create_buf(false, true)
    end

    PiTermState.win = vim.api.nvim_open_win(PiTermState.buf, true, {
        relative = "editor",
        width = vim.o.columns,
        height = vim.o.lines - 4, -- -4 for the borders, buffer line, and command line
        col = 0,
        row = 0,
        border = "single",
        style = "minimal",
        noautocmd = true,
    })
    vim.wo[PiTermState.win].winhighlight = "NormalFloat:Normal"

    -- Start terminal only if buffer is empty (new buffer).
    if vim.bo[PiTermState.buf].buftype ~= "terminal" then
        vim.fn.jobstart(vim.o.shell, { term = true })
    end

    vim.cmd.startinsert()
end

vim.keymap.set({ "n", "t" }, "<C-7>", PiTerminalOpen, { desc = "PiTerm (float)" })

-- ---------------------------
-- Navigator floating terminal
-- ---------------------------
local NavigatorState = { win = nil, buf = nil, prev_win = nil }

local function NavigatorOpen()
    if NavigatorState.win and vim.api.nvim_win_is_valid(NavigatorState.win) then
        vim.api.nvim_win_close(NavigatorState.win, false)
        NavigatorState.win = nil
        return
    end

    if vim.fn.executable("nav") ~= 1 then
        vim.notify("nav not found in PATH", vim.log.levels.ERROR)
        return
    end

    NavigatorState.prev_win = vim.api.nvim_get_current_win()

    -- Get current buffer's directory and filename
    local bufpath = vim.api.nvim_buf_get_name(0)
    local dir = vim.fn.fnamemodify(bufpath, ":h")
    local filename = vim.fn.fnamemodify(bufpath, ":t")

    -- Fall back to cwd if buffer has no file
    if dir == "" or dir == "." then
        dir = vim.fn.getcwd()
        filename = nil
    end

    if not NavigatorState.buf or not vim.api.nvim_buf_is_valid(NavigatorState.buf) then
        NavigatorState.buf = vim.api.nvim_create_buf(false, true)
        vim.bo[NavigatorState.buf].filetype = "nav"
    end

    NavigatorState.win = vim.api.nvim_open_win(NavigatorState.buf, true, {
        relative = "editor",
        width = vim.o.columns,
        height = vim.o.lines - 2,
        col = 0,
        row = 0,
        border = "none",
        style = "minimal",
        noautocmd = true,
    })
    vim.wo[NavigatorState.win].winhighlight = "NormalFloat:Normal"

    if vim.bo[NavigatorState.buf].buftype ~= "terminal" then
        -- Build command with directory and optional select
        local cmd = "nav " .. vim.fn.shellescape(dir)
        if filename and filename ~= "" then
            cmd = cmd .. " --select " .. vim.fn.shellescape(filename)
        end

        vim.fn.jobstart(cmd, {
            term = true,
            on_exit = function()
                if NavigatorState.win and vim.api.nvim_win_is_valid(NavigatorState.win) then
                    pcall(vim.api.nvim_win_close, NavigatorState.win, true)
                end
                if NavigatorState.prev_win and vim.api.nvim_win_is_valid(NavigatorState.prev_win) then
                    pcall(vim.api.nvim_set_current_win, NavigatorState.prev_win)
                end
                NavigatorState.win = nil
                NavigatorState.buf = nil
            end,
        })
    end

    vim.cmd.startinsert()
end

vim.keymap.set({ "n", "t" }, "<C-8>", NavigatorOpen, { desc = "Navigator (float)" })

-- -------------------------
-- LazyGit floating terminal
-- -------------------------
local LazyGitState = { win = nil, buf = nil }

local function LazyGitOpen()
    -- If window is open, just hide it (don't kill lazygit).
    if LazyGitState.win and vim.api.nvim_win_is_valid(LazyGitState.win) then
        vim.api.nvim_win_close(LazyGitState.win, false)
        LazyGitState.win = nil
        return
    end

    if vim.fn.executable("lazygit") ~= 1 then
        vim.notify("lazygit not found in PATH", vim.log.levels.ERROR)
        return
    end

    -- Reuse existing buffer if still valid, otherwise create new one.
    if not LazyGitState.buf or not vim.api.nvim_buf_is_valid(LazyGitState.buf) then
        LazyGitState.buf = vim.api.nvim_create_buf(false, true)
        vim.bo[LazyGitState.buf].filetype = "lazygit"
    end

    LazyGitState.win = vim.api.nvim_open_win(LazyGitState.buf, true, {
        relative = "editor",
        width = vim.o.columns,
        height = vim.o.lines - 2, -- -2 for the command line and buffer line
        col = 0,
        row = 0,
        border = "none",
        style = "minimal",
        noautocmd = true,
    })
    vim.wo[LazyGitState.win].winhighlight = "NormalFloat:Normal"

    -- Start lazygit only if buffer is empty (new buffer).
    if vim.bo[LazyGitState.buf].buftype ~= "terminal" then
        vim.fn.jobstart("lazygit", {
            term = true,
            on_exit = function()
                if LazyGitState.win and vim.api.nvim_win_is_valid(LazyGitState.win) then
                    pcall(vim.api.nvim_win_close, LazyGitState.win, true)
                end
                LazyGitState.win = nil
                LazyGitState.buf = nil
            end,
        })
    end

    vim.cmd.startinsert()
end

vim.keymap.set({ "n", "t" }, "<C-9>", LazyGitOpen, { desc = "LazyGit (float)" })

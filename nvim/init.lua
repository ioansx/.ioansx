vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.have_nerd_font = true

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

vim.opt.completeopt = "menu,menuone,noinsert,popup"
vim.opt.cursorline = true
vim.opt.mouse = "a"
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.termguicolors = true
vim.opt.undofile = true

vim.opt.wrap = false
vim.wo.signcolumn = "yes:2"
vim.opt.winborder = "rounded"

vim.opt.clipboard = "unnamedplus"

-- Smart movements
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set("n", "j", "gj", { silent = true })
vim.keymap.set("n", "k", "gk", { silent = true })
vim.keymap.set("n", "n", "nzzzv", { silent = true })
vim.keymap.set("n", "N", "Nzzzv", { silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Toggle
vim.keymap.set("n", "<leader>th", ":noh<CR>", { desc = "toggle highlight off" })
vim.keymap.set("n", "<leader>tk", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(nil))
end, { desc = "toggle inlay hints" })
vim.keymap.set("n", "<leader>tn", ":set rnu!<CR>", { desc = "toggle relativenumber" })
vim.keymap.set("n", '<leader>tq', function()
    if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
        vim.cmd('cclose')
    else
        vim.cmd('copen')
    end
end, { noremap = true, silent = true, desc = "toggle quickfix list" })
vim.keymap.set("n", '<leader>tl', function()
    if vim.fn.getloclist(0).winid ~= 0 then
        vim.cmd('lclose')
    else
        vim.cmd('lopen')
    end
end, { noremap = true, silent = true, desc = "toggle location list" })

-- Smart paste
vim.keymap.set({ "n", "v" }, "<leader>p", '"0p', { desc = "paste yanked" })

-- File yank
vim.keymap.set("n", "<leader>Ya", ":let @+ = expand('%:p')<CR>", { desc = "yank absolute file path" })
vim.keymap.set("n", "<leader>Yc", ":let @+ = join([expand('%:.'),  line('.')], ':')<CR>",
    { desc = "yank relative file path:line" })
vim.keymap.set("n", "<leader>Yf", ":let @+ = expand('%:t')<CR>", { desc = "yank file name" })
vim.keymap.set("n", "<leader>Yr", ":let @+ = expand('%:.')<CR>", { desc = "yank relative file path" })

-- Diagnostics
vim.diagnostic.config({ severity_sort = true, virtual_text = true })
vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float, { desc = "floating diagnostic" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "diagnostics lopen" })
vim.keymap.set("n", "<leader>dq", vim.diagnostic.setqflist, { desc = "diagnostics copen" })

-- LSP
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "jump to declaration" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "jump to definition" })
vim.keymap.set('n', 'K', function()
    vim.lsp.buf.hover({
        close_events = { "BufWinLeave", "CursorMoved", "CursorMovedI", "InsertEnter" }
    })
end, { desc = "show LSP documentation" })
vim.keymap.set("n", "grX", function() vim.lsp.stop_client(vim.lsp.get_clients()) end, { desc = "LSP: stop clients" })

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

-- Non-CWD files are read-only.
local project_only_writable_group = vim.api.nvim_create_augroup("ProjectOnlyWritable", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
    group = project_only_writable_group,
    pattern = "*",
    callback = function()
        local file_path = vim.fn.expand('%:p')
        if file_path == "" then
            return
        end

        local cwd = vim.fn.getcwd()
        -- To avoid partial matches (e.g., /foo/bar vs /foo/bar-baz),
        -- we ensure the CWD path is followed by a path separator.
        local cwd_prefix = cwd .. (cwd:sub(-1) == '/' and '' or '/')

        if not (file_path:find(cwd_prefix, 1, true) or file_path == cwd) then
            vim.bo.readonly = true
        end
    end,
})

-- Lazy
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
    { "j-hui/fidget.nvim",  opts = {} },
    { "Saecki/crates.nvim", event = { "BufRead Cargo.toml" }, opts = {} },

    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            require('gruvbox').setup({
                italic = {
                    strings = false,
                    emphasis = false,
                    comments = false,
                    operators = false,
                    folds = false,
                },
            })
            vim.cmd([[colorscheme gruvbox]])
        end
    },

    {
        'nvim-mini/mini.nvim',
        version = false,
        config = function()
            local mini_clue = require("mini.clue")
            mini_clue.setup({
                triggers = {
                    { mode = 'n', keys = '<Leader>' },
                    { mode = 'x', keys = '<Leader>' },
                    { mode = 'n', keys = '[' },
                    { mode = 'n', keys = ']' },
                    { mode = 'i', keys = '<C-x>' },
                    { mode = 'n', keys = 'g' },
                    { mode = 'x', keys = 'g' },
                    { mode = 'n', keys = "'" },
                    { mode = 'n', keys = '`' },
                    { mode = 'x', keys = "'" },
                    { mode = 'x', keys = '`' },
                    { mode = 'n', keys = '"' },
                    { mode = 'x', keys = '"' },
                    { mode = 'i', keys = '<C-r>' },
                    { mode = 'c', keys = '<C-r>' },
                    { mode = 'n', keys = '<C-w>' },
                    { mode = 'n', keys = 'z' },
                    { mode = 'x', keys = 'z' },
                },
                clues = {
                    mini_clue.gen_clues.square_brackets(),
                    mini_clue.gen_clues.builtin_completion(),
                    mini_clue.gen_clues.g(),
                    mini_clue.gen_clues.marks(),
                    mini_clue.gen_clues.registers(),
                    mini_clue.gen_clues.windows(),
                    mini_clue.gen_clues.z(),
                },
                window = { config = { width = "auto" } },
            })
            require("mini.diff").setup({
                view = {
                    style = 'sign',
                    signs = { add = '▒', change = '▒', delete = '▒' },
                },
                mappings = {
                    reset = '<leader>gr',
                    goto_first = '[H',
                    goto_prev = '[h',
                    goto_next = ']h',
                    goto_last = ']H',
                },
            })
            require("mini.icons").setup()
            require("mini.trailspace").setup()
        end
    },

    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = { enabled = true },
            image = { enabled = true },
            indent = { enabled = true, animate = { enabled = false } },
            picker = {
                enabled = true,
                ui_select = false,
                layout = {
                    cycle = true,
                    layout = {
                        backdrop = true,
                        width = 0.9,
                        min_width = 80,
                        height = 0.9,
                        min_height = 30,
                        box = "vertical",
                        border = "rounded",
                        title = "{title} {live} {flags}",
                        title_pos = "center",
                        { win = "preview", title = "{preview}", height = 0.6,     border = "bottom" },
                        { win = "input",   height = 1,          border = "bottom" },
                        { win = "list",    border = "hpad" },
                    }
                },
            },
            words = { enabled = true },
        },
        keys = {
            { "<leader>/",       function() Snacks.picker.grep() end,                                   desc = "Grep" },
            { "<leader>f",       function() Snacks.picker.files({ hidden = true }) end,                 desc = "Find Files" },
            { "<leader>F",       function() Snacks.picker.files({ hidden = true, ignored = true }) end, desc = "Find Files (incl. ignored)" },
            { "<leader><space>", function() Snacks.picker.buffers({ sort_lastused = true }) end,        desc = "Find Buffers" },
            { "<leader>gb",      function() Snacks.git.blame_line() end,                                desc = "Git Branches" },
            { "<leader>gd",      function() Snacks.picker.git_diff() end,                               desc = "Git Diff (Hunks)" },
            { "<leader>gf",      function() Snacks.picker.git_log_file() end,                           desc = "Git Log File" },
            { "<leader>gg",      function() Snacks.lazygit() end,                                       desc = "Lazygit" },
            { "<leader>se",      function() Snacks.picker.recent() end,                                 desc = "Recent" },
            { "<leader>sS",      function() Snacks.picker.lsp_symbols() end,                            desc = "LSP Symbols" },
            { "<leader>sr",      function() Snacks.picker.resume() end,                                 desc = "Resume" },
            { "<leader>ss",      function() Snacks.picker.lsp_workspace_symbols() end,                  desc = "LSP Workspace Symbols" },
            { "<leader>su",      function() Snacks.picker.undo() end,                                   desc = "Undo History" },
            { "<leader>sw",      function() Snacks.picker.grep_word() end,                              desc = "Visual selection or word" },
        }
    },

    {
        'stevearc/conform.nvim',
        opts = {
            default_format_opts = { lsp_format = "fallback" },
            format_on_save = { timeout_ms = 500 },
            formatters_by_ft = {
                ["javascript"] = { "prettier" },
                ["typescript"] = { "prettier" },
                ["svelte"] = { "prettier" },
                ["css"] = { "prettier" },
                ["scss"] = { "prettier" },
                ["html"] = { "prettier" },
                ["json"] = { "prettier" },
                ["yaml"] = { "prettier" },
            },
        },
    },

    {
        'stevearc/oil.nvim',
        config = function()
            require("oil").setup({
                columns = { "icon" },
                delete_to_trash = true,
                view_options = {
                    show_hidden = true,
                },
            })
            vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "open parent directory" })
            vim.api.nvim_create_autocmd("User", {
                pattern = "OilActionsPost",
                callback = function(event)
                    if event.data.actions.type == "move" then
                        Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
                    end
                end,
            })
        end,
    },

    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
            suggestion = { enabled = true },
            panel = { enabled = false },
            filetypes = {
                markdown = true,
                help = true,
            },
        },
    },

    {
        'saghen/blink.cmp',
        dependencies = { "fang2hou/blink-copilot" },
        version = '1.*',
        opts = {
            keymap = { preset = 'default' },
            cmdline = { enabled = false },
            signature = { enabled = true },
            appearance = { nerd_font_variant = 'mono' },
            completion = {
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 0,
                },
                accept = { auto_brackets = { enabled = false } },
                list = { selection = { auto_insert = false } }
            },
            sources = {
                default = { 'lsp', 'path', 'buffer', 'copilot' },
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

    {
        "mason-org/mason-lspconfig.nvim",
        opts = {},
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
                            disable = { 'missing-fields' },
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
                    }
                }

            }
        end
    },

    {
        "nvim-treesitter/nvim-treesitter",
        branch = 'master',
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local langs = {
                "bash", "c", "commonlisp", "css", "csv", "fish", "go", "html",
                "javascript", "jsdoc", "json", "lua", "python", "racket",
                "rust", "sql", "svelte", "toml", "typescript", "vim", "vimdoc",
                "xml", "yaml",
            };
            vim.defer_fn(function()
                require("nvim-treesitter.configs").setup({
                    ensure_installed = langs,
                    auto_install = true,
                    sync_install = false,
                    highlight = { enable = true },
                    indent = { enable = true },
                })
            end, 0)
        end
    },
}, {})

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.gdefault = true

vim.opt.expandtab = true
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
vim.opt.termguicolors = true
vim.opt.undofile = true

vim.opt.timeoutlen = 300
vim.opt.updatetime = 250
vim.opt.wrap = false
vim.wo.signcolumn = "yes"

vim.opt.clipboard = "unnamedplus"

-- Smart movements
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set("n", "j", "gj", { silent = true })
vim.keymap.set("n", "k", "gk", { silent = true })
vim.keymap.set("n", "n", "nzz", { silent = true })
vim.keymap.set("n", "N", "Nzz", { silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Toggle
vim.keymap.set("n", "<leader>th", ":noh<CR>", { desc = "toggle highlight off" })
vim.keymap.set("n", "<leader>tk", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(nil))
end, { desc = "toggle inlay hints" })
vim.keymap.set("n", "<leader>tn", ":set rnu!<CR>", { desc = "toggle relativenumber" })

vim.keymap.set("n", '<leader>tc', function()
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
vim.keymap.set("n", "<leader>dc", vim.diagnostic.setqflist, { desc = "diagnostics copen" })

-- LSP
vim.keymap.set("n", "grD", vim.lsp.buf.declaration, { desc = "jump to declaration" })
vim.keymap.set("n", "grd", vim.lsp.buf.definition, { desc = "jump to type definition" })
vim.keymap.set("n", "grs", vim.lsp.buf.type_definition, { desc = "jump to type definition" })
vim.keymap.set("n", "grX", function() vim.lsp.stop_client(vim.lsp.get_clients()) end, { desc = "LSP: stop clients" })

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
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
    { "folke/lazydev.nvim", ft = "lua",                       opts = {} },
    { "Saecki/crates.nvim", event = { "BufRead Cargo.toml" }, opts = {} },

    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme gruvbox]])
        end
    },

    {
        'echasnovski/mini.nvim',
        version = false,
        config = function()
            local mini_clue = require("mini.clue")
            mini_clue.setup({
                triggers = {
                    { mode = 'n', keys = '<Leader>' },
                    { mode = 'x', keys = '<Leader>' },
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
                mappings = {
                    reset = '<leader>gr',
                    goto_first = '[H',
                    goto_prev = '[h',
                    goto_next = ']h',
                    goto_last = ']H',
                },
            })

            require("mini.trailspace").setup()
        end
    },

    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        dependencies = { { "echasnovski/mini.icons", opts = {} } },
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
                        width = 0.8,
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
            { "<leader>f",       function() Snacks.picker.files({ hidden = true, ignored = true }) end, desc = "Find Files" },
            { "<leader><space>", function() Snacks.picker.buffers({ sort_lastused = true }) end,        desc = "Find Buffers" },
            { "<leader>gL",      function() Snacks.picker.git_log_line() end,                           desc = "Git Log Line" },
            { "<leader>gb",      function() Snacks.git.blame_line() end,                                desc = "Git Branches" },
            { "<leader>gd",      function() Snacks.picker.git_diff() end,                               desc = "Git Diff (Hunks)" },
            { "<leader>gf",      function() Snacks.picker.git_log_file() end,                           desc = "Git Log File" },
            { "<leader>gg",      function() Snacks.lazygit() end,                                       desc = "Lazygit" },
            { "<leader>gl",      function() Snacks.picker.git_log() end,                                desc = "Git Log" },
            { "<leader>gs",      function() Snacks.picker.git_status() end,                             desc = "Git Status" },
            {
                "<leader>gx",
                function() Snacks.gitbrowse() end,
                desc = "Git Browse",
                mode = { "n", "v" },
            },
            { "<leader>sg", function() Snacks.picker.git_files() end,             desc = "Find Git Files" },
            { "<leader>se", function() Snacks.picker.recent() end,                desc = "Recent" },
            { "<leader>sS", function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols" },
            { "<leader>sr", function() Snacks.picker.resume() end,                desc = "Resume" },
            { "<leader>ss", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
            { "<leader>su", function() Snacks.picker.undo() end,                  desc = "Undo History" },
            {
                "<leader>sw",
                function() Snacks.picker.grep_word() end,
                desc = "Visual selection or word",
                mode = { "n", "x" }
            },
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
        dependencies = { { "echasnovski/mini.icons", opts = {} } },
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
        -- config = function()
        --     -- vim.g.copilot_enabled = false
        --     vim.keymap.set('n', '<leader>ti', function()
        --         local copilot_enabled = vim.g.copilot_enabled or false
        --         vim.g.copilot_enabled = not copilot_enabled
        --         print("Copilot " .. (vim.g.copilot_enabled and "enabled" or "disabled"))
        --     end, { noremap = true, silent = true, desc = "Toggle Copilot" })
        -- end
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
                },
                automatic_enable = true
            })

            vim.lsp.config["lua_ls"] = {
                settings = {
                    Lua = {
                        diagnostics = { disable = { 'missing-fields' } },
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
        opts = {},
        build = ":TSUpdate",
        config = function()
            vim.defer_fn(function()
                require("nvim-treesitter.configs").setup({
                    ensure_installed = {
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
                        "python",
                        "racket",
                        "ron",
                        "rust",
                        "sql",
                        "svelte",
                        "toml",
                        "typescript",
                        "vim",
                        "vimdoc",
                        "xml",
                        "yaml",
                    },
                    auto_install = true,
                    ignore_install = {},
                    sync_install = false,
                    highlight = { enable = true },
                    indent = { enable = true },
                    incremental_selection = { enable = false },
                })
            end, 0)
        end
    },
}, {})

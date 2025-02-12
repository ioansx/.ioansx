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

vim.opt.completeopt = "menu,menuone,noinsert"
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

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

vim.keymap.set("n", "j", "gj", { silent = true })
vim.keymap.set("n", "k", "gk", { silent = true })
vim.keymap.set("n", "n", "nzz", { silent = true })
vim.keymap.set("n", "N", "Nzz", { silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")

vim.keymap.set("n", "<leader>th", ":noh<CR>", { desc = "toggle highlight off" })
vim.keymap.set("n", "<leader>tk", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(nil))
end, { desc = "toggle inlay hints" })
vim.keymap.set("n", "<leader>tl", ":set rnu!<CR>", { desc = "toggle relativenumber" })

vim.keymap.set({ "n", "v" }, "<leader>p", '"0p', { desc = "paste yanked" })

vim.keymap.set("n", "<leader>Ya", ":let @+ = expand('%:p')<CR>", { desc = "yank absolute file path" })
vim.keymap.set("n", "<leader>Yc", ":let @+ = join([expand('%:.'),  line('.')], ':')<CR>",
    { desc = "yank relative file path:line" })
vim.keymap.set("n", "<leader>Yf", ":let @+ = expand('%:t')<CR>", { desc = "yank file name" })
vim.keymap.set("n", "<leader>Yr", ":let @+ = expand('%:.')<CR>", { desc = "yank relative file path" })

vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float, { desc = "open floating diagnostic" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "open diagnostic list" })

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

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
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme gruvbox]])
        end
    },

    'tpope/vim-sleuth',

    {
        'echasnovski/mini.nvim',
        version = false,
        config = function()
            local mini_clue = require("mini.clue")
            mini_clue.setup({
                triggers = {
                    -- Leader triggers
                    { mode = 'n', keys = '<Leader>' },
                    { mode = 'x', keys = '<Leader>' },
                    { mode = 'n', keys = '[' },
                    { mode = 'n', keys = ']' },
                    -- Built-in completion
                    { mode = 'i', keys = '<C-x>' },
                    -- `g` key
                    { mode = 'n', keys = 'g' },
                    { mode = 'x', keys = 'g' },
                    -- Marks
                    { mode = 'n', keys = "'" },
                    { mode = 'n', keys = '`' },
                    { mode = 'x', keys = "'" },
                    { mode = 'x', keys = '`' },
                    -- Registers
                    { mode = 'n', keys = '"' },
                    { mode = 'x', keys = '"' },
                    { mode = 'i', keys = '<C-r>' },
                    { mode = 'c', keys = '<C-r>' },
                    -- Window commands
                    { mode = 'n', keys = '<C-w>' },
                    -- `z` key
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
                window = {
                    config = {
                        width = "auto",
                    },
                },
            })

            require("mini.cursorword").setup()

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
                    },
                },
            },
            words = { enabled = true },
        },
        keys = {
            {
                "<leader>/",
                function() Snacks.picker.grep() end,
                desc = "Grep",
            },
            {
                "<leader><space>",
                function() Snacks.picker.buffers() end,
                desc = "Buffers",
            },
            {
                "<leader>fa",
                function() Snacks.picker.files({ hidden = true, ignored = true }) end,
                desc = "Find Files",
            },
            {
                "<leader>ff",
                function() Snacks.picker.files() end,
                desc = "Find Files",
            },
            {
                "<leader>fg",
                function() Snacks.picker.git_files() end,
                desc = "Find Git Files",
            },
            {
                "<leader>fr",
                function() Snacks.picker.recent() end,
                desc = "Recent",
            },
            {
                "<leader>gL",
                function() Snacks.picker.git_log_line() end,
                desc = "Git Log Line",
            },
            {
                "<leader>gS",
                function() Snacks.picker.git_stash() end,
                desc = "Git Stash"
            },
            {
                "<leader>gb",
                function() Snacks.git.blame_line() end,
                desc = "Git Branches",
            },
            {
                "<leader>gd",
                function() Snacks.picker.git_diff() end,
                desc = "Git Diff (Hunks)",
            },
            {
                "<leader>gf",
                function() Snacks.picker.git_log_file() end,
                desc = "Git Log File",
            },
            {
                "<leader>gg",
                function() Snacks.lazygit() end,
                desc = "Lazygit",
            },
            {
                "<leader>gl",
                function() Snacks.picker.git_log() end,
                desc = "Git Log",
            },
            {
                "<leader>gs",
                function() Snacks.picker.git_status() end,
                desc = "Git Status",
            },
            {
                "<leader>gx",
                function() Snacks.gitbrowse() end,
                desc = "Git Browse",
                mode = { "n", "v" },
            },
            {
                "<leader>sD",
                function() Snacks.picker.diagnostics_buffer() end,
                desc = "Buffer Diagnostics",
            },
            {
                "<leader>sS",
                function() Snacks.picker.lsp_symbols() end,
                desc = "LSP Symbols",
            },
            {
                "<leader>s\"",
                function() Snacks.picker.registers() end,
                desc = "Registers",
            },
            {
                "<leader>sd",
                function() Snacks.picker.diagnostics() end,
                desc = "Diagnostics",
            },
            {
                "<leader>sh",
                function() Snacks.picker.help() end,
                desc = "Help Pages",
            },
            {
                "<leader>sj",
                function() Snacks.picker.jumps() end,
                desc = "Jumps",
            },
            {
                "<leader>sk",
                function() Snacks.picker.keymaps() end,
                desc = "Keymaps",
            },
            {
                "<leader>sm",
                function() Snacks.picker.marks() end,
                desc = "Marks",
            },
            {
                "<leader>sq",
                function() Snacks.picker.qflist() end,
                desc = "Quickfix List"
            },
            {
                "<leader>sr",
                function() Snacks.picker.resume() end,
                desc = "Resume"
            },
            {
                "<leader>ss",
                function() Snacks.picker.lsp_workspace_symbols() end,
                desc = "LSP Workspace Symbols"
            },
            {
                "<leader>su",
                function() Snacks.picker.undo() end,
                desc = "Undo History"
            },
            {
                "<leader>sw",
                function() Snacks.picker.grep_word() end,
                desc = "Visual selection or word",
                mode = { "n", "x" }
            },
            {
                "gD",
                function() Snacks.picker.lsp_declarations() end,
                desc = "Goto Declaration"
            },
            {
                "gI",
                function() Snacks.picker.lsp_implementations() end,
                desc = "Goto Implementation"
            },
            {
                "gd",
                function() Snacks.picker.lsp_definitions() end,
                desc = "Goto Definition"
            },
            {
                "gs",
                function() Snacks.picker.lsp_type_definitions() end,
                desc = "Goto Type Definition"
            },
            {
                "gr",
                function() Snacks.picker.lsp_references() end,
                desc = "References",
                nowait = true
            },
        }
    },

    {
        'numToStr/Comment.nvim',
        opts = {}
    },

    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false },
        keys = {
            { "<leader>st", function() Snacks.picker.todo_comments() end,                                          desc = "Todo" },
            { "<leader>sT", function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
        }
    },

    {
        'stevearc/conform.nvim',
        opts = {
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
            formatters_by_ft = {
                ["javascript"] = { "prettier" },
                ["javascriptreact"] = { "prettier" },
                ["typescript"] = { "prettier" },
                ["typescriptreact"] = { "prettier" },
                ["vue"] = { "prettier" },
                ["svelte"] = { "prettier" },
                ["css"] = { "prettier" },
                ["scss"] = { "prettier" },
                ["less"] = { "prettier" },
                ["html"] = { "prettier" },
                ["json"] = { "prettier" },
                ["jsonc"] = { "prettier" },
                ["yaml"] = { "prettier" },
            },
        },
    },

    {
        "nvim-pack/nvim-spectre",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {},
        config = function()
            vim.keymap.set("n", "<leader>S", ":Spectre<CR>", { desc = "Spectre" })
        end
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
        'saghen/blink.cmp',
        version = 'v0.*',
        opts = {
            keymap = { preset = 'super-tab' },
            sources = {
                default = { 'lsp', 'path', 'buffer' },
                cmdline = {},
            },
            signature = { enabled = true },
            completion = {
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 0,
                }
            }
        }
    },

    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            }
        }
    },

    {
        "Saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        opts = {},
    },

    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "williamboman/mason.nvim", config = true },
            "williamboman/mason-lspconfig.nvim",
            { "j-hui/fidget.nvim",       opts = {} },
        },
        config = function(_, opts)
            local on_attach = function(_, bufnr)
                vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
                    vim.lsp.buf.format()
                end, { desc = "format current buffer with LSP" })
                vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { buffer = bufnr, desc = "LSP: format buffer" })
                vim.keymap.set("n", "<leader>cr", ":LspRestart<CR>", { buffer = bufnr, desc = "LSP restart" })
                vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, { buffer = bufnr, desc = "LSP: code action" })
                vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { buffer = bufnr, desc = "LSP: rename symbol" })
                vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "LSP: signature docs" })
            end

            require("mason").setup()
            require("mason-lspconfig").setup()

            local servers = {
                bashls = {},
                cssls = {},
                eslint = {},
                tailwindcss = {},
                lua_ls = {
                    Lua = {
                        workspace = { checkThirdParty = false },
                        telemetry = { enable = false },
                        diagnostics = { disable = { 'missing-fields' } },
                    },
                },
                -- pyright = {
                --     autoImportCompletion = true,
                --     python = {
                --         analysis = {
                --             autoSearchPaths = true,
                --             diagnosticMode = 'openFilesOnly',
                --             useLibraryCodeForTypes = true,
                --             typeCheckingMode = 'off'
                --         }
                --     }
                -- },
                rust_analyzer = {
                    ["rust-analyzer"] = {
                        completion = {
                            -- fullFunctionSignatures = { enable = true },
                            postfix = { enable = false },
                        },
                        cargo = {
                            allTargets = false,
                        },
                        check = {
                            command = "check",
                            -- command = "clippy",
                            -- workspace = false,
                        },
                    }
                },
                taplo = {},
                ts_ls = {},
                svelte = {},
                gopls = {},
                zls = {},
            }

            local mason_lspconfig = require("mason-lspconfig")
            mason_lspconfig.setup({
                ensure_installed = vim.tbl_keys(servers),
            })

            mason_lspconfig.setup_handlers({
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        on_attach = on_attach,
                        settings = servers[server_name],
                        filetypes = (servers[server_name] or {}).filetypes,
                    })
                end,
            })

            local lspconfig = require('lspconfig')
            for server, config in pairs(opts.servers or {}) do
                config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
                lspconfig[server].setup(config)
            end

            -- https://github.com/neovim/neovim/issues/30985#issuecomment-2447329525
            for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
                local default_diagnostic_handler = vim.lsp.handlers[method]
                vim.lsp.handlers[method] = function(err, result, context, config)
                    if err ~= nil and err.code == -32802 then
                        return
                    end
                    return default_diagnostic_handler(err, result, context, config)
                end
            end

            vim.g.zig_fmt_parse_errors = 0
        end
    },

    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
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
                        "svelte",
                        "toml",
                        "typescript",
                        "vim",
                        "vimdoc",
                        "xml",
                        "yaml",
                    },
                    ignore_install = {},
                    sync_install = false,
                    highlight = { enable = true },
                    indent = { enable = true },
                    incremental_selection = { enable = false },
                    textobjects = {
                        select = {
                            enable = true,
                            lookahead = true,
                            keymaps = {
                                ["aa"] = "@parameter.outer",
                                ["ia"] = "@parameter.inner",
                                ["af"] = "@function.outer",
                                ["if"] = "@function.inner",
                                ["ac"] = "@class.outer",
                                ["ic"] = "@class.inner",
                            },
                        },
                        move = {
                            enable = true,
                            set_jumps = true,
                            goto_next_start = {
                                ["]f"] = "@function.outer",
                                ["]c"] = "@class.outer",
                            },
                            goto_next_end = {
                                ["]F"] = "@function.outer",
                                ["]C"] = "@class.outer",
                            },
                            goto_previous_start = {
                                ["[f"] = "@function.outer",
                                ["[c"] = "@class.outer",
                            },
                            goto_previous_end = {
                                ["[F"] = "@function.outer",
                                ["[C"] = "@class.outer",
                            },
                        },
                        swap = {
                            enable = true,
                            swap_next = {
                                ["<leader>cs"] = "@parameter.inner",
                            },
                            swap_previous = {
                                ["<leader>cS"] = "@parameter.inner",
                            },
                        },
                    },
                })
            end, 0)
        end
    },
}, {})

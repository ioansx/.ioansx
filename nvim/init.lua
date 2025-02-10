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
        'mbbill/undotree',
        config = function()
            vim.keymap.set('n', '<leader>u', function()
                vim.cmd.UndotreeToggle()
                vim.cmd.UndotreeFocus()
            end, { desc = "undotree" })
        end
    },

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
                    -- Reset hunks inside a visual/operator region
                    reset = '<leader>hr',
                    -- Go to hunk range in corresponding direction
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
        opts = {
            -- bigfile = { enabled = true },
            -- dashboard = { enabled = true },
            -- explorer = { enabled = true },
            indent = { enabled = true, animate = { enabled = false } },
            -- input = { enabled = true },
            -- notifier = {
            --     enabled = true,
            --     timeout = 3000,
            -- },
            picker = { enabled = true },
            -- quickfile = { enabled = true },
            -- scope = { enabled = true },
            -- scroll = { enabled = true },
            -- statuscolumn = { enabled = true },
            -- words = { enabled = true },
            -- styles = {
            --     notification = {
            --         -- wo = { wrap = true } -- Wrap notifications
            --     }
            -- }
        },
        keys = {
            -- { "<leader><space>", function() Snacks.picker.smart() end,    desc = "Smart Find Files" },
            { "<leader>/",       function() Snacks.picker.grep() end,               desc = "Grep" },
            { "<leader><space>", function() Snacks.picker.buffers() end,            desc = "Recent" },
            { "<leader>f",       function() Snacks.picker.git_files() end,          desc = "Find Git Files" },
            { "<leader>F",       function() Snacks.picker.files() end,              desc = "Find Files" },
            { "<leader>hb",      function() Snacks.git.blame_line() end,            desc = "Git Branches" },
            { "<leader>hd",      function() Snacks.picker.git_diff() end,           desc = "Git Diff (Hunks)" },
            { "<leader>sD",      function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
            { "<leader>sf",      function() Snacks.picker.recent() end,             desc = "Recent" },
            { "<leader>sr",      function() Snacks.picker.resume() end,             desc = "Resume" },
            { "<leader>sd",      function() Snacks.picker.diagnostics() end,        desc = "Diagnostics" },
            { "<leader>su",      function() Snacks.picker.undo() end,               desc = "Undo History" },
            { '<leader>s"',      function() Snacks.picker.registers() end,          desc = "Registers" },
        }
    },

    {
        'numToStr/Comment.nvim',
        opts = {}
    },

    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false }
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

                vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format,
                    { buffer = bufnr, desc = "LSP: format buffer" })

                vim.keymap.set("n", "<leader>cr", ":LspRestart<CR>",
                    { buffer = bufnr, desc = "LSP restart" })

                vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action,
                    { buffer = bufnr, desc = "LSP: code action" })

                vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename,
                    { buffer = bufnr, desc = "LSP: rename symbol" })

                vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help,
                    { buffer = bufnr, desc = "LSP: signature docs" })
            end

            require("mason").setup()
            require("mason-lspconfig").setup()

            local servers = {
                bashls = {},
                -- html = {},
                cssls = {},
                eslint = {},
                tailwindcss = {},
                -- jsonls = {},
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

    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
        },
        config = function()
            require("telescope").setup({
                defaults = {
                    layout_strategy = "vertical",
                    layout_config = {
                        height = 0.9,
                        width = 0.9,
                    },
                },
                pickers = {
                    buffers = { theme = "ivy" },
                    current_buffer_fuzzy_find = { theme = "ivy" },
                    diagnostics = { theme = "ivy" },
                    find_files = { theme = "ivy" },
                    git_files = { theme = "ivy" },
                    grep_string = { theme = "ivy" },
                    help_tags = { theme = "ivy" },
                    live_grep = { theme = "ivy" },
                    lsp_definitions = { theme = "ivy" },
                    lsp_document_symbols = { theme = "ivy" },
                    lsp_dynamic_workspace_symbols = { theme = "ivy" },
                    lsp_references = { theme = "ivy" },
                    lsp_type_definitions = { theme = "ivy" },
                    oldfiles = { theme = "ivy" },
                    registers = { theme = "ivy" },
                    resume = { theme = "ivy" },
                },
            })

            vim.cmd("autocmd User TelescopePreviewerLoaded setlocal number")

            -- Enable telescope fzf native, if installed
            pcall(require("telescope").load_extension, "fzf")

            -- Telescope live_grep in git root
            -- Function to find the git root directory based on the current buffer's path
            local function find_git_root()
                -- Use the current buffer's path as the starting point for the git search
                local current_file = vim.api.nvim_buf_get_name(0)
                local current_dir
                local cwd = vim.fn.getcwd()
                -- If the buffer is not associated with a file, return nil
                if current_file == "" then
                    current_dir = cwd
                else
                    -- Extract the directory from the current file's path
                    current_dir = vim.fn.fnamemodify(current_file, ":h")
                end

                -- Find the Git root directory from the current file's path
                local git_root = vim.fn.systemlist("git -C " ..
                    vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
                if vim.v.shell_error ~= 0 then
                    print("Not a git repository. Searching on current working directory")
                    return cwd
                end
                return git_root
            end

            local telescope_builtin = require("telescope.builtin")

            -- Custom live_grep function to search in git root
            local function live_grep_git_root()
                local git_root = find_git_root()
                if git_root then
                    telescope_builtin.live_grep({
                        search_dirs = { git_root },
                    })
                end
            end

            vim.api.nvim_create_user_command("LiveGrepGitRoot", live_grep_git_root, {})

            -- vim.keymap.set("n", "<leader><leader>", function()
            --     telescope_builtin.buffers({ sort_mru = true })
            -- end, { desc = "find existing buffers" })

            -- vim.keymap.set("n", "<leader>f", function()
            --     telescope_builtin.find_files({
            --         hidden = true,
            --     })
            -- end, { desc = "search files", noremap = true })
            --
            -- vim.keymap.set("n", "<leader>F", function()
            --     telescope_builtin.find_files({
            --         hidden = true,
            --         no_ignore = true,
            --         no_ignore_parent = true,
            --     })
            -- end, { desc = "search files", noremap = true })

            -- vim.keymap.set("n", "<leader>/", telescope_builtin.live_grep,
            --     { desc = "search by grep", noremap = true })

            vim.keymap.set("n", "<leader>s/", telescope_builtin.current_buffer_fuzzy_find,
                { desc = "fuzzily search in current buffer", noremap = true })

            vim.keymap.set("n", "<leader>sf", telescope_builtin.oldfiles,
                { desc = "find recently opened files", noremap = true })

            vim.keymap.set("n", "<leader>sg", function()
                telescope_builtin.git_files({ show_untracked = true })
            end, { desc = "search Git files", noremap = true })

            vim.keymap.set("n", "<leader>hc", telescope_builtin.git_bcommits,
                { desc = "find buffer commits", noremap = true })

            vim.keymap.set("n", "<leader>hg", ":LiveGrepGitRoot<CR>",
                { desc = "search by grep on Git Root", noremap = true })

            -- vim.keymap.set("n", "<leader>sd", function()
            --     telescope_builtin.diagnostics({ bufnr = nil })
            -- end, { desc = "search diagnostic in workspace", noremap = true })
            --
            -- vim.keymap.set("n", "<leader>sD", function()
            --     telescope_builtin.diagnostics({ bufnr = 0 })
            -- end, { desc = "search diagnostic", noremap = true })

            -- vim.keymap.set("n", "<leader>sr", telescope_builtin.resume,
            --     { desc = "search resume", noremap = true })

            -- vim.keymap.set("n", "<leader>sR", telescope_builtin.registers,
            --     { desc = "search registers", noremap = true })

            vim.keymap.set("n", "<leader>sh", telescope_builtin.help_tags,
                { desc = "search help", noremap = true })

            vim.keymap.set("n", "<leader>sw", telescope_builtin.grep_string,
                { desc = "search current word", noremap = true })

            vim.keymap.set("n", "<leader>ss", telescope_builtin.lsp_dynamic_workspace_symbols,
                { desc = "search workspace symbols" })

            vim.keymap.set("n", "<leader>sS", telescope_builtin.lsp_document_symbols,
                { desc = "search document symbols" })

            vim.keymap.set("n", "gd", telescope_builtin.lsp_definitions, { desc = "goto definition" })

            vim.keymap.set("n", "gs", function()
                telescope_builtin.lsp_type_definitions({ show_line = false })
            end, { desc = "goto type definitions" })

            vim.keymap.set("n", "gr", function()
                telescope_builtin.lsp_references({
                    include_declaration = false,
                    show_line = false,
                })
            end, { desc = "goto references" })

            vim.keymap.set("n", "gI", function()
                telescope_builtin.lsp_implementations({ show_line = false })
            end, { desc = "goto implementation" })
        end
    },
}, {})

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

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

vim.keymap.set("n", "j", "gj", { silent = true })
vim.keymap.set("n", "k", "gk", { silent = true })
vim.keymap.set("n", "n", "nzz", { silent = true })
vim.keymap.set("n", "N", "Nzz", { silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")

vim.keymap.set("n", "<leader><leader>", "<C-^>", { desc = "toggle last buffer" })

vim.keymap.set("n", "<leader>th", ":noh<CR>", { desc = "toggle highlight off" })
vim.keymap.set("n", "<leader>tk", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(nil)) end,
    { desc = "toggle inlay hints" })
vim.keymap.set("n", "<leader>tl", ":set rnu!<CR>", { desc = "toggle relativenumber" })

vim.keymap.set({ "n", "v" }, "<leader>y", "\"+y", { desc = "clipboard copy" })
vim.keymap.set({ "n", "v" }, "<leader>p", "\"+p", { desc = "clipboard paste" })

vim.keymap.set("n", "<leader>Ya", ":let @+ = expand('%:p')<CR>", { desc = "yank absolute file path" })
vim.keymap.set("n", "<leader>Yc", ":let @+ = join([expand('%:.'),  line('.')], ':')<CR>",
    { desc = "yank relative file path:line" })
vim.keymap.set("n", "<leader>Yf", ":let @+ = expand('%:t')<CR>", { desc = "yank file name" })
vim.keymap.set("n", "<leader>Yr", ":let @+ = expand('%:.')<CR>", { desc = "yank relative file path" })

vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float, { desc = "open floating diagnostic" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "open diagnostic list" })

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
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
        "rebelot/kanagawa.nvim",
        opts = {},
        config = function()
            vim.cmd("colorscheme kanagawa-wave")
        end
    },

    'tpope/vim-sleuth',

    {
        'tpope/vim-fugitive',
        config = function()
            vim.keymap.set("n", "<leader>hb", ":Git blame<CR>", { desc = "Git blame" })
            vim.keymap.set("n", "<leader>hd", ":Git diff | only<CR>", { desc = "Git diff" })
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

            local mini_indentscope = require("mini.indentscope")
            mini_indentscope.setup({
                symbol = "▏",
                draw = {
                    animation = mini_indentscope.gen_animation.none(),
                },
            })

            require("mini.trailspace").setup()
        end
    },

    {
        'numToStr/Comment.nvim',
        opts = {}
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
                columns = {
                    "icon",
                    -- "permissions",
                    -- "size",
                    -- "mtime",
                },
                delete_to_trash = true,
                view_options = {
                    show_hidden = true,
                },
            })

            vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "open parent directory" })
        end,
    },

    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false }
    },

    {
        'saghen/blink.cmp',
        lazy = false, -- lazy loading handled internally
        -- use a release tag to download pre-built binaries
        version = 'v0.*',
        opts = {
            -- 'default' for mappings similar to built-in completion
            -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
            -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
            -- see the "default configuration" section below for full documentation on how to define
            -- your own keymap.
            keymap = { preset = 'super-tab' },
            completion = {
                documentation = { auto_show = true },
            },
            sources = {
                completion = {
                    enabled_providers = { 'lsp', 'path', 'buffer' },
                }
            },
            signature = {
                enabled = true
            },
        }
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
                local nmap = function(keys, func, desc)
                    if desc then
                        desc = "LSP: " .. desc
                    end

                    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
                end

                -- Create a command `:Format` local to the LSP buffer
                vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
                    vim.lsp.buf.format()
                end, { desc = "format current buffer with LSP" })

                nmap('<leader>a', vim.lsp.buf.code_action, 'code action')
                nmap("<leader>cf", ":Format<CR>", "format buffer")
                nmap("<leader>r", vim.lsp.buf.rename, "rename symbol")

                -- goto
                nmap("gd", require("telescope.builtin").lsp_definitions, "goto definition")
                nmap("gs", function()
                    require("telescope.builtin").lsp_type_definitions({
                        show_line = false,
                    })
                end, "goto type definitions")
                nmap("gr", function()
                    require("telescope.builtin").lsp_references({
                        include_declaration = false,
                        show_line = false,
                    })
                end, "goto references")
                nmap("gD", vim.lsp.buf.declaration, "goto declaration")
                nmap("gI", function()
                    require("telescope.builtin").lsp_implementations({
                        show_line = false,
                    })
                end, "goto implementation")

                -- search
                nmap("<leader>sS", require("telescope.builtin").lsp_document_symbols, "search document symbols")
                nmap("<leader>ss", require("telescope.builtin").lsp_dynamic_workspace_symbols,
                    "search workspace symbols")

                nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
            end

            require("mason").setup()
            require("mason-lspconfig").setup()

            local servers = {
                eslint = {},
                cssls = {},
                tailwindcss = {},
                html = {},
                jsonls = {},
                lua_ls = {
                    Lua = {
                        workspace = { checkThirdParty = false },
                        telemetry = { enable = false },
                        diagnostics = { disable = { 'missing-fields' } },
                    },
                },
                pyright = {
                    autoImportCompletion = true,
                    python = {
                        analysis = {
                            autoSearchPaths = true,
                            diagnosticMode = 'openFilesOnly',
                            useLibraryCodeForTypes = true,
                            typeCheckingMode = 'off'
                        }
                    }
                },
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
            "debugloop/telescope-undo.nvim",
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
                    mappings = {
                        i = {
                            ["<C-u>"] = false,
                            ["<C-d>"] = false,
                        },
                    },
                    layout_strategy = "vertical",
                    layout_config = {
                        height = 0.95,
                        width = 0.8,
                        mirror = true,
                    },
                },
                extensions = {
                    undo = {
                        side_by_side = true,
                        layout_strategy = "vertical",
                        layout_config = {
                            preview_height = 0.95,
                        },
                    },
                },
            })

            vim.cmd("autocmd User TelescopePreviewerLoaded setlocal number")

            -- Enable telescope fzf native, if installed
            pcall(require("telescope").load_extension, "fzf")

            -- Enable telescope-undo
            require("telescope").load_extension("undo")

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


            vim.keymap.set("n", "<leader>b", function()
                telescope_builtin.buffers({ sort_mru = true })
            end, { desc = "find existing buffers" })

            vim.keymap.set("n", "<leader>sa", telescope_builtin.oldfiles,
                { desc = "find recently opened files", noremap = true })

            vim.keymap.set("n", "<leader>f", function()
                telescope_builtin.find_files({ hidden = true })
            end, { desc = "search files", noremap = true })

            vim.keymap.set("n", "<leader>s.", function()
                telescope_builtin.find_files({
                    hidden = true,
                    no_ignore = true,
                    prompt_title = "Find Files in CWD",
                })
            end, { desc = "search all cwd files", noremap = true })

            vim.keymap.set("n", "<leader>s/", telescope_builtin.current_buffer_fuzzy_find,
                { desc = "fuzzily search in current buffer", noremap = true })

            vim.keymap.set("n", "<leader>so", function()
                telescope_builtin.live_grep({
                    grep_open_files = true,
                    prompt_title = "live Grep in Open files",
                })
            end, { desc = "search in open files", noremap = true })

            vim.keymap.set("n", "<leader>sd", function() telescope_builtin.diagnostics({ bufnr = 0 }) end,
                { desc = "search diagnostic", noremap = true })

            vim.keymap.set("n", "<leader>sD", function() telescope_builtin.diagnostics({ bufnr = nil }) end,
                { desc = "search diagnostic in workspace", noremap = true })

            vim.keymap.set("n", "<leader>sg", telescope_builtin.live_grep,
                { desc = "search by grep", noremap = true })

            vim.keymap.set("n", "<leader>sG", ":LiveGrepGitRoot<CR>",
                { desc = "search by grep on Git Root", noremap = true })

            vim.keymap.set("n", "<leader>sh", telescope_builtin.git_files,
                { desc = "search Git files", noremap = true })

            vim.keymap.set("n", "<leader>sr", telescope_builtin.resume,
                { desc = "search resume", noremap = true })

            vim.keymap.set("n", "<leader>sR", telescope_builtin.registers,
                { desc = "search registers", noremap = true })

            vim.keymap.set("n", "<leader>sH", telescope_builtin.help_tags,
                { desc = "search help", noremap = true })

            vim.keymap.set("n", "<leader>su", require("telescope").extensions.undo.undo,
                { desc = "search undotree", noremap = true })

            vim.keymap.set("n", "<leader>sw", telescope_builtin.grep_string,
                { desc = "search current word", noremap = true })
        end
    },

    {
        "folke/trouble.nvim",
        dependencies = { "echasnovski/mini.icons" },
        cmd = "Trouble",
        opts = {
            focus = true,
        },
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "diagnostics",
            },
            {
                "<leader>xb",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "buffer diagnostics",
            },
            {
                "<leader>xs",
                "<cmd>Trouble symbols toggle win.position=bottom<cr>",
                desc = "symbols",
            },
            {
                "<leader>xr",
                "<cmd>Trouble lsp toggle<cr>",
                desc = "LSP",
            },
            {
                "<leader>xl",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "location list",
            },
            {
                "<leader>xq",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "quickfix list",
            },
            {
                "<leader>xt",
                "<cmd>Trouble todo<cr>",
                desc = "TODO",
            },
        },
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
}, {})

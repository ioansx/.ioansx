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
vim.opt.magic = true

-- Smart movements
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set("n", "j", "gj", { silent = true })
vim.keymap.set("n", "k", "gk", { silent = true })
vim.keymap.set("n", "n", "nzz", { silent = true })
vim.keymap.set("n", "N", "Nzz", { silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")

-- Toggle
vim.keymap.set("n", "<leader>th", ":noh<CR>", { desc = "toggle highlight off" })
vim.keymap.set("n", "<leader>tk", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(nil))
end, { desc = "toggle inlay hints" })
vim.keymap.set("n", "<leader>tl", ":set rnu!<CR>", { desc = "toggle relativenumber" })

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
vim.keymap.set("n", "<leader>cr", function()
    vim.lsp.stop_client(vim.lsp.get_clients())
end, { desc = "LSP: stop clients" })
vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, { desc = "LSP: code action" })
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { desc = "LSP: rename symbol" })
vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "LSP: format buffer" })
vim.keymap.set("n", "grd", vim.lsp.buf.definition, { desc = "jump to definition" })
vim.keymap.set("n", "grs", vim.lsp.buf.type_definition, { desc = "jump to type definition" })
vim.keymap.set("n", "grD", vim.lsp.buf.declaration, { desc = "jump to declaration" })

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client ~= nil and client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        end
    end,
})

-- MRU buffer switching
local function CompleteBuffersMRU()
    local cwd = vim.fn.getcwd()
    if not cwd or cwd == '' then return {} end

    -- Normalize CWD path
    local sep = package.config:sub(1, 1)
    if not cwd:match(sep .. '$') then cwd = cwd .. sep end

    local current_bufnr = vim.fn.bufnr('%')
    local buffers = vim.fn.getbufinfo({ listed = 1 })
    buffers = vim.tbl_filter(function(buf)
        local is_named = buf.name and buf.name ~= ''
        if not is_named then return false end

        local is_in_cwd = vim.startswith(buf.name, cwd)
        if not is_in_cwd then return false end

        local is_not_current = buf.bufnr ~= current_bufnr
        return is_not_current
    end, buffers)

    table.sort(buffers, function(a, b)
        return (a.lastused or 0) > (b.lastused or 0)
    end)

    local buffer_relative_names = vim.tbl_map(function(buf)
        return vim.fn.fnamemodify(buf.name, ':.')
    end, buffers)

    return buffer_relative_names
end

vim.api.nvim_create_user_command(
    'BufferMRU',
    function(opts)
        vim.cmd('buffer' .. (opts.args and #opts.args > 0 and (' ' .. opts.args) or ''))
    end,
    {
        nargs = '?',
        complete = CompleteBuffersMRU,
        desc = 'Switch buffer (MRU completion)',
        force = true,
    }
)

vim.keymap.set('n', '<leader><space>', ':BufferMRU ', { noremap = true, silent = true, desc = "Switch buffer (MRU)" })

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Lazy plugins
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

    {
        "ellisonleao/gruvbox.nvim",
        lazy = false,
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
                window = {
                    config = {
                        width = "auto",
                    },
                },
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
                    },
                },
            },
            words = { enabled = true },
        },
        keys = {
            { "<leader>/",  function() Snacks.picker.grep() end,      desc = "Grep" },
            {
                "<leader>fa",
                function() Snacks.picker.files({ hidden = true, ignored = true }) end,
                desc = "Find Files",
            },
            { "<leader>ff", function() Snacks.picker.files() end,     desc = "Find Files" },
            { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
            { "<leader>fr", function() Snacks.picker.recent() end,    desc = "Recent" },
            {
                "<leader>gL",
                function() Snacks.picker.git_log_line() end,
                desc = "Git Log Line",
            },
            { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
            { "<leader>gb", function() Snacks.git.blame_line() end,   desc = "Git Branches" },
            { "<leader>gd", function() Snacks.picker.git_diff() end,  desc = "Git Diff (Hunks)" },
            {
                "<leader>gf",
                function() Snacks.picker.git_log_file() end,
                desc = "Git Log File",
            },
            { "<leader>gg", function() Snacks.lazygit() end,           desc = "Lazygit" },
            { "<leader>gl", function() Snacks.picker.git_log() end,    desc = "Git Log" },
            { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
            {
                "<leader>gx",
                function() Snacks.gitbrowse() end,
                desc = "Git Browse",
                mode = { "n", "v" },
            },
            { "<leader>sS",  function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
            { "<leader>s\"", function() Snacks.picker.registers() end,   desc = "Registers" },
            { "<leader>sh",  function() Snacks.picker.help() end,        desc = "Help Pages" },
            { "<leader>sj",  function() Snacks.picker.jumps() end,       desc = "Jumps" },
            { "<leader>sk",  function() Snacks.picker.keymaps() end,     desc = "Keymaps" },
            { "<leader>sm",  function() Snacks.picker.marks() end,       desc = "Marks" },
            { "<leader>sq",  function() Snacks.picker.qflist() end,      desc = "Quickfix List" },
            { "<leader>sr",  function() Snacks.picker.resume() end,      desc = "Resume" },
            {
                "<leader>ss",
                function() Snacks.picker.lsp_workspace_symbols() end,
                desc = "LSP Workspace Symbols"
            },
            { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
            {
                "<leader>sw",
                function() Snacks.picker.grep_word() end,
                desc = "Visual selection or word",
                mode = { "n", "x" }
            },
        }
    },

    -- {
    --     'numToStr/Comment.nvim',
    --     opts = {}
    -- },

    {
        'stevearc/conform.nvim',
        opts = {
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
            formatters_by_ft = {
                ["javascript"] = { "prettier" },
                ["typescript"] = { "prettier" },
                ["vue"] = { "prettier" },
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
        'github/copilot.vim',
        opts = {},
        config = function()
            vim.g.copilot_enabled = false
            vim.keymap.set('n', '<leader>tc', function()
                local copilot_enabled = vim.g.copilot_enabled or false
                vim.g.copilot_enabled = not copilot_enabled
                print("Copilot " .. (vim.g.copilot_enabled and "enabled" or "disabled"))
            end, { noremap = true, silent = true, desc = "Toggle Copilot" })
        end
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
                            postfix = { enable = false },
                        },
                        check = {
                            command = "check",
                            -- command = "clippy",
                        },
                    }
                },
                taplo = {},
                ts_ls = {},
                svelte = {},
                gopls = {},
            }

            local mason_lspconfig = require("mason-lspconfig")
            mason_lspconfig.setup({
                ensure_installed = vim.tbl_keys(servers),
            })

            mason_lspconfig.setup_handlers({
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        settings = servers[server_name],
                        filetypes = (servers[server_name] or {}).filetypes,
                    })
                end,
            })

            -- https://github.com/neovim/neovim/issues/30985#issuecomment-2447329525
            -- for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
            --     local default_diagnostic_handler = vim.lsp.handlers[method]
            --     vim.lsp.handlers[method] = function(err, result, context, config)
            --         if err ~= nil and err.code == -32802 then
            --             return
            --         end
            --         return default_diagnostic_handler(err, result, context, config)
            --     end
            -- end
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
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            }
        }
    },
}, {})

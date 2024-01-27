-- [[ Options ]]
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.gdefault = true

vim.o.expandtab = true
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.tabstop = 4

-- vim.o.autoindent = true
vim.o.breakindent = true
vim.o.smartindent = true

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.clipboard = "unnamedplus"
vim.o.colorcolumn = "120"
vim.o.completeopt = "menu,menuone,noinsert"
vim.o.cursorline = true
vim.o.mouse = "a"
vim.o.scrolloff = 8
vim.o.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.timeoutlen = 300
vim.o.undofile = true
vim.o.updatetime = 100
vim.o.wrap = false

vim.wo.number = true
vim.wo.signcolumn = "yes"

-- [[ Lazy package manager ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- [[ Plugins ]]
require("lazy").setup({
    -- Colorscheme
    {
        "ellisonleao/gruvbox.nvim",
        opts = {},
    },

    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "williamboman/mason.nvim", config = true },
            "williamboman/mason-lspconfig.nvim",
            -- Useful status updates for LSP
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { "j-hui/fidget.nvim",       opts = {} },
            -- "folke/neodev.nvim",
        },
        config = function()
            --  Use :FormatToggle to toggle autoformatting on or off
            local format_is_enabled = true
            vim.api.nvim_create_user_command("FormatToggle", function()
                format_is_enabled = not format_is_enabled
                print("Setting autoformatting to: " .. tostring(format_is_enabled))
            end, {})

            -- Create an augroup that is used for managing our formatting autocmds.
            --      We need one augroup per client to make sure that multiple clients
            --      can attach to the same buffer without interfering with each other.
            local _augroups = {}
            local get_augroup = function(client)
                if not _augroups[client.id] then
                    local group_name = "lsp-format-" .. client.name
                    local id = vim.api.nvim_create_augroup(group_name, { clear = true })
                    _augroups[client.id] = id
                end

                return _augroups[client.id]
            end

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("lsp-attach-format", { clear = true }),
                callback = function(args)
                    local client_id = args.data.client_id
                    local client = vim.lsp.get_client_by_id(client_id)
                    local bufnr = args.buf

                    if not client.server_capabilities.documentFormattingProvider then
                        return
                    end

                    -- Tsserver usually works poorly. Sorry you work with bad languages
                    -- You can remove this line if you know what you're doing :)
                    if client.name == "tsserver" then
                        return
                    end

                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = get_augroup(client),
                        buffer = bufnr,
                        callback = function()
                            if not format_is_enabled then
                                return
                            end

                            vim.lsp.buf.format({
                                async = false,
                                filter = function(c)
                                    return c.id == client.id
                                end,
                            })
                        end,
                    })
                end,
            })
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        build = ":TSUpdate",
    },

    {
        "tpope/vim-sleuth",
    },

    {
        "folke/which-key.nvim",
        opts = {},
    },

    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
            "rafamadriz/friendly-snippets",
            "Saecki/crates.nvim",
        },
    },

    {
        "numToStr/Comment.nvim",
        opts = {},
    },

    {
        "kdheepak/lazygit.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },

    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        cmd = "Neotree",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        deactivate = function()
            vim.cmd([[Neotree close]])
        end,
        init = function()
            if vim.fn.argc(-1) == 1 then
                local stat = vim.loop.fs_stat(vim.fn.argv(0))
                if stat and stat.type == "directory" then
                    require("neo-tree")
                end
            end
        end,
        opts = {
            sources = { "filesystem" },
            open_files_do_not_replace_types = { "terminal" },
            filesystem = {
                bind_to_cwd = true,
                follow_current_file = {
                    enabled = true,
                    leave_dirs_open = true,
                },
                use_libuv_file_watcher = true,
                filtered_items = {
                    visible = true, -- when true, they will just be displayed differently than normal items
                },
            },
            window = {
                width = 55,
                mappings = {
                    ["<space>"] = "none",
                },
            },
            default_component_configs = {
                indent = {
                    with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
                    expander_collapsed = "",
                    expander_expanded = "",
                    expander_highlight = "NeoTreeExpander",
                },
            },
        },
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
    },

    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                component_separators = "|",
                section_separators = "",
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { { 'filename', path = 1, shorting_target = 60 } },
                lualine_c = {},
                lualine_x = { 'diff', 'diagnostics', 'encoding', 'filetype' },
                lualine_y = { 'progress' },
                lualine_z = { 'location' }
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { { 'filename', path = 1, shorting_target = 60 } },
                lualine_x = {},
                lualine_y = {},
                lualine_z = { 'location' }
            },
        },
    },

    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- Fuzzy Finder Algorithm which requires local dependencies to be built.
            -- Only load if `make` is available. Make sure you have the system
            -- requirements installed.
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                -- NOTE: If you are having trouble with this installation,
                --       refer to the README for telescope-fzf-native for more instructions.
                build = "make",
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
        },
    },

    {
        -- Adds git related signs to the gutter, as well as utilities for managing changes
        "lewis6991/gitsigns.nvim",
        opts = {
            -- See `:help gitsigns.txt`
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map({ "n", "v" }, "]h", function()
                    if vim.wo.diff then
                        return "]h"
                    end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true, desc = "Go to next [h]unk" })

                map({ "n", "v" }, "[h", function()
                    if vim.wo.diff then
                        return "[h"
                    end
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true, desc = "Go to previous [h]unk" })

                -- Actions
                map("v", "<leader>hs", function()
                    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, { desc = "[s]tage Git [h]unk" })
                map("v", "<leader>hr", function()
                    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, { desc = "[r]eset Git [h]unk" })

                map("n", "<leader>hs", gs.stage_hunk, { desc = "[s]tage Git [h]unk" })
                map("n", "<leader>hr", gs.reset_hunk, { desc = "[r]eset Git [h]unk" })
                map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "[u]ndo stage [h]unk" })
                map("n", "<leader>hS", gs.stage_buffer, { desc = "Git [S]tage buffer" })
                map("n", "<leader>hR", gs.reset_buffer, { desc = "Git [R]eset buffer" })
                map("n", "<leader>hp", gs.preview_hunk, { desc = "[p]review Git [h]unk" })
                map("n", "<leader>hb", function()
                    gs.blame_line({ full = false })
                end, { desc = "Git [b]lame line" })
                map("n", "<leader>hd", gs.diffthis, { desc = "Git [d]iff against index" })
                map("n", "<leader>hD", function()
                    gs.diffthis("~")
                end, { desc = "Git [D]iff against last commit" })

                -- Toggles
                map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "[t]oggle Git blame line" })
                map("n", "<leader>td", gs.toggle_deleted, { desc = "[t]oggle Git show [d]eleted" })

                -- Text object
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "select git hunk" })
            end,
        },
    },

    {
        "RRethy/vim-illuminate",
        event = "BufNew",
        opts = {
            delay = 200,
            large_file_cutoff = 2000,
            large_file_overrides = {
                providers = { "lsp" },
            },
        },
        config = function(_, opts)
            require("illuminate").configure(opts)

            local function map(key, dir, buffer)
                vim.keymap.set("n", key, function()
                    require("illuminate")["goto_" .. dir .. "_reference"](false)
                end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
            end

            map("]]", "next")
            map("[[", "prev")

            -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    local buffer = vim.api.nvim_get_current_buf()
                    map("]]", "next", buffer)
                    map("[[", "prev", buffer)
                end,
            })
        end,
        keys = {
            { "]]", desc = "Next Reference" },
            { "[[", desc = "Prev Reference" },
        },
    },

    -- Rust
    {
        "Saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        opts = {
            src = {
                cmp = { enabled = true },
            },
        },
    },
}, {})

-- [[ Colorscheme ]]
vim.cmd("colorscheme gruvbox")

-- [[ Keymaps ]]
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-h>", ":noh<CR>")

vim.keymap.set("n", "<leader><leader>", "<C-^>", { desc = "[ ] Toggle last buffer" })
vim.keymap.set("n", "<leader>tl", ":set rnu!<CR>", { desc = "[t]oggle relativenumber" })

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [d]iagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [d]iagnostic" })
vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float, { desc = "Open [f]loating [d]iagnostic" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Open [d]iagnostic [l]ist" })

vim.keymap.set("v", "<leader>p", '"_dP', { desc = "Smart [p]aste" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move lines up" })

-- [[ indent-blankline ]]
require("ibl").setup {
    indent = { char = '▏' },
    scope = { enabled = false },
}

-- [[ LazyGit ]]
vim.keymap.set("n", "<leader>hg", ":LazyGit<CR>", { desc = "Lazy[g]it" })

--[[ Neotree ]]
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "[e]xplore" })

-- [[ WhichKey ]]
-- document existing key chains
require("which-key").register({
    ["<leader>c"] = { name = "[c]ode", _ = "which_key_ignore" },
    ["<leader>h"] = { name = "[h]unk (Git)", _ = "which_key_ignore" },
    ["<leader>s"] = { name = "[s]earch", _ = "which_key_ignore" },
    ["<leader>t"] = { name = "[t]oggle", _ = "which_key_ignore" },
    ["<leader>w"] = { name = "[w]orkspace", _ = "which_key_ignore" },
    ["<leader>d"] = { name = "[d]iagnostic", _ = "which_key_ignore" },
})
-- register which-key VISUAL mode
-- required for visual <leader>hs (hunk stage) to work
require("which-key").register({
    ["<leader>"] = { name = "VISUAL <leader>" },
    ["<leader>h"] = { "Git [h]unk" },
}, { mode = "v" })

-- [[ Highlight on yank ]]
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<C-u>"] = false,
                ["<C-d>"] = false,
            },
        },
        layout_strategy = 'vertical',
        layout_config = {
            height = 0.9,
            mirror = true,
            width = 0.6,
        },
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
    local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
    if vim.v.shell_error ~= 0 then
        print("Not a git repository. Searching on current working directory")
        return cwd
    end
    return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
    local git_root = find_git_root()
    if git_root then
        require("telescope.builtin").live_grep({
            search_dirs = { git_root },
        })
    end
end

vim.api.nvim_create_user_command("LiveGrepGitRoot", live_grep_git_root, {})

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>f", require("telescope.builtin").oldfiles, { desc = "[f]ind recently opened files" })
vim.keymap.set("n", "<leader>?", require("telescope.builtin").buffers, { desc = "[?] find existing buffers" })

vim.keymap.set("n", "<leader>/", require("telescope.builtin").current_buffer_fuzzy_find,
    { desc = "[/] Fuzzily search in current buffer" })

vim.keymap.set("n", "<leader>s/", function()
    require("telescope.builtin").live_grep({
        grep_open_files = true,
        prompt_title = "Live Grep in Open Files",
    })
end, { desc = "[s]earch [/] in Open Files" })

vim.keymap.set("n", "<leader>sa", function()
    require("telescope.builtin").find_files({
        hidden = true,
        no_ignore = true,
        prompt_title = "Find Files in CWD",
    })
end, { desc = "[s]earch [a]ll cwd files" })

vim.keymap.set("n", "<leader>sd", function() require("telescope.builtin").diagnostics({ bufnr = 0 }) end,
    { desc = "[s]earch [d]iagnostic" })
vim.keymap.set("n", "<leader>sD", function() require("telescope.builtin").diagnostics({ bufnr = nil }) end,
    { desc = "[s]earch [D]iagnostic in workspace" })
vim.keymap.set("n", "<leader>sf", function()
    require("telescope.builtin").find_files({
        hidden = true,
    })
end, { desc = "[s]earch [f]iles" })

vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[s]earch by [g]rep" })
vim.keymap.set("n", "<leader>sG", ":LiveGrepGitRoot<CR>", { desc = "[s]earch by [G]rep on Git Root" })
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").git_files, { desc = "[s]earch Git files" })
vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume, { desc = "[s]earch [r]esume" })
vim.keymap.set("n", "<leader>sH", require("telescope.builtin").help_tags, { desc = "[s]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[s]earch current [w]ord" })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
    require("nvim-treesitter.configs").setup({
        -- Add languages to be installed here that you want installed for treesitter
        ensure_installed = {
            "c",
            "go",
            "lua",
            "python",
            "ron",
            "rust",
            "javascript",
            "toml",
            "typescript",
            "vimdoc",
            "vim",
            "bash",
        },

        -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
        auto_install = false,
        -- Install languages synchronously (only applied to `ensure_installed`)
        sync_install = false,
        -- List of parsers to ignore installing
        ignore_install = {},
        -- You can specify additional Treesitter modules here: -- For example: -- playground = {--enable = true,-- },
        modules = {},
        highlight = { enable = true, additional_vim_regex_highlighting = false },
        indent = { enable = true },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<c-space>",
                node_incremental = "<c-space>",
                scope_incremental = "<c-s>",
                node_decremental = "<M-space>",
            },
        },
        rainbow = {
            enable = true,
            extended_mode = true,
            max_file_lines = nil,
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                keymaps = {
                    -- You can use the capture groups defined in textobjects.scm
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
                set_jumps = true, -- whether to set jumps in the jumplist
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

--[[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
    -- NOTE: Remember that lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself
    -- many times.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    local function telescope_lsp_references()
        require("telescope.builtin").lsp_references({
            include_declaration = false,
            show_line = false,
        })
    end

    local function telescope_lsp_type_definitions()
        require("telescope.builtin").lsp_type_definitions({
            show_line = false,
        })
    end

    local function telescope_lsp_implementations()
        require("telescope.builtin").lsp_implementations({
            show_line = false,
        })
    end

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        vim.lsp.buf.format()
    end, { desc = "Format current buffer with LSP" })

    -- code
    nmap("<leader>ca", vim.lsp.buf.code_action, "[c]ode [a]ction")
    nmap("<leader>cf", ":Format<CR>", "[f]ormat buffer")
    nmap("<leader>cr", vim.lsp.buf.rename, "[r]ename symbol")

    -- goto
    nmap("gd", require("telescope.builtin").lsp_definitions, "[g]oto [d]efinition")
    nmap("gs", telescope_lsp_type_definitions, "[g]oto type definitions")
    nmap("gr", telescope_lsp_references, "[g]oto [r]eferences")
    nmap("gD", vim.lsp.buf.declaration, "[g]oto [D]eclaration")
    nmap("gI", telescope_lsp_implementations, "[g]oto [I]mplementation")

    -- search
    nmap("<leader>ss", require("telescope.builtin").lsp_document_symbols, "[s]earch document [s]ymbols")
    nmap("<leader>sS", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[s]earch workspace [S]ymbols")

    -- See `:help K` for why this keymap
    nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

    -- Lesser used LSP functionality
    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[w]orkspace [a]dd Folder")
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[w]orkspace [r]emove Folder")
    nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[w]orkspace [l]ist Folders")
end

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require("mason").setup()
require("mason-lspconfig").setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
    rust_analyzer = {
        ["rust-analyzer"] = {
            cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
            },
            -- Add clippy lints for Rust.
            checkOnSave = {
                allFeatures = true,
                command = "clippy",
                extraArgs = { "--no-deps" },
            },
            completion = { postfix = { enable = false } },
            procMacro = {
                enable = true,
                ignored = {
                    ["async-trait"] = { "async_trait" },
                    ["napi-derive"] = { "napi" },
                    ["async-recursion"] = { "async_recursion" },
                },
            },
        },
    },
    taplo = {},
    -- clangd = {},
    -- gopls = {},
    -- pyright = {},
    -- tsserver = {},
    -- html = { filetypes = { 'html', 'twig', 'hbs'} },

    lua_ls = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            diagnostics = { disable = { 'missing-fields' } },
        },
    },
}

-- Setup neovim lua configuration
-- require("neodev").setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
    ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers({
    function(server_name)
        require("lspconfig")[server_name].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes,
        })
    end,
})

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
luasnip.config.setup({})

cmp.setup({
    completion = {
        completeopt = "menu,menuone,noinsert",
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-Space>"] = cmp.mapping.complete({}),
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        }),
    }),
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    sources = {
        { name = "luasnip" },
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
        { name = "crates" },
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
})

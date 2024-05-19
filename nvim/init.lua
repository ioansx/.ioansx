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

vim.opt.clipboard = "unnamedplus"
-- vim.opt.colorcolumn = "120"
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

require("lazy").setup({
    {
        "ellisonleao/gruvbox.nvim",
        opts = {},
        config = function()
            vim.cmd("colorscheme gruvbox")
        end
    },

    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "williamboman/mason.nvim", config = true },
            "williamboman/mason-lspconfig.nvim",
            { "j-hui/fidget.nvim",       opts = {} },
        },
        config = function()
            --  This function gets run when an LSP connects to a particular buffer.
            local on_attach = function(_, bufnr)
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
                nmap('<leader>ca', function()
                    vim.lsp.buf.code_action { context = { only = { 'quickfix', 'refactor', 'source' } } }
                end, '[C]ode [A]ction')
                nmap("<leader>cf", ":Format<CR>", "[f]ormat buffer")
                nmap("<leader>cr", vim.lsp.buf.rename, "[r]ename symbol")

                -- goto
                nmap("gd", require("telescope.builtin").lsp_definitions, "[g]oto [d]efinition")
                nmap("gs", telescope_lsp_type_definitions, "[g]oto type definitions")
                nmap("gr", telescope_lsp_references, "[g]oto [r]eferences")
                nmap("gD", vim.lsp.buf.declaration, "[g]oto [D]eclaration")
                nmap("gI", telescope_lsp_implementations, "[g]oto [I]mplementation")

                -- search
                nmap("<leader>sS", require("telescope.builtin").lsp_document_symbols, "[s]earch document [S]ymbols")
                nmap("<leader>ss", require("telescope.builtin").lsp_dynamic_workspace_symbols,
                    "[s]earch workspace [s]ymbols")

                nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
            end

            -- mason-lspconfig requires that these setup functions are called in this order
            -- before setting up the servers.
            require("mason").setup()
            require("mason-lspconfig").setup()

            local servers = {
                eslint = {},
                cssls = {},
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
                        check = {
                            command = "clippy",
                            features = "all",
                        },
                        -- procMacro = {
                        --     enable = false,
                        -- },
                        completion = {
                            fullFunctionSignatures = { enable = true },
                            postfix = { enable = false },
                        },
                        -- lru = {
                        --     capacity = 512, -- default 128
                        -- },
                    },
                },
                taplo = {},
                tsserver = {},
                svelte = {},
            }

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
            -- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
            vim.defer_fn(function()
                require("nvim-treesitter.configs").setup({
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
                        "fish",
                        "svelte",
                    },

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
        end
    },


    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            {
                'L3MON4D3/LuaSnip',
                build = 'make install_jsregexp',
            },
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            luasnip.config.setup({})

            cmp.setup({
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                formatting = {
                    format = function(entry, vim_item)
                        local menu
                        local ci = entry.completion_item
                        if ci.labelDetails and ci.labelDetails.detail then
                            menu = ci.labelDetails.detail
                            if string.len(menu) > 37 then
                                menu = string.sub(menu, 1, 37) .. "..."
                            end
                        end
                        vim_item.menu = menu
                        return vim_item
                    end
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.scroll_docs(4),
                    ["<C-p>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-Space>"] = cmp.mapping.complete({}),
                    ["<Tab>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = true,
                    }),
                }),
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                sorting = {
                    comparators = {
                        cmp.config.compare.offset,
                        cmp.config.compare.exact,
                        cmp.config.compare.score,
                        cmp.config.compare.kind,
                        cmp.config.compare.sort_text,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                    },
                },
                sources = {
                    { name = "copilot" },
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                },
            })
        end
    },

    {
        "kdheepak/lazygit.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            vim.keymap.set("n", "<leader>hg", ":LazyGit<CR>", { desc = "Lazy[g]it" })
        end
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
        -- init = function()
        --     if vim.fn.argc(-1) == 1 then
        --         local stat = vim.loop.fs_stat(vim.fn.argv(0))
        --         if stat and stat.type == "directory" then
        --             require("neo-tree")
        --         end
        --     end
        -- end,
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
                    visible = true,
                    hide_gitignored = false,
                    hide_dotfiles = false,
                },
            },
            window = {
                width = 55,
                mappings = {
                    ["<space>"] = "none",
                },
            },
        },
        config = function()
            vim.keymap.set("n", "<leader>te", ":Neotree toggle<CR>", { desc = "[t]oggle [e]xplore" })
        end
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
                    layout_strategy = 'vertical',
                    layout_config = {
                        height = 0.9,
                        mirror = true,
                        width = 0.6,
                    },
                },
                extensions = {
                    undo = {
                        side_by_side = true,
                        layout_strategy = "vertical",
                        layout_config = {
                            preview_height = 0.7,
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

            vim.keymap.set("n", "<leader>f", require("telescope.builtin").oldfiles,
                { desc = "[f]ind recently opened files" })
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
            vim.keymap.set("n", "<leader>su", require("telescope").extensions.undo.undo, { desc = "[s]earch [u]ndotree" })
            vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string,
                { desc = "[s]earch current [w]ord" })
        end
    },

    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {},
        config = function()
            vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end, { desc = "toggle" })
            vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end,
                { desc = "[w]orkspace diagnostic" })
            vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end,
                { desc = "[d]ocument diagnostic" })
            vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end,
                { desc = "[q]uickfix list" })
            vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end,
                { desc = "[l]ocation list" })
            vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end,
                { desc = "LSP [R]eferences" })
        end
    },

    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup()

            vim.keymap.set("n", "<leader>mm", function() harpoon:list():add() end, { desc = "harpoon [m]ark" })
            vim.keymap.set("n", "<leader>ml", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
                { desc = "harpoon [m]ark" })

            vim.keymap.set("n", "<leader>ma", function() harpoon:list():select(1) end, { desc = "harpoon goto 1" })
            vim.keymap.set("n", "<leader>ms", function() harpoon:list():select(2) end, { desc = "harpoon goto 2" })
            vim.keymap.set("n", "<leader>md", function() harpoon:list():select(3) end, { desc = "harpoon goto 3" })
            vim.keymap.set("n", "<leader>mf", function() harpoon:list():select(4) end, { desc = "harpoon goto 4" })
            vim.keymap.set("n", "<leader>mg", function() harpoon:list():select(5) end, { desc = "harpoon goto 5" })

            vim.keymap.set("n", "<leader>mp", function() harpoon:list():prev() end, { desc = "harpoon goto [p]rev" })
            vim.keymap.set("n", "<leader>mn", function() harpoon:list():next() end, { desc = "harpoon goto [n]ext" })
        end,
    },

    {
        "lewis6991/gitsigns.nvim",
        opts = {
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

    {
        'stevearc/conform.nvim',
        opts = {
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
            formatters_by_ft = {
                ["lua"] = { 'stylua' },
                ["javascript"] = { "prettier" },
                ["javascriptreact"] = { "prettier" },
                ["typescript"] = { "prettier" },
                ["typescriptreact"] = { "prettier" },
                ["vue"] = { "prettier" },
                ["css"] = { "prettier" },
                ["scss"] = { "prettier" },
                ["less"] = { "prettier" },
                ["html"] = { "prettier" },
                ["json"] = { "prettier" },
                ["jsonc"] = { "prettier" },
                ["yaml"] = { "prettier" },
                ["markdown"] = { "prettier" },
                ["markdown.mdx"] = { "prettier" },
                ["graphql"] = { "prettier" },
                ["handlebars"] = { "prettier" },
            },
        },
    },

    {
        "tpope/vim-sleuth",
    },

    {
        "folke/which-key.nvim",
        event = 'VimEnter',
        config = function()
            require("which-key").setup()

            require("which-key").register({
                ["<leader>c"] = { name = "[c]ode", _ = "which_key_ignore" },
                ["<leader>d"] = { name = "[d]iagnostic", _ = "which_key_ignore" },
                ["<leader>h"] = { name = "[h]unk (Git)", _ = "which_key_ignore" },
                ["<leader>m"] = { name = "[harpoon]", _ = "which_key_ignore" },
                ["<leader>s"] = { name = "[s]earch", _ = "which_key_ignore" },
                ["<leader>t"] = { name = "[t]oggle", _ = "which_key_ignore" },
                ["<leader>x"] = { name = "[trouble]", _ = "which_key_ignore" },
                ["<leader>y"] = { name = "[y]ank", _ = "which_key_ignore" },
            })

            require("which-key").register({
                ["<leader>"] = { name = "VISUAL <leader>" },
                ["<leader>h"] = { "Git [h]unk" },
            }, { mode = "v" })
        end,
    },

    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false }
    },

    {
        'stevearc/oil.nvim',
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("oil").setup({
                columns = {
                    "icon",
                },
                delete_to_trash = true,
                view_options = {
                    show_hidden = true,
                },
            })

            vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
        end,
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function()
            require("ibl").setup({
                indent = { char = '▏' },
                scope = { enabled = false },
            })
        end
    },

    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = { enabled = false },
                panel = { enabled = false },
            })
        end,
    },

    {
        "zbirenbaum/copilot-cmp",
        config = function()
            require("copilot_cmp").setup()
        end
    },

    {
        "Saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        opts = {},
    },
}, {})

-- [[ Keymaps ]]
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<leader>e", "<C-w>w<CR>", { desc = "[e] Switch windows" })
vim.keymap.set("n", "<leader>th", ":noh<CR>", { desc = "[t]oggle [h]ighlight off" })

vim.keymap.set("n", "<leader><leader>", "<C-^>", { desc = "[ ] Toggle last buffer" })
vim.keymap.set("n", "<leader>tl", ":set rnu!<CR>", { desc = "[t]oggle relativenumber" })
vim.keymap.set("n", "<leader>tk", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
    { desc = "[t]oggle inlay hints" })

vim.keymap.set("n", "<leader>ya", ":let @+ = expand('%:p')<CR>", { desc = "[y]ank [a]bsolute file path" })
vim.keymap.set("n", "<leader>yc", ":let @+ = join([expand('%:.'),  line('.')], ':')<CR>",
    { desc = "[y]ank relative file path:line" })
vim.keymap.set("n", "<leader>yf", ":let @+ = expand('%:t')<CR>", { desc = "[y]ank [f]ile name" })
vim.keymap.set("n", "<leader>yr", ":let @+ = expand('%:.')<CR>", { desc = "[y]ank [r]elative file path" })

vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float, { desc = "Open [f]loating [d]iagnostic" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Open [d]iagnostic [l]ist" })

vim.keymap.set("v", "<leader>p", '"_dP', { desc = "Smart [p]aste" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move lines up" })

vim.keymap.set("n", "[q", ":cprev<CR>", { desc = "cprev" })
vim.keymap.set("n", "]q", ":cnext<CR>", { desc = "cnext" })

-- [[ Highlight on yank ]]
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})

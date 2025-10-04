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

vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = "menu,menuone,noinsert,popup"
vim.opt.cursorline = true
vim.opt.mouse = "a"
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
	if vim.fn.getloclist(0).winid ~= 0 then
		vim.cmd("lclose")
	else
		vim.cmd("lopen")
	end
end

nmap("<leader>tn", ":set rnu!<CR>", { desc = "toggle relativenumber" })
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

-- ---
-- LSP
-- ---
local function show_lsp_documentation()
	-- The default hover is only closed on cursor move by default.
	vim.lsp.buf.hover({
		close_events = { "BufWinLeave", "CursorMoved", "CursorMovedI", "InsertEnter" }
	})
end

nmap("gD", vim.lsp.buf.declaration, { desc = "vim.lsp.buf.declaration()" })
nmap("gd", vim.lsp.buf.definition, { desc = "vim.lsp.buf.definition()" })
nmap("grs", vim.lsp.buf.workspace_symbol, { desc = "vim.lsp.buf.workspace_symbol()" })
nmap("K", show_lsp_documentation, { desc = "vim.lsp.buf.hover()" })
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
	"NMAC427/guess-indent.nvim",
	{ "j-hui/fidget.nvim",  opts = {} },
	{ "Saecki/crates.nvim", event = { "BufRead Cargo.toml" }, opts = {} },

	{
		"nvim-mini/mini.nvim",
		version = false,
		config = function()
			local mini_clue = require("mini.clue")
			mini_clue.setup({
				triggers = {
					{ mode = "n", keys = "<Leader>" },
					{ mode = "x", keys = "<Leader>" },
					{ mode = "n", keys = "[" },
					{ mode = "n", keys = "]" },
					{ mode = "i", keys = "<C-x>" },
					{ mode = "n", keys = "g" },
					{ mode = "x", keys = "g" },
					{ mode = "n", keys = "'" },
					{ mode = "n", keys = "`" },
					{ mode = "x", keys = "'" },
					{ mode = "x", keys = "`" },
					{ mode = "n", keys = '"' },
					{ mode = "x", keys = '"' },
					{ mode = "i", keys = "<C-r>" },
					{ mode = "c", keys = "<C-r>" },
					{ mode = "n", keys = "<C-w>" },
					{ mode = "n", keys = "z" },
					{ mode = "x", keys = "z" },
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
					style = "sign",
					signs = { add = "▒", change = "▒", delete = "▒" },
				},
				mappings = {
					reset = "<leader>gr",
					goto_first = "[H",
					goto_prev = "[h",
					goto_next = "]h",
					goto_last = "]H",
				},
			})
			require("mini.icons").setup()
			local mini_indentscope = require("mini.indentscope")
			mini_indentscope.setup({
				draw = {
					delay = 0,
					animation = mini_indentscope.gen_animation.none(),
				},
				options = { indent_at_cursor = false },
				symbol = '│',
			})
			require("mini.splitjoin").setup()
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
			-- indent = { enabled = true, animate = { enabled = false } },
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
						{ win = "preview", title = "{preview}", height = 0.55,    border = "bottom" },
						{ win = "input",   height = 1,          border = "bottom" },
						{ win = "list",    border = "hpad" },
					}
				},
			},
		},
		keys = {
			{ "<leader>/",       function() Snacks.picker.grep() end,                                   desc = "Grep" },
			{ "<leader>f",       function() Snacks.picker.files({ hidden = true }) end,                 desc = "Find Files" },
			{ "<leader>F",       function() Snacks.picker.files({ hidden = true, ignored = true }) end, desc = "Find Files (incl. ignored)" },
			{ "<leader><space>", function() Snacks.picker.buffers({ sort_lastused = true }) end,        desc = "Find Buffers" },
			{ "<leader>gb",      function() Snacks.git.blame_line() end,                                desc = "Git Branches" },
			{ "<leader>gd",      function() Snacks.picker.git_diff() end,                               desc = "Git Diff (Hunks)" },
			{ "<leader>gf",      function() Snacks.picker.git_log_file() end,                           desc = "Git Log File" },
			{ "<leader>se",      function() Snacks.picker.recent() end,                                 desc = "Recent" },
			{ "<leader>sr",      function() Snacks.picker.resume() end,                                 desc = "Resume" },
			{ "<leader>ss",      function() Snacks.picker.lsp_workspace_symbols() end,                  desc = "LSP Workspace Symbols" },
			{ "<leader>su",      function() Snacks.picker.undo() end,                                   desc = "Undo History" },
			{ "<leader>sw",      function() Snacks.picker.grep_word() end,                              desc = "Visual selection or word" },
		}
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
					"jsonls",
					"lua_ls",
					"rust_analyzer",
					"svelte",
					"tailwindcss",
					"taplo",
					"ts_ls",
					"yamlls",
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

-- -------------------------------------
-- Auto-format ("lint") on save fallback
-- -------------------------------------
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("my.lsp.fmt", {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if not client:supports_method('textDocument/willSaveWaitUntil')
			and client:supports_method('textDocument/formatting') then
			vim.api.nvim_create_autocmd('BufWritePre', {
				group = vim.api.nvim_create_augroup('my.lsp.fmt', { clear = false }),
				buffer = args.buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 50 })
				end,
			})
		end
	end,
})

-- ---------------------------
-- Non-CWD files are read-only
-- ---------------------------
local project_only_writable_group = vim.api.nvim_create_augroup("ProjectOnlyWritable", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
	group = project_only_writable_group,
	pattern = "*",
	callback = function(args)
		if vim.bo[args.buf].buftype ~= "" then -- ignore non-file buffers
			return
		end

		local file_path = vim.fn.expand("%:p")
		if file_path == "" then
			return
		end

		local cwd = vim.fn.getcwd()
		-- To avoid partial matches (e.g., /foo/bar vs /foo/bar-baz),
		-- ensure the CWD path is followed by a path separator.
		local cwd_prefix = cwd .. (cwd:sub(-1) == "/" and "" or "/")

		if not (vim.startswith(file_path, cwd_prefix) or file_path == cwd) then
			vim.bo[args.buf].readonly = true
		end
	end,
})

-- -------------------------
-- LazyGit floating terminal
-- -------------------------
local function LazyGitOpen()
	local LazyGitState = { win = nil, buf = nil }
	if LazyGitState.win and vim.api.nvim_win_is_valid(LazyGitState.win) then
		pcall(vim.api.nvim_win_close, LazyGitState.win, true)
		LazyGitState.win = nil
		return
	end

	if vim.fn.executable("lazygit") ~= 1 then
		vim.notify("lazygit not found in PATH", vim.log.levels.ERROR)
		return
	end

	LazyGitState.buf = vim.api.nvim_create_buf(false, true)
	LazyGitState.win = vim.api.nvim_open_win(LazyGitState.buf, true, {
		relative = "editor",
		width = vim.o.columns,
		height = vim.o.lines - 1, -- -1 for the command line
		col = 0,
		row = 0,
		border = "none",
		style = "minimal",
		noautocmd = true,
	})

	pcall(vim.api.nvim_buf_set_option, LazyGitState.buf, "filetype", "lazygit")

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

	vim.cmd.startinsert()
end

nmap("<leader>gg", LazyGitOpen, { desc = "LazyGit (float)" })

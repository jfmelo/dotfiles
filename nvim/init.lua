do
	vim.loader.enable()
	vim.g.mapleader = " "
	vim.g.maplocalleader = " "
	vim.o.number = true
	vim.o.relativenumber = true
	vim.o.mouse = "" -- disable mouse mode
	vim.o.showmode = true -- isn't needed with statusline
	vim.schedule(function() -- sync clipboard with OS
		vim.o.clipboard = "unnamedplus"
	end)
	vim.o.breakindent = true
	vim.o.undofile = true
	vim.o.ignorecase = true
	vim.o.smartcase = true
	vim.o.signcolumn = "yes"
	vim.o.updatetime = 250
	vim.o.timeoutlen = 300
	vim.o.splitright = true
	vim.o.splitbelow = true
	vim.o.list = true
	vim.opt.listchars = { lead = "·", nbsp = "␣", tab = "» ", trail = "·" }
	vim.o.inccommand = "split"
	vim.o.cursorline = false
	vim.o.scrolloff = 5
	vim.o.confirm = true
	vim.o.wrap = false
end

do
	vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>") -- clear search highlight

	-- Diagnostic Config
	-- See :help vim.diagnostic.Opts
	vim.diagnostic.config({
		update_in_insert = false,
		severity_sort = true,
		float = { border = "rounded", source = "if_many" },
		underline = { severity = vim.diagnostic.severity.WARN },
		virtual_text = true, -- shows at the end of the line
		virtual_lines = false, -- shows underneath the line
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "󰅚 ",
				[vim.diagnostic.severity.WARN] = "󰀪 ",
				[vim.diagnostic.severity.INFO] = "󰋽 ",
				[vim.diagnostic.severity.HINT] = "󰌶 ",
			},
		},
		jumps = { float = true },
	})

	-- shortcut to return to the file explorer
	vim.keymap.set("n", "<leader>ex", "<Cmd>Explore<CR>")

	-- move lines up and down in visual mode
	vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Moves line down" })
	vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Moves line up" })

	-- diagnostic keymaps
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
	vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]error messages" })
	vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

	-- highlight yanked text
	vim.api.nvim_create_autocmd("TextYankPost", {
		desc = "Highlight when yanking text",
		group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
		callback = function()
			vim.hl.on_yank()
		end,
	})

	-- organize imports on save a go file
	vim.api.nvim_create_autocmd("BufWritePre", {
		desc = "Organize imports on save a go file",
		pattern = "*.go",
		callback = function()
			if vim.lsp.get_clients({ bufnr = 0 }) == 0 then
				return
			end
			vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
		end,
	})
end

-- install lazy.nvim plugin manager
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- ocnfigured and install plugins
require("lazy").setup({
	{
		"NMAC427/guess-indent.nvim",
		opts = {},
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},
	{
		"tpope/vim-sleuth",
	},
	{
		"tpope/vim-fugitive",
	},
	{
		"github/copilot.vim",
		config = function()
			vim.g.copilot_enabled = false
		end,
	},
	{ import = "plugins" },
})

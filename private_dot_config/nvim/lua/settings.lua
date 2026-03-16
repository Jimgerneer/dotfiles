vim.g.format_on_save = true

vim.opt.autoindent = true
vim.opt.autoread = true
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.backup = false
vim.opt.clipboard:append("unnamedplus")
vim.opt.laststatus = 3
vim.opt.copyindent = true
vim.opt.encoding = "UTF-8"
vim.opt.equalalways = false
vim.opt.expandtab = true
vim.opt.spellfile = vim.fn.expand("~") .. "/.config/nvim/spell/en.utf-8.add"
vim.opt.fillchars = {
	eob = " ",
	vert = "║",
	horiz = "═",
	horizup = "╩",
	horizdown = "╦",
	vertleft = "╣",
	vertright = "╠",
	verthoriz = "╬",
}
vim.opt.hidden = true
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.inccommand = "nosplit"
vim.opt.lazyredraw = true
vim.opt.modeline = false
vim.opt.mouse = { h = true, a = true }
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 5
vim.opt.shell = "bash"
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.showmode = false
vim.opt.signcolumn = "yes:1"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.undodir = vim.fn.expand("~/.config/nvim/undo")
vim.opt.undofile = true
vim.opt.updatetime = 100
vim.opt.virtualedit = "block"
vim.opt.wildmenu = true
vim.opt.wrap = false
vim.opt.cmdheight = 0

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
	end,
})

vim.api.nvim_set_hl(0, "DiagnosticLineError", { bg = "#2d1117" })

vim.diagnostic.config({
	header = false,
	float = {
		source = "always",
		border = "rounded",
	},
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "✘",
			[vim.diagnostic.severity.WARN] = "▲",
			[vim.diagnostic.severity.INFO] = "●",
			[vim.diagnostic.severity.HINT] = "◆",
		},
		linehl = {
			[vim.diagnostic.severity.ERROR] = "DiagnosticLineError",
		},
	},
	underline = true,
	update_in_insert = false,
	virtual_text = true,
})

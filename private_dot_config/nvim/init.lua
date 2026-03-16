-- Leader Key
vim.g.mapleader = " "

-- Key Maps
local map = vim.keymap.set
map("n", "<Leader>wl", ":rightbelow vsp<CR>", { silent = true, desc = "Split right" })
map("n", "<Leader>wh", ":leftabove vsp<CR>", { silent = true, desc = "Split left" })
map("n", "<Leader>wk", ":leftabove sp<CR>", { silent = true, desc = "Split up" })
map("n", "<Leader>wj", ":rightbelow sp<CR>", { silent = true, desc = "Split down" })
map("n", "<C-j>", "<C-W><C-J>", { silent = true, desc = "select window below" })
map("n", "<C-k>", "<C-W><C-k>", { silent = true, desc = "select window above" })
map("n", "<C-l>", "<C-W><C-l>", { silent = true, desc = "select window to the right" })
map("n", "<C-h>", "<C-W><C-h>", { silent = true, desc = "select window to the left" })
map("n", "<Leader>wL", "<C-W>L", { silent = true, desc = "Move window right" })
map("n", "<Leader>wK", "<C-W>K", { silent = true, desc = "Move window up" })
map("n", "<Leader>wJ", "<C-W>J", { silent = true, desc = "Move window down" })
map("n", "<Leader>wH", "<C-W>H", { silent = true, desc = "Move window left" })

map("n", "<Leader>e", vim.diagnostic.open_float, { silent = true, desc = "Show diagnostic float" })
map("n", "]d", vim.diagnostic.goto_next, { silent = true, desc = "Next diagnostic" })
map("n", "[d", vim.diagnostic.goto_prev, { silent = true, desc = "Previous diagnostic" })

require("settings")

require("config.lazy")


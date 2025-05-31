-- ~/.config/nvim/init.lua

-- 1. Set the leader FIRST (top of file)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.auto_open_neotree_on_start = true

-- 2. Load config (options, keymaps, then lazy)
require("config.options")
require("config.keymaps")
require("config.lazy")


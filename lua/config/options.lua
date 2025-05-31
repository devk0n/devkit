-- options.lua: core Neovim settings

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & indentation
opt.tabstop = 2        -- number of spaces a tab counts for
opt.shiftwidth = 2     -- size of indent
opt.expandtab = true   -- use spaces instead of tabs
opt.smartindent = true -- autoindent new lines

-- UI
opt.termguicolors = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.wrap = false       -- disable line wrapping

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Performance
opt.updatetime = 200       -- faster cursor hold events
opt.timeoutlen = 300       -- faster keybinds

-- Clipboard
opt.clipboard = "unnamedplus"

-- File encoding
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

-- Mouse support
opt.mouse = "a"

-- Disable swap/backup (optional)
opt.swapfile = false
opt.backup = false
opt.undofile = true

-- ~/.config/nvim/lua/config/highlights.lua
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e1e1e" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#1e1e1e", fg = "#d4be98" })



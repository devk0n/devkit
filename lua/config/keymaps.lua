-- ~/.config/nvim/lua/config/keymaps.lua

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Basic: save, quit, clear
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear highlights" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Buffer navigation
map("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })

-- Buffer close
map("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Close buffer" })

-- File explorer: smart toggle and focus
local last_win = nil

-- Track the last non-Neo-tree window
vim.api.nvim_create_autocmd("WinEnter", {
  callback = function()
    local buf = vim.api.nvim_buf_get_name(0)
    if not buf:match("neo%-tree") then
      last_win = vim.api.nvim_get_current_win()
    end
  end,
})

-- <leader>ee → toggle Neo-tree sidebar
map("n", "<leader>ee", "<cmd>Neotree toggle left<CR>", { desc = "Toggle Neo-tree" })

-- <leader>e → switch between Neo-tree and last file window
map("n", "<leader>e", function()
  local buf = vim.api.nvim_buf_get_name(0)
  if buf:match("neo%-tree") then
    if last_win and vim.api.nvim_win_is_valid(last_win) then
      vim.api.nvim_set_current_win(last_win)
    end
  else
    vim.cmd("Neotree focus left")
  end
end, { desc = "Focus/Return from Neo-tree" })

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find Files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live Grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help Tags" })

-- Terminal toggle (bottom)
-- <leader>et → focus any open terminal
map("n", "<leader>et", function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
    if buftype == "terminal" then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
  vim.notify("No terminal window is currently open", vim.log.levels.WARN)
end, { desc = "Focus terminal window" })

map("n", "<leader>tt", "<cmd>ToggleTerm direction=horizontal size=12<CR>", { desc = "Toggle Terminal" })
map("t", "<Esc>", [[<C-\><C-n>]], opts)


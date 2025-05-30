-- core.lua: essential utilities every Neovim setup needs

return {

  -- Lua functions used by many plugins (required)
  { "nvim-lua/plenary.nvim" },

  -- Filetype icons used by UI plugins like telescope, nvim-tree, bufferline
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Notification replacement (used by LSP or noice.nvim)
  {
    "rcarriga/nvim-notify",
    config = function()
      vim.notify = require("notify")
    end,
  },

  -- Startup profiling and plugin management
  {
    "folke/lazy.nvim",
    version = "*",
  },

}

-- ui.lua: Visuals, colorscheme, statusline, bufferline, and UI enhancements

return {

  -- Gruvbox Colorscheme
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      vim.o.background = "dark"
      require("gruvbox").setup({
        contrast = "hard",
        italic = {
          strings = false,
          comments = true,
          folds = true,
        },
      })
      vim.cmd.colorscheme("gruvbox")
    end,
  },

  -- Statusline (styled and useful)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      require("lualine").setup({
        options = {
          theme = "gruvbox",
          icons_enabled = true,
          globalstatus = true,
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "diagnostics", "filetype" },
          lualine_y = { "encoding", "fileformat" },
          lualine_z = { "location", "progress" },
        },
        inactive_sections = {
          lualine_c = { "filename" },
          lualine_x = { "location" },
        },
        extensions = { "neo-tree", "lazy", "quickfix", "man" },
      })
    end,
  },

  -- Bufferline (tab-like UI)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          diagnostics = "nvim_lsp",
          separator_style = "slant",
          always_show_bufferline = true,
        },
      })
    end,
  },

  -- UI improvements (for input/select dialogs)
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
  },
}


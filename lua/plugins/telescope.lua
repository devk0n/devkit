-- telescope.lua: Fuzzy finding, live grep, buffers, LSP symbols

return {
  -- Core telescope plugin
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.4",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = function()
          -- Tries to compile it if it's missing
          local ok = pcall(vim.cmd, "silent !make")
          if not ok then
            vim.notify("FZF native failed to compile", vim.log.levels.ERROR)
          end
        end,
      },
    },
    config = function()
      local telescope = require("telescope")

      telescope.setup({
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          entry_prefix = "  ",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.5,
              width = 0.87,
              height = 0.80,
            },
          },
    
          winblend = 0,
          file_ignore_patterns = {
            "%.git/",
            "node_modules",
            "%.cache",
            "build"
          },
          color_devicons = true,
          path_display = { "truncate" },
        },
        pickers = {
          find_files = {
            hidden = true, -- Show dotfiles
          },
        },
      })

      -- Load fzf extension
      pcall(telescope.load_extension, "fzf")
    end,
  },
}


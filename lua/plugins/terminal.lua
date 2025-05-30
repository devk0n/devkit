-- explorer.lua: Neo-tree setup (left sidebar file tree)

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- recommended
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        window = {
          position = "left",
          width = 30,
          mappings = {
            ["<space>"] = "none",
          },
        },
        filesystem = {
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
          },
          follow_current_file = {
            enabled = true,
          },
        },
      })

      -- ✅ Prevent netrw error by delaying Neotree open until after UI load
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Only open if no file is passed
          if vim.fn.argc() == 0 then
            vim.cmd("Neotree filesystem reveal left")
          end
        end,
      })
    end,
  },
}


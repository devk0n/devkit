-- explorer.lua: Neo-tree setup (left sidebar file tree)

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
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
          bind_to_cwd = true, -- ← This makes Neo-tree root match Neovim's cwd
          cwd_target = {
            sidebar = "tab",  -- or "window" depending on your preference
            current = "window",
          },
        },
      })

      -- Sync Neo-tree root with Neovim's working directory (so :e uses it)
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "neo-tree filesystem [a-z]*",
        callback = function()
          local state = require("neo-tree.sources.manager").get_state("filesystem")
          if state and state.path and state.path ~= vim.fn.getcwd() then
            vim.cmd("cd " .. state.path)
          end
        end,
      })

      -- Optional: Safely open Neo-tree if no file is passed to Neovim
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          if vim.fn.argc() == 0 then
            pcall(function()
              vim.cmd("Neotree filesystem reveal left")
            end)
          end
        end,
      })
    end,
  },
}


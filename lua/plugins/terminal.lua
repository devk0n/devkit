-- terminal.lua

return {
  "akinsho/toggleterm.nvim",
  version = "*", -- use the latest version
  config = function()
    require("toggleterm").setup({
      size = 15,
      open_mapping = [[<C-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 1,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      direction = "horizontal", -- default split
      close_on_exit = true,
      shell = vim.o.shell,
    })

    -- Keymaps
    local Terminal = require("toggleterm.terminal").Terminal

    -- Main terminal (bottom split)
    local main_term = Terminal:new({ direction = "horizontal", hidden = true })
    function _TOGGLE_MAIN_TERM()
      main_term:toggle()
    end

    -- Floating terminal (for commands)
    local float_term = Terminal:new({ direction = "float", hidden = true })
    function _TOGGLE_FLOAT_TERM()
      float_term:toggle()
    end

    -- Key bindings
    vim.keymap.set("n", "<leader>tt", _TOGGLE_MAIN_TERM, { desc = "Toggle main terminal" })
    vim.keymap.set("n", "<leader>tf", _TOGGLE_FLOAT_TERM, { desc = "Toggle floating terminal" })
    vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Terminal normal mode" })
  end,
}


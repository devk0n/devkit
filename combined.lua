-- >>> BEGIN FILE: ./combined.lua

-- <<< END FILE: ./combined.lua

-- >>> BEGIN FILE: ./init.lua
-- ~/.config/nvim/init.lua

-- 1. Set the leader FIRST (top of file)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.auto_open_neotree_on_start = true

-- 2. Load config (options, keymaps, then lazy)
require("config.options")
require("config.keymaps")
require("config.lazy")


-- <<< END FILE: ./init.lua

-- >>> BEGIN FILE: ./lua/config/keymaps.lua
-- ~/.config/nvim/lua/config/keymaps.lua

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Basic: save, quit, clear
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
map("n", "<leader>nh", "<cmd>nohlsearch<CR>", { desc = "Clear highlights" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Buffer navigation
map("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })

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

map("n", "<leader>sv", "<cmd>source $MYVIMRC<CR>", { desc = "Source config" })
map("n", "<leader>pv", "<cmd>edit $MYVIMRC<CR>", { desc = "Edit config" })
map("n", "<leader><leader>", "<cmd>so %<CR>", { desc = "Source current file" })


-- <<< END FILE: ./lua/config/keymaps.lua

-- >>> BEGIN FILE: ./lua/config/lazy.lua
-- ~/.config/nvim/lua/config/lazy.lua

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "plugins" },
}, {
  change_detection = { notify = false },
  checker = { enabled = true },
})



-- <<< END FILE: ./lua/config/lazy.lua

-- >>> BEGIN FILE: ./lua/config/options.lua
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



-- <<< END FILE: ./lua/config/options.lua

-- >>> BEGIN FILE: ./lua/plugins/cmp.lua
-- cmp.lua: Completion engine with LSP integration and useful sources
return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",     -- LSP source
      "hrsh7th/cmp-buffer",       -- Buffer words
      "hrsh7th/cmp-path",         -- Filesystem paths
      "hrsh7th/cmp-cmdline",      -- Command-line completions
      "L3MON4D3/LuaSnip",         -- Snippet engine
      "saadparwaiz1/cmp_luasnip", -- LuaSnip completion source
      "rafamadriz/friendly-snippets", -- Predefined snippets
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
}



-- <<< END FILE: ./lua/plugins/cmp.lua

-- >>> BEGIN FILE: ./lua/plugins/core.lua
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

-- <<< END FILE: ./lua/plugins/core.lua

-- >>> BEGIN FILE: ./lua/plugins/explorer.lua
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
          bind_to_cwd = true,
          cwd_target = {
            sidebar = "tab",
            current = "window",
          },
        },
      })

      -- Sync Neo-tree root with cwd
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "neo-tree filesystem [a-z]*",
        callback = function()
          local state = require("neo-tree.sources.manager").get_state("filesystem")
          if state and state.path and state.path ~= vim.fn.getcwd() then
            vim.cmd("cd " .. state.path)
          end
        end,
      })

      -- Auto-open Neo-tree if no file is passed
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


-- <<< END FILE: ./lua/plugins/explorer.lua

-- >>> BEGIN FILE: ./lua/plugins/git.lua
-- plugins/git.lua
return {
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup()
    end,
  },
}


-- <<< END FILE: ./lua/plugins/git.lua

-- >>> BEGIN FILE: ./lua/plugins/lsp.lua
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local mason_lspconfig = require("mason-lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local on_attach = function(_, bufnr)
        local map = vim.keymap.set
        local opts = { buffer = bufnr, silent = true }

        map("n", "gd", vim.lsp.buf.definition, opts)
        map("n", "K", vim.lsp.buf.hover, opts)
        map("n", "<leader>rn", vim.lsp.buf.rename, opts)
        map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        map("n", "[d", vim.diagnostic.goto_prev, opts)
        map("n", "]d", vim.diagnostic.goto_next, opts)
      end

      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      mason_lspconfig.setup({
        ensure_installed = {
          "clangd",
          "cmake",
          "lua_ls",
          "pyright",
          "bashls",
        },
        automatic_installation = true,
      })

      mason_lspconfig.setup()

      -- Manually loop over servers and configure each
      local servers = {
        clangd = {},
        cmake = {},
        pyright = {},
        bashls = {},
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },
      }

      for server, config in pairs(servers) do
        config.capabilities = capabilities
        config.on_attach = on_attach
        lspconfig[server].setup(config)
      end
    end,
  },
}


-- <<< END FILE: ./lua/plugins/lsp.lua

-- >>> BEGIN FILE: ./lua/plugins/telescope.lua
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


-- <<< END FILE: ./lua/plugins/telescope.lua

-- >>> BEGIN FILE: ./lua/plugins/terminal.lua
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


-- <<< END FILE: ./lua/plugins/terminal.lua

-- >>> BEGIN FILE: ./lua/plugins/treesitter.lua
-- treesitter.lua: Syntax trees and highlighting

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "c", "cpp", "cmake", "lua", "python", "bash", "vim", "markdown", "markdown_inline", "json",
        },
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            node_decremental = "<BS>",
          },
        },
        autotag = { enable = false },
      })
    end,
  },
}


-- <<< END FILE: ./lua/plugins/treesitter.lua

-- >>> BEGIN FILE: ./lua/plugins/ui.lua
-- ui.lua: Visuals, colorscheme, statusline, bufferline, and UI enhancements

return {

  -- Gruvbox Colorscheme
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      vim.o.background = "dark"
      require("gruvbox").setup({
        contrast = "soft",
        italic = {
          strings = false,
          comments = true,
          folds = true,
        },
        transparent_mode = true,
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
          separator_style = "thick",
          always_show_bufferline = false,
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


-- <<< END FILE: ./lua/plugins/ui.lua


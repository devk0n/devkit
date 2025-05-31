return {
  {
    dir = "~/.config/nvim/lua/cmake-devkit",  -- Full path to your plugin
    -- or if you want to use it as a local plugin:
    -- dev = true,
    config = function()
      require("cmake-devkit").setup()
    end,
    name = "cmake-devkit"  -- Explicit name helps with debugging
  }
}

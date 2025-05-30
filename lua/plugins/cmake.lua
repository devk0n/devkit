return {
  "Civitasv/cmake-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("cmake-tools").setup({
      cmake_command = "cmake",
      cmake_build_directory = "build/${variant:buildType}",
      cmake_build_type = "RelWithDebInfo",
      cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
      cmake_build_options = {},
      cmake_executor = {
        name = "quickfix",
        opts = {},
      },
    })

    -- Optional keybindings
    local map = vim.keymap.set
    map("n", "<leader>cg", "<cmd>CMakeGenerate<CR>", { desc = "CMake Generate" })
    map("n", "<leader>cb", "<cmd>CMakeBuild<CR>", { desc = "CMake Build" })
    map("n", "<leader>cr", "<cmd>CMakeRun<CR>", { desc = "CMake Run" })
    map("n", "<leader>cc", "<cmd>CMakeClean<CR>", { desc = "CMake Clean" })
    map("n", "<leader>ct", "<cmd>CMakeSelectBuildTarget<CR>", { desc = "CMake Select Target" })
    map("n", "<leader>cd", "<cmd>CMakeDebug<CR>", { desc = "CMake Debug" })
  end,
}


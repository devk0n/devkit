local M = {}

-- Configuration
M.config = {
    build_dir = "build",
    term_height = 15
}

-- Get project name from directory
local function get_project_name()
    return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
end

-- Run command in terminal (no extra output)
local function run_cmake(cmd)
    local buf = vim.fn.bufnr()
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_option(b, "buftype") == "terminal" then
            buf = b
            break
        end
    end
    
    if buf == vim.fn.bufnr() then
        vim.cmd("botright "..M.config.term_height.."split | terminal")
        buf = vim.api.nvim_get_current_buf()
    end
    
    local chan = vim.api.nvim_get_option_value("channel", {buf = buf})
    vim.api.nvim_chan_send(chan, cmd.."\r")
    vim.cmd("wincmd p")
end

-- CMake generate (with automatic compile_commands.json copy)
function M.generate()
    run_cmake("cmake -B "..M.config.build_dir.." -DCMAKE_EXPORT_COMPILE_COMMANDS=1 && "..
              "cp "..M.config.build_dir.."/compile_commands.json .")
end

-- CMake build
function M.build()
    run_cmake("cmake --build "..M.config.build_dir)
end

-- Run executable
function M.run()
    run_cmake(M.config.build_dir.."/"..get_project_name())
end

-- Setup commands
function M.setup()
    vim.api.nvim_create_user_command("CMakeGenerate", M.generate, {desc = "Generate CMake project"})
    vim.api.nvim_create_user_command("CMakeBuild", M.build, {desc = "Build project"})
    vim.api.nvim_create_user_command("CMakeRun", M.run, {desc = "Run executable"})
end

return M

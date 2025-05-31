local M = {}

-- Default configuration
M.default_config = {
    build_dir = "build",
    build_type = "Debug",
    executable_path = nil, -- auto-detect
    auto_copy_compile_commands = true,
}

-- Find CMake project root
function M.find_project_root()
    local current_file = vim.api.nvim_buf_get_name(0)
    if current_file == "" then current_file = vim.fn.getcwd() end
    
    local dir = vim.fn.fnamemodify(current_file, ":p:h")
    while dir ~= "/" do
        -- Check for common project markers
        if vim.fn.filereadable(dir .. "/CMakeLists.txt") == 1 or
           vim.fn.isdirectory(dir .. "/.git") == 1 then
            return dir
        end
        dir = vim.fn.fnamemodify(dir, ":h")
    end
    return vim.fn.getcwd()
end

-- Find executable in build directory
function M.find_executable(build_dir)
    if vim.fn.executable("fd") == 1 then
        local result = vim.fn.systemlist("fd -t executable . " .. build_dir)
        if #result > 0 then
            return result[1]
        end
    end
    
    -- Fallback to common executable locations
    local candidates = {
        build_dir .. "/app",
        build_dir .. "/main",
        build_dir .. "/" .. vim.fn.fnamemodify(M.find_project_root(), ":t")
    }
    
    for _, path in ipairs(candidates) do
        if vim.fn.executable(path) == 1 then
            return path
        end
    end
    
    return nil
end

-- Load project-specific config
function M.load_config()
    local project_root = M.find_project_root()
    local config_path = project_root .. "/.nvim_cmake.json"
    
    local config = vim.tbl_deep_extend("force", 
        M.default_config,
        vim.g.smart_cmake_config or {}
    )
    
    if vim.fn.filereadable(config_path) == 1 then
        local file = io.open(config_path, "r")
        if file then
            local content = file:read("*a")
            file:close()
            local ok, project_config = pcall(vim.json.decode, content)
            if ok then
                config = vim.tbl_deep_extend("force", config, project_config)
            end
        end
    end
    
    -- Auto-detect executable if not specified
    if not config.executable_path then
        config.executable_path = M.find_executable(config.build_dir)
    end
    
    config.project_root = project_root
    return config
end

return M

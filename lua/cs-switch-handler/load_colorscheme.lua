

M = {}

---@param src string
---@return boolean
local function source_saved_colorscheme_require(src)
  return pcall(function()
    require(src)
  end)
end

---@param src string
---@return boolean
local function source_saved_colorscheme_vim(src)
  -- source vim file
  return pcall(function()
    vim.cmd("source "..src)
  end)
end

---@param default table
---@param file_path string|function
---@param use_req boolean
M.load_colorscheme = function(default, file_path, use_req)

  default = default or {}

  if file_path ~= nil then
    if type(file_path) == "function" then
      file_path = file_path()
    end
    -- if file_path == "default" then
    --   file_path = U.default_file_path
    -- end
    if use_req then
      if source_saved_colorscheme_require(file_path) then
         return
      end
    elseif source_saved_colorscheme_vim(file_path) then
      return
    else
      print [[ 

          CS-Switch-Handler: Cannot source file path

        ]]
    end
  end

  if default.name ~= nil then
    local U = require("cs-switch-handler.utils")
    vim.cmd("colorscheme "..default.name)
    U.apply_opts(default)
  end
end

return M


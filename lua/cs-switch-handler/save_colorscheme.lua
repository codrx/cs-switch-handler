
local VC = require("cs-switch-handler.vim_commands")

local M = {}


---@param xs string: (xs:x) from haskell.. couldn't think of anything better
---@param x string 
local function append_to_contents(xs, x)
  return xs.."\n"..x
end

---@param bg_type string: "dark" or "light"
---@param file_contents string
local function add_bg_type_to_file(bg_type, file_contents)
  local chosen = VC.background_defaults[bg_type]
  if chosen ~= nil then
    file_contents = append_to_contents(file_contents, chosen)
  else
    local dark = VC.background_defaults["dark"]
    file_contents = append_to_contents(file_contents, dark)
  end
  return file_contents
end

---@param transparent boolean: will change in future to be more customizable
---@param file_contents string
local function add_transparent_opts_to_file(transparent, file_contents)
  if transparent then
    for _, v in ipairs(VC.transparency_defaults) do
      file_contents = append_to_contents(file_contents, v.command)
    end
  end
  return file_contents
end

---@param extra_commands string[]
---@param file_contents string
local function add_extra_commands_to_file(extra_commands, file_contents)
  if extra_commands and type(extra_commands) == "table" then
    for _, v in ipairs(extra_commands) do
      file_contents = append_to_contents(file_contents, v)
    end
  end
  return file_contents
end

---@param individual table
---@param colorscheme string
M.is_colorscheme_in_individual = function(individual, colorscheme)
  for _, v in ipairs(individual) do
    if (v.name == colorscheme) then
      return true
    end
  end
  return false
end


---@param opts table
---@return string
M.colorscheme_opts_to_file = function(opts)
  local colorscheme = vim.g.colors_name

  local file_contents = "colorscheme ".. colorscheme

  local table
  if M.is_colorscheme_in_individual(opts, colorscheme) then
    table = opts.individual
  else
    table = opts.all
  end

  file_contents = add_bg_type_to_file(table.bg_type, file_contents)
  file_contents = add_transparent_opts_to_file(table.transparent, file_contents)
  file_contents = add_extra_commands_to_file(table.extra_commands, file_contents)

  return file_contents
end


---@param opts table
---@param file_path string|function
M.save_colorscheme = function(opts, file_path)
  if (file_path ~= nil) then

    local cs_file
    if type(file_path) == "string" then
      -- if file_path == "default" then
      --   file_path = U.default_file_path
      -- end

      cs_file = assert(io.open(file_path, "w+"))
    end
    if type(file_path) == "function" then
      cs_file = assert(io.open(file_path(), "w+"))
    end

    local file_contents = M.colorscheme_opts_to_file(opts)
    cs_file:write(file_contents)
    cs_file:close()

  else
    print("Please supply a save file path in setup")
  end
end


return M


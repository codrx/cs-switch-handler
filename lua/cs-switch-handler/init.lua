
local U = require("cs-switch-handler.utils")
local L = require("cs-switch-handler.load_colorscheme")
local S = require("cs-switch-handler.save_colorscheme")
local C = require("cs-switch-handler.callback")

local M = {}

--[[

  !TODOS

  -- Need to make setting main_save_file_path more dynamic

  -- Need to make command to set different options off e.g. CS-Switch nordic -transparent=OFF

  -- Need to make a visual of higlight groups for editor and what changing the colors affect

  -- Need to deal with transparency options better

  -- NEED TO OPTIMIZE

--]]

local defaults = {

  callback = "all",
  main_function = nil,

  all = {
    transparent = false,

    -- Deal with this later
    -- transparency_options = {},

    bg_type = "dark",
    extra_commands = {},
    extra_func = nil
  },

  individual = {},

  main_save_file_path = nil,
  save_function = nil
}

M.main_function = function(opts)

  opts = opts or {}

  if (opts.individual ~= nil) and (next(opts.individual) ~= nil)  then
    local current_colorscheme = U.get_current_colorscheme()
    for _, e in ipairs(opts.individual) do
      if current_colorscheme == e.name then
        U.apply_opts(e)
        return
     end
    end
  end

  if (opts.all ~= nil) and (next(opts.all) ~= nil) then
    U.apply_opts(opts.all)
  end
end

---@type table
M.options = defaults

---@type function
M.options.main_function = M.main_function

---@type function
M.options.save_function = S.save_colorscheme

---@type function
M.load_colorscheme = L.load_colorscheme

M.setup = function(opts)

  M.options = vim.tbl_deep_extend("force", M.options or defaults, opts or {})
  C.handle_callback(M.options)

  -- Save current colorscheme command
  -- Temporary: will improve in the future
  vim.api.nvim_create_user_command(
    "CSswitch",
    function(_)
      local o = require("cs-switch-handler").options
      o.save_function(o, o.main_save_file_path)
    end,
    {
      desc="Permanently save current theme",
      nargs = 1,
      complete = function(_, _, _)
        return { "save_cs" }
      end
    }
  )
end

return M


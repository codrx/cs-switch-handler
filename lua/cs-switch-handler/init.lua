
local U = require("cs-switch-handler.utils")
local C = require("cs-switch-handler.callback")
local L = require("cs-switch-handler.load_colorscheme")

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
  main_function = nil, --

  all = {
    transparent = false,

    -- Deal with this later
    -- transparency_options = {},

    bg_type = "dark",
    extra_commands = {},
    extra_func = nil
  },

  individual = {},

  save = true,
  main_save_file_path = nil,
  -- save_function = nil
}

---@type table
M.options = defaults

---@param opts table
M.options.main_function = function(opts)

  opts = opts or {}

  if (opts.individual ~= nil) and (next(opts.individual) ~= nil)  then
    local current_colorscheme = vim.g.colors_name
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

-----@type function
--M.options.save_function = S.save_colorscheme

---@type function
M.load_colorscheme = L.load_colorscheme


M.setup = function(opts)

  M.options = vim.tbl_deep_extend("force", M.options or defaults, opts or {})
  C.handle_callback(M.options)

  -- Save current colorscheme command
  --
  -- Maybe lazy load save? IDK if possible

  if M.options.save then
    vim.api.nvim_create_user_command(
      "CSswitch",
      function(_)
        local S = require("cs-switch-handler.save_colorscheme")
        local O = require("cs-switch-handler").options
        S.save_function(O, O.main_save_file_path)
      end,
      {
        desc="Permanently save current theme",
        nargs = 1,
        complete = function(_, _, _)
          return { "save_colorscheme" }
        end
      }
    )
  end
end

return M


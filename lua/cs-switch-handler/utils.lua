
local VC = require("cs-switch-handler.vim_commands")

local M = {}

-- %% Fallback
--
-- local function set_bg_type(bg_type)
--   if bg_type == "light" then
--     vim.cmd(" set background=light ")
--   else
--     vim.cmd(" set background=dark ")
--   end
-- end
--
-- local function set_transparent_bg(transparent)
--   if transparent then
--     vim.cmd [[
--       hi Normal guibg=NONE ctermbg=NONE
--       hi NormalNC guibg=NONE guifg=NONE   
--       hi NormalFloat guibg=NONE guifg=NONE 
--  	 hi SignColumn guibg=NONE
--     ]]
--   end
-- end

---@param bg_type string: "light" or "dark"
local function set_bg_type(bg_type)
  local chosen_type = VC.background_defaults[bg_type]
  if chosen_type ~= nil then
    vim.cmd(chosen_type)
  else
    local dark = VC.background_defaults["dark"]
    vim.cmd(dark)
  end
end

---@param transparent boolean
local function set_transparent_bg(transparent)
 if transparent then
   for _, v in pairs(VC.transparency_defaults) do
     vim.cmd(v.command)
   end
 end
end


---@param extra_commands string[]
local function apply_extra_commands(extra_commands)
  extra_commands = extra_commands or {}
  for _, v in ipairs(extra_commands) do
    vim.cmd(v)
  end
end


M.apply_opts = function(opts)
  opts = opts or {}

  -- Does the if statements make a difference?
  if opts.bg_type ~= nil then
    set_bg_type(opts.bg_type)
  end
  if opts.transparent ~= nil then
    set_transparent_bg(opts.transparent)
  end
  if opts.extra_commands ~= nil then
    apply_extra_commands(opts.extra_commands)
  end

  if type(opts.extra_func) == "function" then
    opts.extra_func()
  end
end

-- ---@type string
-- M.default_file_path = vim.fn.expand("%:p:h:").."/../cs/colorscheme.vim"

return M


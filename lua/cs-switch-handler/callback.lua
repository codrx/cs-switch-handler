local M = {}

-- To run callback for any change in colorscheme
---@param main_func function
---@param opts table
M.standard_nvim_callback = function(main_func, opts)
  vim.api.nvim_create_autocmd("Colorscheme", {
    once = false,
    callback = function()
      main_func(opts)
    end,
  })
end

-- To run callback for only FZF Lua (:colorscheme ___ won't apply opts)
-- Applies opts after FZF-Lua close
-- Relys on post_reset_cb function
-- More info:
-- https://github.com/ibhagwan/fzf-lua/blob/main/lua/fzf-lua/providers/colorschemes.lua
---@param main_func function
---@param opts table
M.fzf_lua_callback = function(main_func, opts)
  require("fzf-lua").setup({
    colorschemes = {
      post_reset_cb = function()
        main_func(opts)
      end
    }
  })
end

-- To run callback for only Telescope
---@param main_func function
---@param opts table
M.telescope_callback = function(main_func, opts)

  -- I don't use Telescope btw
  -- I can't figure out a simple way to do this

  -- !todo
  print("!todo")

  -- vim.api.nvim_create_autocmd("User", {
  --   pattern = "TelescopeFindPre",
  --   once = false,
  --   callback = function()
  --     vim.api.nvim_create_autocmd("Colorscheme", {
  --       once = false,
  --       callback = function()
  --           main_func(opts)
  --       end,
  --     })
  --   end,
  -- })

end

M.handle_callback = function(opts)
  if opts.callback ~= nil then

    -- Fastest -- takes ~1ms
    if opts.callback == "all" then
      M.standard_nvim_callback(opts.main_function, opts)
    end

    -- Takes around ~10ms -- Improve
    if opts.callback == "fzf-lua" then
      M.fzf_lua_callback(opts.main_function, opts)
    end
    if opts.callback == "telescope" then
      M.telescope_callback(opts.main_function, opts)
    end
  end
end

return M


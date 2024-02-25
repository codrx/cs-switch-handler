
local M = {}

M.transparency_defaults = {
  {
    hi_group = "Normal",
    command = "hi Normal guibg=NONE ctermbg=NONE"
  },
  {
    hi_group = "NormalFC",
    command = "hi NormalNC guibg=NONE guifg=NONE",
  },
  {
    hi_group = "NormalFloat",
    command = "hi NormalFloat guibg=NONE guifg=NONE"
  },
  {
    hi_group = "EndOfBuffer",
    command = "hi EndOfBuffer guibg=NONE"
  },
  {
    hi_group = "SignColumn",
    command = "hi SignColumn guibg=NONE"
  }
}

M.background_defaults = {
  light = "set background=light",
  dark = "set background=dark"
}

return M


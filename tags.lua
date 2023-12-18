local awful = require("awful")
local sharedtags = require("sharedtags")

local M = {}
M.tags = sharedtags({
  { layout = awful.layout.layouts[2], screen = 1 },
  { layout = awful.layout.layouts[2], screen = 2 },
  { layout = awful.layout.layouts[2], screen = 1 },
  { layout = awful.layout.layouts[2], screen = 1 },
  { layout = awful.layout.layouts[2], screen = 1 },
  { layout = awful.layout.layouts[2], screen = 1 },
  { layout = awful.layout.layouts[2], screen = 1 },
  { layout = awful.layout.layouts[2], screen = 1 },
  { layout = awful.layout.layouts[2], screen = 3 },
})

return M

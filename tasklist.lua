local gears = require("gears")
local awful = require("awful")
local c = require("colors")
local m = {}
function m.create(screen)
  return awful.widget.tasklist({
    screen = screen,
    filter = awful.widget.tasklist.filter.currenttags,
    style = {
      fg_normal = c.base03,
      bg_normal = c.base01,
      fg_focus = c.base06,
      bg_focus = c.none,
      fg_urgent = c.base02,
      bg_urgent = c.base08,
      fg_minimize = c.base01,
      bg_minimize = c.base01,
      spacing = 1,
      tasklist_disable_icon = true,
      shape = gears.shape.rounded_rect,
    },
  })
end

return m

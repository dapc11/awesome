local gears = require("gears")
local awful = require("awful")
local m = {}
function m.create(screen)
  return awful.widget.tasklist({
    screen = screen,
    filter = awful.widget.tasklist.filter.currenttags,
    style = {
      fg_normal = "#586069",
      bg_normal = "#2d333b",
      fg_focus = "#c9d1d9",
      bg_focus = "#2d333b",
      fg_urgent = "#484f58",
      bg_urgent = "#ff7b72",
      fg_minimize = "#2d333b",
      bg_minimize = "#2d333b",
      spacing = 1,
      tasklist_disable_icon = true,
      shape = gears.shape.rounded_rect,
    },
  })
end

return m

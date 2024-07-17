pcall(require, "luarocks.loader")

local gears = require("gears")
local gfs = require("gears.filesystem")
local awful = require("awful")
local naughty = require("naughty")
local beautiful = require("beautiful")
local bling = require("bling")
local revelation = require("revelation")
local colors = require("colors")

beautiful.init(gfs.get_configuration_dir() .. "theme/theme.lua")

require("awful.autofocus")
require("titlebar")
require("keymaps")
require("bar")

local theme = require("theme.theme")

revelation.init()
bling.widget.window_switcher.enable({
  type = "thumbnail", -- set to anything other than "thumbnail" to disable client previews

  -- keybindings (the examples provided are also the default if kept unset)
  hide_window_switcher_key = "Escape", -- The key on which to close the popup
  minimize_key = "n", -- The key on which to minimize the selected client
  unminimize_key = "N", -- The key on which to unminimize all clients
  kill_client_key = "q", -- The key on which to close the selected client
  cycle_key = "Tab", -- The key on which to cycle through all clients
  previous_key = "Left", -- The key on which to select the previous client
  next_key = "Right", -- The key on which to select the next client
  vim_previous_key = "h", -- Alternative key on which to select the previous client
  vim_next_key = "l", -- Alternative key on which to select the next client

  cycleClientsByIdx = awful.client.focus.byidx, -- The function to cycle the clients
  filterClients = awful.widget.taglist.filter.all, -- The function to filter the viewed clients
})

if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Error occured",
    text = awesome.startup_errors,
  })
end

local theme_path = string.format("%s/.config/awesome/theme/theme.lua", os.getenv("HOME"), "default")
beautiful.init(theme_path)

modkey = "Mod4"
awful.spawn.with_shell("dunst")
awful.spawn.with_shell("nm-applet")
awful.spawn.with_shell("gnome-screensaver")

awful.screen.connect_for_each_screen(function(s)
  bling.module.tiled_wallpaper("O", s, {
    fg = colors.base05,
    bg = colors.base00,
    offset_y = 20,
    offset_x = 20,
    font = theme.font,
    font_size = 20,
    padding = 100,
    zickzack = true,
  })
end)

awful.layout.layouts = {
  awful.layout.suit.tile,
  bling.layout.mstab,
  bling.layout.equalarea,
  bling.layout.centered,
  awful.layout.suit.max,
  awful.layout.suit.floating,
  awful.layout.suit.tile.bottom,
}

local clientbuttons = gears.table.join(
  awful.button({}, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
  end),
  awful.button({ modkey }, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.move(c)
  end),
  awful.button({ modkey }, 3, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.resize(c)
  end)
)

root.keys(globalkeys)

awful.rules.rules = {
  {
    rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen,
    },
    callback = function(c)
      c.maximized, c.maximized_vertical, c.maximized_horizontal = false, false, false
    end,
  },

  -- Floating clients.
  -- { rule_any = {}, properties = { floating = true } },
  {
    rule_any = { type = { "normal", "dialog" } },
    properties = { titlebars_enabled = false },
  },
}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
  c.shape = function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, theme.border_radius)
  end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c)
  c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
  c.border_color = beautiful.border_normal
end)
-- }}}

-- Autorun programs in Awesome WM
autorun = true
autorunApps = {
  "xfce4-power-manager",
}
if autorun then
  for app = 1, #autorunApps do
    awful.util.spawn(autorunApps[app])
  end
end

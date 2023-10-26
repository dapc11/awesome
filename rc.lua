-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local revelation = require("revelation")
local colors = require("colors")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

--  Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors,
  })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function(err)
    -- Make sure we don't go into an endless error loop
    if in_error then
      return
    end
    in_error = true

    naughty.notify({
      preset = naughty.config.presets.normal,
      title = "Oops, an error happened!",
      text = tostring(err),
    })
    in_error = false
  end)
end
-- Widgets
local battery = require("widgets.battery-widget.battery")
local volume = require("widgets.volume-widget.volume")
local logout_menu = require("widgets.logout-menu-widget.logout-menu")

--  Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- local file = io.open("/home/dapc/awesome.log", "w")
-- file:write(gears.filesystem.get_themes_dir() .. "default/theme.lua")
-- file:close()
local theme_path = os.getenv("HOME") .. "/.config/awesome/theme.lua"
if not beautiful.init(theme_path) then
  error("Unable to load " .. theme_path)
end
revelation.init()
local theme = require("theme")
local bling = require("bling")

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
beautiful.font = theme.font
awful.layout.layouts = {
  awful.layout.suit.tile,
  bling.layout.mstab,
  bling.layout.equalarea,
  bling.layout.centered,
  awful.layout.suit.max,
  awful.layout.suit.floating,
  awful.layout.suit.tile.bottom,
}

-- Menubar configuration
menubar.utils.terminal = theme.terminal -- Set the terminal for applications that require it

--  Wibar
-- Create a textclock widget
local mytextclock = wibox.widget.textclock("   %Y-%m-%d  %H:%M:%S", 1)

local function set_wallpaper(s)
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

local separator = wibox.widget({
  font = theme.font,
  text = "|",
  opacity = 0.3,
  forced_width = 20,
  valign = "center",
  align = "center",
  widget = wibox.widget.textbox,
})

awful.screen.connect_for_each_screen(function(screen)
  set_wallpaper(screen)

  -- Each screen has its own tag table.
  awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, screen, awful.layout.layouts[1])
  screen.mypromptbox = awful.widget.prompt()
  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  screen.mylayoutbox = awful.widget.layoutbox(screen)
  screen.mylayoutbox:buttons(gears.table.join(awful.button({}, 1, function()
    awful.layout.inc(1)
  end)))

  screen.mytaglist = require("taglist").create(screen)
  screen.mytasklist = require("tasklist").create(screen)

  screen.mywibox = awful.wibar({
    position = "top",
    screen = screen,
  })

  -- Add widgets to the wibox
  screen.mywibox:setup({
    layout = wibox.layout.align.horizontal,
    expand = "none",
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      spacing = 20,
      { layout = wibox.layout.fixed.horizontal },
      { layout = wibox.layout.fixed.horizontal, spacing = 5, screen.mytaglist, screen.mylayoutbox },
      screen.mypromptbox,
    },
    {
      mytextclock,
      layout = wibox.layout.flex.horizontal,
    },
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      volume({
        font = theme.font,
        unselected = colors.base03,
        selected = colors.base08,
      }),
      separator,
      battery({
        font = theme.font,
        show_current_level = true,
      }),
      separator,
      wibox.widget.systray(),
      logout_menu(),
    },
  })
end)

root.buttons(gears.table.join(awful.button({}, 4, awful.tag.viewnext), awful.button({}, 5, awful.tag.viewprev)))

local clientbuttons = gears.table.join(awful.button({ theme.modkey }, 3, function(c)
  c:emit_signal("request::activate", "mouse_click", {
    raise = true,
  })
  awful.mouse.client.resize(c)
end))

local keybinds = require("keybinds")
root.keys(keybinds.globalkeys)

--  Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = { -- All clients will match this rule.
  {
    rule = {},
    properties = {
      border_width = theme.border_width,
      border_color = theme.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = keybinds.clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen,
    },
  }, -- Floating clients.
  {
    rule_any = {
      name = {
        "GlobalProtect",
      },
      class = {
        "PanGPUI",
      },
    },
    properties = {
      floating = true,
      placement = awful.placement.top_right,
    },
  },
  {
    rule_any = {
      instance = {
        "DTA", -- Firefox addon DownThemAll.
        "copyq", -- Includes session name in class.
        "pinentry",
      },
      class = {
        "Arandr",
        "Blueman-manager",
        "Gpick",
        "Kruler",
        "MessageWin", -- kalarm.
        "Sxiv",
        "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
        "Wpa_gui",
        "veromix",
        "xtightvncviewer",
        "rofi",
        "Rofi",
      },
      -- Note that the name property shown in xprop might be set slightly after creation of the client
      -- and the name shown there might not match defined rules here.
      name = {
        "Event Tester", -- xev.
      },
      role = {
        "AlarmWindow", -- Thunderbird's calendar.
        "ConfigManager", -- Thunderbird's about:config.
        "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
      },
    },
    properties = {
      floating = true,
    },
  }, -- Add titlebars to normal clients and dialogs
  {
    rule_any = {
      type = { "normal", "dialog" },
    },
    properties = {
      titlebars_enabled = theme.titlebars_enabled,
    },
  },
}

--  Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  -- if not awesome.startup then awful.client.setslave(c) end

  if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end)

-- No border for maximized clients
local function border_adjust(c)
  if c.maximized then -- no borders if only 1 client visible
    c.border_width = 0
    c.shape = gears.shape.rectangle
  elseif #awful.screen.focused().clients > 1 then
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_focus
    c.shape = gears.shape.rounded_rect
  end
end

client.connect_signal("focus", border_adjust)
client.connect_signal("property::maximized", border_adjust)
client.connect_signal("unfocus", function(c)
  c.border_color = beautiful.border_normal
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
  -- buttons for the titlebar
  local buttons = gears.table.join()

  awful.titlebar(c):setup({
    { -- Left
      awful.titlebar.widget.iconwidget(c),
      buttons = buttons,
      layout = wibox.layout.fixed.horizontal,
    },
    { -- Middle
      { -- Title
        align = "center",
        widget = awful.titlebar.widget.titlewidget(c),
      },
      buttons = buttons,
      layout = wibox.layout.flex.horizontal,
    },
    { -- Right
      awful.titlebar.widget.floatingbutton(c),
      awful.titlebar.widget.maximizedbutton(c),
      awful.titlebar.widget.stickybutton(c),
      awful.titlebar.widget.ontopbutton(c),
      awful.titlebar.widget.closebutton(c),
      layout = wibox.layout.fixed.horizontal(),
    },
    layout = wibox.layout.align.horizontal,
  })
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", {
    raise = false,
  })
end)

client.connect_signal("focus", function(c)
  c.border_color = beautiful.border_focus
  c.skip_taskbar = false
end)
client.connect_signal("unfocus", function(c)
  c.border_color = beautiful.border_normal
  c.skip_taskbar = true
end)

awful.spawn.with_shell("dunst")
awful.spawn.with_shell("nm-applet")
awful.spawn.with_shell("picom")
awful.spawn.with_shell("gnome-screensaver")

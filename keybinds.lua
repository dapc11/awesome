local gears = require("gears")
local awful = require("awful")
local theme = require("theme")
local xrandr = require("xrandr")
local revelation = require("revelation")
local cyclefocus = require("cycle")
local hotkeys_popup = require("awful.hotkeys_popup")

local keybinds = {}
keybinds.globalkeys = gears.table.join(
  awful.key({ theme.modkey }, "Down", function()
    awful.client.focus.byidx(1)
  end, {
    description = "focus next by index",
    group = "client",
  }),
  awful.key({ theme.modkey }, "Up", function()
    awful.client.focus.byidx(-1)
  end, {
    description = "focus previous by index",
    group = "client",
  }),
  awful.key({ theme.modkey }, "w", function()
    awful.spawn("firefox")
  end, {
    description = "launch browser",
    group = "launcher",
  }), -- Layout manipulation
  awful.key({ theme.modkey, "Shift" }, "Down", function()
    awful.client.swap.byidx(1)
  end, {
    description = "swap with next client by index",
    group = "client",
  }),
  awful.key({ theme.modkey, "Shift" }, "Up", function()
    awful.client.swap.byidx(-1)
  end, {
    description = "swap with previous client by index",
    group = "client",
  }),
  awful.key({ theme.modkey, "Control" }, "Down", function()
    awful.screen.focus_relative(1)
  end, {
    description = "focus the next screen",
    group = "screen",
  }),
  awful.key({ theme.modkey, "Control" }, "Up", function()
    awful.screen.focus_relative(-1)
  end, {
    description = "focus the previous screen",
    group = "screen",
  }),
  awful.key({ theme.modkey }, "u", awful.client.urgent.jumpto, {
    description = "jump to urgent client",
    group = "client",
  }), -- Standard program
  awful.key({ theme.modkey }, "Return", function()
    awful.spawn(theme.terminal)
  end, {
    description = "open a terminal",
    group = "launcher",
  }),
  awful.key({ theme.modkey, "Control" }, "r", awesome.restart, {
    description = "reload awesome",
    group = "awesome",
  }),
  awful.key({ theme.modkey }, "s", function()
    awful.spawn("rofi -normal-window -show window -theme ~/.config/rofi/config")
  end, {
    description = "switch window",
    group = "launcher",
  }),
  awful.key({ theme.modkey }, "d", function()
    awful.spawn("rofi -normal-window -show drun -display-drun '' -modi drun -theme ~/.config/rofi/config")
  end, {
    description = "launch application",
    group = "launcher",
  }),
  awful.key({ theme.modkey }, "BackSpace", function()
    awful.spawn("/home/dapc/.config/awesome/sysact")
  end, {
    description = "session management",
    group = "launcher",
  }),
  awful.key({ theme.modkey, "Shift" }, "q", awesome.quit, {
    description = "quit awesome",
    group = "awesome",
  }),
  awful.key({ theme.modkey }, "l", function()
    awful.tag.incmwfact(0.05)
  end, {
    description = "increase master width factor",
    group = "layout",
  }),
  awful.key({ theme.modkey }, "h", function()
    awful.tag.incmwfact(-0.05)
  end, {
    description = "decrease master width factor",
    group = "layout",
  }),
  awful.key({ theme.modkey, "Shift" }, "h", function()
    awful.tag.incnmaster(1, nil, true)
  end, {
    description = "increase the number of master clients",
    group = "layout",
  }),
  awful.key({ theme.modkey, "Shift" }, "l", function()
    awful.tag.incnmaster(-1, nil, true)
  end, {
    description = "decrease the number of master clients",
    group = "layout",
  }),
  awful.key({ theme.modkey, "Control" }, "h", function()
    awful.tag.incncol(1, nil, true)
  end, {
    description = "increase the number of columns",
    group = "layout",
  }),
  awful.key({ theme.modkey, "Control" }, "l", function()
    awful.tag.incncol(-1, nil, true)
  end, {
    description = "decrease the number of columns",
    group = "layout",
  }),
  awful.key({ theme.modkey }, "<", function()
    awful.screen.focus_relative(1)
  end, {
    description = "focus the next screen",
    group = "screen",
  }),
  awful.key({ theme.modkey }, "space", function()
    awful.layout.inc(1)
  end, {
    description = "select next",
    group = "layout",
  }),
  awful.key({ theme.modkey, "Shift" }, "space", function()
    awful.layout.inc(-1)
  end, {
    description = "select previous",
    group = "layout",
  }),
  awful.key({ theme.modkey }, "p", function()
    xrandr.xrandr()
  end),
  awful.key({ theme.modkey, "Control" }, "n", function()
    local c = awful.client.restore()
    if c then
      c:emit_signal("request::activate", "key.unminimize", {
        raise = true,
      })
    end
  end, {
    description = "restore minimized",
    group = "client",
  }),
  awful.key({ theme.modkey }, "r", function()
    awful.screen.focused().mypromptbox:run()
  end),
  awful.key({ theme.modkey }, "i", hotkeys_popup.show_help, { description = "show help", group = "awesome" })
)

keybinds.clientkeys = gears.table.join(
  awful.key({ theme.modkey }, "f", function(c)
    c.fullscreen = not c.fullscreen
    c:raise()
  end, {
    description = "toggle fullscreen",
    group = "client",
  }),
  awful.key({ theme.modkey }, "q", function(c)
    c:kill()
  end, {
    description = "close",
    group = "client",
  }),
  awful.key({ theme.modkey, "Control" }, "space", awful.client.floating.toggle, {
    description = "toggle floating",
    group = "client",
  }),
  awful.key({ theme.modkey }, "m", function(c)
    c:swap(awful.client.getmaster())
  end, {
    description = "move to master",
    group = "client",
  }),
  awful.key({ theme.modkey }, "o", function(c)
    c:move_to_screen()
  end, {
    description = "move to screen",
    group = "client",
  }),
  awful.key({ theme.modkey }, "t", function(c)
    c.ontop = not c.ontop
  end, {
    description = "toggle keep on top",
    group = "client",
  }),
  awful.key({ theme.modkey, "Control" }, "<", function(c)
    c:move_to_screen()
  end, {
    description = "move to screen",
    group = "client",
  }),
  -- modkey+Tab: cycle through all clients.
  awful.key({ theme.modkey }, "Tab", function(_)
    cyclefocus.cycle({ modifier = "Super_L" })
  end),
  -- modkey+Shift+Tab: backwards
  awful.key({ theme.modkey, "Shift" }, "Tab", function(_)
    cyclefocus.cycle({ modifier = "Super_L" })
  end),
  awful.key({ theme.modkey }, "Escape", awful.tag.history.restore),
  awful.key({ theme.modkey }, "e", revelation)
)
-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  keybinds.globalkeys = gears.table.join(
    keybinds.globalkeys, -- View tag only.
    awful.key({ theme.modkey }, "#" .. i + 9, function()
      local screen = awful.screen.focused()
      local tag = screen.tags[i]
      if tag then
        tag:view_only()
      end
    end, {
      description = "view tag #" .. i,
      group = "tag",
    }), -- Toggle tag display.
    awful.key({ theme.modkey, "Control" }, "#" .. i + 9, function()
      local screen = awful.screen.focused()
      local tag = screen.tags[i]
      if tag then
        awful.tag.viewtoggle(tag)
      end
    end, {
      description = "toggle tag #" .. i,
      group = "tag",
    }), -- Move client to tag.
    awful.key({ theme.modkey, "Shift" }, "#" .. i + 9, function()
      if client.focus then
        local tag = client.focus.screen.tags[i]
        if tag then
          client.focus:move_to_tag(tag)
        end
      end
    end, {
      description = "move focused client to tag #" .. i,
      group = "tag",
    }), -- Toggle tag on focused client.
    awful.key({ theme.modkey, "Control", "Shift" }, "#" .. i + 9, function()
      if client.focus then
        local tag = client.focus.screen.tags[i]
        if tag then
          client.focus:toggle_tag(tag)
        end
      end
    end, {
      description = "toggle focused client on tag #" .. i,
      group = "tag",
    })
  )
end

return keybinds

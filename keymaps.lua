local gears = require("gears")
local spawn = require("awful.spawn")
local awful = require("awful")
local xrandr = require("xrandr")
local revelation = require("revelation")
local hotkeys_popup = require("awful.hotkeys_popup")
local bling = require("bling")
local cyclefocus = require("cycle")
local colors = require("colors")
local sharedtags = require("sharedtags")

local xresources = require("beautiful").xresources
local dpi = xresources.apply_dpi
local app_launcher_args = {
  app_content_padding = dpi(0),
  app_content_spacing = dpi(0),
  app_name_font = "JetBrainsMono 10",
  app_name_selected_color = colors.base07,
  app_normal_color = colors.base01,
  app_normal_hover_color = colors.base01,
  app_selected_color = colors.base02,
  app_show_name = true,
  app_width = 200,
  apps_margin = dpi(0),
  apps_per_column = 4,
  apps_per_row = 3,
  apps_spacing = dpi(0),
  background = colors.base01,
  favorites = { "kitty"},
  prompt_color = colors.base02,
  prompt_cursor_color = colors.base04,
  prompt_font = "JetBrainsMono 10",
  prompt_height = dpi(40),
  prompt_icon = "",
  prompt_icon_color = colors.base07,
  prompt_icon_font = "JetBrainsMono 10",
  prompt_icon_markup = string.format("<span size='x-large' foreground='%s'>%s</span>", colors.base07, " "),
  prompt_margins = dpi(0),
  prompt_paddings = dpi(0),
  prompt_text = "",
  prompt_text_color = colors.base07,
  border_color = colors.base02,
  terminal = "kitty",
  app_show_generic_name = false
}
local app_launcher = bling.widget.app_launcher(app_launcher_args)
local term_scratch = bling.module.scratchpad({
  command = "kitty --class spad",
  rule = { instance = "spad" },
  sticky = true,
  autoclose = false,
  floating = true,
  geometry = { x = 0, y = 0, height = 900, width = 1200 },
  reapply = true,
  dont_focus_before_close = true,
})
local spotify_scratch = bling.module.scratchpad({
  command = "spotify",
  rule = { instance = "spotify" },
  sticky = true,
  autoclose = false,
  floating = true,
  geometry = { x = 360, y = 90, height = 900, width = 1200 },
  reapply = true,
  dont_focus_before_close = true,
})

local tags = require("tags")

local function run_cmd(cmd)
  spawn.with_shell("sleep 0.5 && " .. cmd)
end

modkey = "Mod4"
globalkeys = gears.table.join(
  awful.key({ modkey }, "Tab", function()
    local c = awful.client.focus.history.list[2]
    client.focus = c
    local t = client.focus and client.focus.first_tag or nil
    if t then
      t:view_only()
    end
    c:raise()
  end, { description = "go back", group = "client" }),
  awful.key({ modkey }, "+", function()
    spotify_scratch:toggle()
  end, {
    description = "toggle spotify",
    group = "client",
  }),
  awful.key({ modkey }, "dead_acute", function()
    term_scratch:toggle()
  end, {
    description = "toggle terminal",
    group = "client",
  }),
  awful.key({ modkey }, "j", function()
    awful.client.focus.byidx(1)
  end, {
    description = "focus next by index",
    group = "client",
  }),
  awful.key({ modkey }, "k", function()
    awful.client.focus.byidx(-1)
  end, {
    description = "focus previous by index",
    group = "client",
  }),
  awful.key({ modkey }, "Down", function()
    awful.client.focus.byidx(1)
  end, {
    description = "focus next by index",
    group = "client",
  }),
  awful.key({ modkey }, "Up", function()
    awful.client.focus.byidx(-1)
  end, {
    description = "focus previous by index",
    group = "client",
  }),
  awful.key({ modkey }, "w", function()
    awful.spawn("x-www-browser")
  end, {
    description = "launch browser",
    group = "launcher",
  }), -- Layout manipulation
  awful.key({ modkey, "Shift" }, "Down", function()
    awful.client.swap.byidx(1)
  end, {
    description = "swap with next client by index",
    group = "client",
  }),
  awful.key({ modkey, "Shift" }, "Up", function()
    awful.client.swap.byidx(-1)
  end, {
    description = "swap with previous client by index",
    group = "client",
  }),
  awful.key({ modkey, "Control" }, "Down", function()
    awful.screen.focus_relative(1)
  end, {
    description = "focus the next screen",
    group = "screen",
  }),
  awful.key({ modkey, "Control" }, "Up", function()
    awful.screen.focus_relative(-1)
  end, {
    description = "focus the previous screen",
    group = "screen",
  }),
  awful.key({ modkey }, "u", awful.client.urgent.jumpto, {
    description = "jump to urgent client",
    group = "client",
  }), -- Standard program
  awful.key({ modkey }, "Return", function()
    awful.spawn("kitty")
  end, {
    description = "open a terminal",
    group = "launcher",
  }),
  awful.key({ modkey, "Control" }, "r", awesome.restart, {
    description = "reload awesome",
    group = "awesome",
  }),
  awful.key({ modkey }, "d", function()
    app_launcher:toggle()
  end, {
    description = "launch application",
    group = "launcher",
  }),
  awful.key({ "Mod1" }, "l", function()
    awful.tag.incmwfact(0.05)
  end, {
    description = "increase master width factor",
    group = "layout",
  }),
  awful.key({ "Mod1" }, "h", function()
    awful.tag.incmwfact(-0.05)
  end, {
    description = "decrease master width factor",
    group = "layout",
  }),
  awful.key({ "Mod1", "Shift" }, "h", function()
    awful.tag.incnmaster(1, nil, true)
  end, {
    description = "increase the number of master clients",
    group = "layout",
  }),
  awful.key({ "Mod1", "Shift" }, "l", function()
    awful.tag.incnmaster(-1, nil, true)
  end, {
    description = "decrease the number of master clients",
    group = "layout",
  }),
  awful.key({ modkey, "Control" }, "h", function()
    awful.tag.incncol(1, nil, true)
  end, {
    description = "increase the number of columns",
    group = "layout",
  }),
  awful.key({ modkey, "Control" }, "l", function()
    awful.tag.incncol(-1, nil, true)
  end, {
    description = "decrease the number of columns",
    group = "layout",
  }),
  awful.key({ modkey }, "space", function()
    awful.layout.inc(1)
  end, {
    description = "select next",
    group = "layout",
  }),
  awful.key({ modkey, "Shift" }, "space", function()
    awful.layout.inc(-1)
  end, {
    description = "select previous",
    group = "layout",
  }),
  awful.key({ modkey }, "p", function()
    xrandr.xrandr()
  end),
  awful.key({ modkey, "Control" }, "n", function()
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
  awful.key({ modkey }, "r", function()
    awful.screen.focused().mypromptbox:run()
  end),
  awful.key({ modkey }, "i", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
  awful.key({ modkey }, "section", function()
    spawn.easy_async([[sh -c 'pacmd list-cards | grep index | tail -1 | xargs | cut -d" " -f 2']], function(stdout)
      local index = stdout:gsub("[\n\r]", " ")
      run_cmd(string.format("pactl set-card-profile %s a2dp_sink", index))
    end)
  end, {
    description = "Set hifi audio profile",
    group = "sound",
  }),
  awful.key({}, "XF86AudioMicMute", function()
    run_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle")
  end, { description = "mute microphone", group = "sound" }),
  awful.key({}, "XF86AudioPrev", function()
    run_cmd(
      "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous"
    )
  end, { description = "previous song", group = "sound" }),
  awful.key({}, "XF86AudioPlay", function()
    run_cmd(
      "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause"
    )
  end, { description = "play/pause song", group = "sound" }),
  awful.key({}, "XF86AudioNext", function()
    run_cmd(
      "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next"
    )
  end, { description = "next song", group = "sound" }),
  awful.key({}, "XF86AudioMute", function()
    run_cmd("amixer -D pulse -q set Master toggle")
  end, { description = "toggle mtue volume", group = "sound" }),
  awful.key({}, "XF86AudioLowerVolume", function()
    run_cmd("amixer -q -D pulse sset Master 3%- unmute")
  end, { description = "descrease volume", group = "sound" }),
  awful.key({}, "XF86AudioRaiseVolume", function()
    run_cmd("amixer -q -D pulse sset Master 3%+ unmute")
  end, { description = "increase volume", group = "sound" }),
  awful.key({ modkey }, "l", function()
    run_cmd(
      "dbus-send --type=method_call --dest=org.gnome.ScreenSaver /org/gnome/ScreenSaver org.gnome.ScreenSaver.Lock"
    )
  end),
  awful.key({ modkey }, "s", revelation),
  awful.key({}, "Print", function()
    run_cmd("scrot --line width=3 --select --delay 1 '%Y-%m-%d_$wx$h_scrot.png' -e 'mv $f ~/Pictures/'")
  end, { description = "Screenshot" })
)

clientkeys = gears.table.join(
  awful.key({ modkey }, "f", function(c)
    c.fullscreen = not c.fullscreen
    c:raise()
  end, {
    description = "toggle fullscreen",
    group = "client",
  }),
  awful.key({ modkey }, "q", function(c)
    c:kill()
  end, {
    description = "close",
    group = "client",
  }),
  awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle, {
    description = "toggle floating",
    group = "client",
  }),
  awful.key({ modkey }, "m", function(c)
    c:swap(awful.client.getmaster())
  end, {
    description = "move to master",
    group = "client",
  }),
  awful.key({ modkey }, "o", function(c)
    c:move_to_screen()
  end, {
    description = "move to screen",
    group = "client",
  }),
  awful.key({ modkey }, "t", function(c)
    c.ontop = not c.ontop
  end, {
    description = "toggle keep on top",
    group = "client",
  }),
  awful.key({ modkey, "Control" }, "<", function()
    local tag = awful.screen.focused().selected_tag
    local target_screen = gears.math.cycle(screen:count(), awful.screen.focused().index - 1)
    if tag then
      tag.screen = target_screen
      tag:view_only()
      awful.screen.focus(target_screen)
      local i = 1
      for t in pairs(root.tags()) do
        if root.tags()[t].screen.index == target_screen then
          screen[target_screen].tags[root.tags()[t].index].index = i
          i = i + 1
        end
      end
    end
  end, {
    description = "move to screen",
    group = "client",
  }),
  awful.key({ modkey }, "<", function()
    awful.screen.focus_relative(1)
  end, {
    description = "focus the next screen",
    group = "screen",
  }),
  -- modkey+Tab: cycle through all clients.
  awful.key({ modkey }, "Tab", function(_)
    cyclefocus.cycle({ modifier = "Super_L" })
  end),
  -- modkey+Shift+Tab: backwards
  awful.key({ modkey, "Shift" }, "Tab", function(_)
    cyclefocus.cycle({ modifier = "Super_L" })
  end),
  awful.key({ modkey }, "Escape", awful.tag.history.restore)
)
-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  globalkeys = gears.table.join(
    globalkeys, -- View tag only.
    awful.key({ modkey }, "#" .. i + 9, function()
      local tag = tags.tags[i]
      if tag then
        sharedtags.jumpto(tag)
      end
    end, {
      description = "view tag #" .. i,
      group = "tag",
    }), -- Toggle tag display.
    awful.key({ modkey, "Control" }, "#" .. i + 9, function()
      local screen = awful.screen.focused()
      local tag = tags.tags[i]
      if tag then
        sharedtags.viewtoggle(tag, screen)
      end
    end, {
      description = "toggle tag #" .. i,
      group = "tag",
    }), -- Move client to tag.
    awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
      if client.focus then
        local tag = tags.tags[i]
        if tag then
          client.focus:move_to_tag(tag)
        end
      end
    end, {
      description = "move focused client to tag #" .. i,
      group = "tag",
    }), -- Toggle tag on focused client.
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
      if client.focus then
        local tag = tags.tags[i]
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

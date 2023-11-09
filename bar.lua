local gfs = require("gears.filesystem")
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

local wibox = require("wibox")

local beautiful = require("beautiful")

local theme = require("theme.theme")
local color = require("colors")

local sharedtags = require("sharedtags")
local tags = require("tags")

beautiful.init(gfs.get_configuration_dir() .. "theme/theme.lua")

awful.screen.connect_for_each_screen(function(s)
  -- Set tags and default layout
  -- awful.tag({ "1", "2", "3", "4", "5" }, s, awful.layout.suit.tile)
  -- Assign tags to the newly connected screen here,
  -- if desired:
  sharedtags.viewonly(tags.tags[2], s)

  s.mylayoutbox = awful.widget.layoutbox(s)
  local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t)
      t:view_only()
    end),
    awful.button({ modkey }, 1, function(t)
      if client.focus then
        client.focus:move_to_tag(t)
      end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
      if client.focus then
        client.focus:toggle_tag(t)
      end
    end),
    awful.button({}, 4, function(t)
      awful.tag.viewnext(t.screen)
    end),
    awful.button({}, 5, function(t)
      awful.tag.viewprev(t.screen)
    end)
  )

  s.taglist = awful.widget.taglist({
    screen = s,
    filter = awful.widget.taglist.filter.all,
    style = {
      shape = gears.shape.rounded_rect,
    },
    layout = {
      spacing = 0,
      spacing_widget = {
        color = color.base00,
        shape = gears.shape.rounded_rect,
        widget = wibox.widget.separator,
      },
      layout = wibox.layout.fixed.horizontal,
    },
    widget_template = {
      {
        {
          {
            {
              {
                id = "text_role",
                widget = wibox.widget.textbox,
              },
              margins = 0,
              widget = wibox.container.margin,
            },
            widget = wibox.container.background,
          },
          {
            id = "index_role",
            widget = wibox.widget.textbox,
          },
          layout = wibox.layout.fixed.horizontal,
        },
        left = 7,
        right = 7,
        widget = wibox.container.margin,
      },
      id = "background_role",
      widget = wibox.container.background,
      -- Add support for hover colors and an index label
      -- create_callback = function(self, c3, _, _) --luacheck: no unused args
      --   self:connect_signal("mouse::enter", function()
      --     if #c3:clients() > 0 then
      --       awesome.emit_signal("bling::tag_preview::update", c3)
      --       awesome.emit_signal("bling::tag_preview::visibility", s, true)
      --     end
      --   end)
      --   self:connect_signal("mouse::leave", function()
      --     awesome.emit_signal("bling::tag_preview::visibility", s, false)
      --     if self.has_backup then
      --       self.bg = self.backup
      --     end
      --   end)
      -- end,
      -- update_callback = function(_, _, _, _) end,
    },
    buttons = taglist_buttons,
  })

  -- Tasklist
  local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
      if c == client.focus then
        c.minimized = true
      else
        c:emit_signal("request::activate", "tasklist", { raise = true })
      end
    end),
    awful.button({}, 3, function()
      awful.menu.client_list({ theme = { width = 150 } })
    end),
    awful.button({}, 2, function()
      awful.client.focus.byidx(1)
    end)
  )

  s.tasklist = awful.widget.tasklist({
    screen = s,
    filter = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_buttons,
    layout = {
      spacing = 5,
      spacing_widget = {
        {
          forced_width = 2,
          color = color.base02,
          shape = gears.shape.rounded_bar,
          widget = wibox.widget.separator,
        },
        valign = "center",
        halign = "center",
        widget = wibox.container.place,
      },
      layout = wibox.layout.flex.horizontal,
    },
    -- Notice that there is *NO* wibox.wibox prefix, it is a template,
    -- not a widget instance.
    widget_template = {
      {
        {
          {
            {
              id = "icon_role",
              widget = wibox.widget.imagebox,
            },
            margins = 2,
            widget = wibox.container.margin,
          },
          layout = wibox.layout.fixed.horizontal,
        },
        left = 10,
        right = 10,
        widget = wibox.container.margin,
      },
      id = "background_role",
      widget = wibox.container.background,
    },
  })

  local mysystray = wibox.widget.systray({
    icon_size = 10,
  })
  local volume = require("widgets.volume-widget.volume")
  local battery = require("widgets.battery-widget.battery")
  local logout_menu = require("widgets.logout-menu-widget.logout-menu")

  -- Clock
  local myclock = awful.widget.textclock("<span font='" .. theme.font .. "'>   %Y-%m-%d %H:%M:%S </span>", 5)

  -- Create the top bar
  s.wibar = awful.wibar({
    shape = function(cr, w, h)
      gears.shape.rounded_rect(cr, w, h, 10)
    end,
    position = "top",
    x = 0,
    y = 0,
    screen = s,
    height = 35,
    width = 1200,
    stretch = false,
    bg = color.base00,
    border_width = 2,
    border_color = color.base02,
  })

  s.wibar.y = 10

  -- Add widgets
  s.wibar:setup({
    layout = wibox.layout.align.horizontal,
    expand = "none",
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      wibox.layout.margin(s.mylayoutbox, 10, 0, 10, 10),
      wibox.layout.margin(mysystray, 10, 0, 10, 10),
      wibox.layout.margin(s.tasklist, 7, 7, 7, 7),
    },
    {
      layout = wibox.layout.fixed.horizontal,
      {
        wibox.layout.margin(s.taglist, 7, 7, 7, 7),
        widget = wibox.container.background,
      },
    },
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      wibox.layout.margin(volume({ font = theme.font }), 0, 5, 10, 10),
      wibox.layout.margin(battery({ font = theme.font, show_current_level = true }), 0, 5, 10, 10),
      wibox.layout.margin(myclock, 0, 5, 7, 7),
      wibox.layout.margin(logout_menu({ font = theme.font }), 0, 5, 7, 7),
    },
  })
end)

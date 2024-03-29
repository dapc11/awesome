-------------------------------------------------
-- The Ultimate Volume Widget for Awesome Window Manager
-- More details could be found here:
-- https://github.com/streetturtle/widgets/tree/master/volume-widget

-- @author Pavel Makhov
-- @copyright 2020 Pavel Makhov
-------------------------------------------------

local awful = require("awful")
local wibox = require("wibox")
local spawn = require("awful.spawn")
local gears = require("gears")
local beautiful = require("beautiful")
local watch = require("awful.widget.watch")
local utils = require("widgets.volume-widget.utils")
local colors = require("colors")
local theme = require("theme.theme")

local LIST_DEVICES_CMD = [[sh -c "pacmd list-sinks; pacmd list-sources"]]
local function GET_VOLUME_CMD(device)
  return "amixer -D " .. device .. " sget Master"
end

local function INC_VOLUME_CMD(device, step)
  return "amixer -D " .. device .. " sset Master " .. step .. "%+"
end

local function DEC_VOLUME_CMD(device, step)
  return "amixer -D " .. device .. " sset Master " .. step .. "%-"
end

local function TOG_VOLUME_CMD(device)
  return "amixer -D " .. device .. " sset Master toggle"
end

local widget_types = {
  icon_and_text = require("widgets.volume-widget.widgets.icon-and-text-widget"),
}
local volume = {}

local rows = { layout = wibox.layout.fixed.vertical }

local popup = awful.popup({
  ontop = true,
  visible = false,
  shape = gears.shape.rounded_rect,
  bg = colors.base00,
  border_width = 2,
  border_color = colors.base02,
  maximum_width = 400,
  offset = { x = 10 },
  widget = {},
})

local function build_main_line(device)
  if device.active_port ~= nil and device.ports[device.active_port] ~= nil then
    return device.properties.device_description .. " · " .. device.ports[device.active_port]
  else
    return device.properties.device_description
  end
end

local function build_rows(args, devices, on_checkbox_click, device_type)
  local device_rows = { layout = wibox.layout.fixed.vertical }
  for _, device in pairs(devices) do
    local checkbox = wibox.widget({
      checked = device.is_default,
      color = args.unselected,
      paddings = 2,
      shape = gears.shape.circle,
      forced_width = 20,
      forced_height = 20,
      check_color = args.selected,
      widget = wibox.widget.checkbox,
    })

    checkbox:connect_signal("button::press", function()
      spawn.easy_async(string.format([[sh -c 'pacmd set-default-%s "%s"']], device_type, device.name), function()
        on_checkbox_click()
      end)
    end)

    local row = wibox.widget({
      {
        {
          {
            checkbox,
            valign = "center",
            spacing = 15,
            layout = wibox.container.place,
          },
          {
            {
              text = build_main_line(device),
              font = beautiful.font,
              align = "left",
              widget = wibox.widget.textbox,
            },
            left = 10,
            layout = wibox.container.margin,
          },
          spacing = 8,
          layout = wibox.layout.align.horizontal,
        },
        margins = 4,
        layout = wibox.container.margin,
      },
      bg = beautiful.bg_normal,
      fg = beautiful.fg_normal,
      widget = wibox.container.background,
    })

    row:connect_signal("mouse::enter", function(c)
      c:set_bg(colors.base02)
    end)
    row:connect_signal("mouse::leave", function(c)
      c:set_bg(beautiful.bg_normal)
    end)

    local old_cursor, old_wibox
    row:connect_signal("mouse::enter", function()
      local wb = mouse.current_wibox
      old_cursor, old_wibox = wb.cursor, wb
      wb.cursor = "hand1"
    end)
    row:connect_signal("mouse::leave", function()
      if old_wibox then
        old_wibox.cursor = old_cursor
        old_wibox = nil
      end
    end)

    row:connect_signal("button::press", function()
      spawn.easy_async(string.format([[sh -c 'pacmd set-default-%s "%s"']], device_type, device.name), function()
        on_checkbox_click()
      end)
    end)

    table.insert(device_rows, row)
  end

  return device_rows
end

local function build_header_row(text)
  return wibox.widget({
    {
      text = text,
      font = theme.font,
      align = "center",
      widget = wibox.widget.textbox,
    },
    fg = beautiful.fg_normal,
    bg = beautiful.bg_normal,
    widget = wibox.container.background,
  })
end

local function rebuild_popup(args)
  spawn.easy_async(LIST_DEVICES_CMD, function(stdout)
    local sinks, sources = utils.extract_sinks_and_sources(stdout)

    for i = 0, #rows do
      rows[i] = nil
    end

    table.insert(rows, build_header_row("Sinks"))
    table.insert(
      rows,
      build_rows(args, sinks, function()
        rebuild_popup()
      end, "sink")
    )
    table.insert(rows, build_header_row("Sources"))
    table.insert(
      rows,
      build_rows(args, sources, function()
        rebuild_popup()
      end, "source")
    )

    popup:setup(rows)

    popup:connect_signal("mouse::leave", function()
      if popup.visible then
        popup.visible = not popup.visible
      end
    end)
  end)
end

local function worker(user_args)
  local args = user_args or {}

  local mixer_cmd = args.mixer_cmd or "pavucontrol"
  local widget_type = args.widget_type
  local refresh_rate = args.refresh_rate or 1
  local step = args.step or 5
  local device = args.device or "pulse"

  if widget_types[widget_type] == nil then
    volume.widget = widget_types["icon_and_text"].get_widget(args.icon_and_text_args)
  else
    volume.widget = widget_types[widget_type].get_widget(args)
  end

  local function update_graphic(widget, stdout)
    local mute = string.match(stdout, "%[(o%D%D?)%]") -- \[(o\D\D?)\] - [on] or [off]
    if mute == "off" then
      widget:mute()
    elseif mute == "on" then
      widget:unmute()
    end
    local volume_level = string.match(stdout, "(%d?%d?%d)%%") -- (\d?\d?\d)\%)
    volume_level = string.format("% 3d", volume_level)
    widget:set_volume_level(volume_level)
  end

  function volume:inc(s)
    spawn.easy_async(INC_VOLUME_CMD(device, s or step), function(stdout)
      update_graphic(volume.widget, stdout)
    end)
  end

  function volume:dec(s)
    spawn.easy_async(DEC_VOLUME_CMD(device, s or step), function(stdout)
      update_graphic(volume.widget, stdout)
    end)
  end

  function volume:toggle()
    spawn.easy_async(TOG_VOLUME_CMD(device), function(stdout)
      update_graphic(volume.widget, stdout)
    end)
  end

  function volume:mixer()
    if mixer_cmd then
      spawn.easy_async(mixer_cmd)
    end
  end

  volume.widget:buttons(awful.util.table.join(
    awful.button({}, 3, function()
      if popup.visible then
        popup.visible = not popup.visible
      else
        rebuild_popup(args)
        popup:move_next_to(mouse.current_widget_geometry)
      end
    end),
    awful.button({}, 4, function()
      volume:inc()
    end),
    awful.button({}, 5, function()
      volume:dec()
    end),
    awful.button({}, 2, function()
      volume:mixer()
    end),
    awful.button({}, 1, function()
      volume:toggle()
    end)
  ))

  watch(GET_VOLUME_CMD(device), refresh_rate, update_graphic, volume.widget)

  return volume.widget
end

return setmetatable(volume, {
  __call = function(_, ...)
    return worker(...)
  end,
})

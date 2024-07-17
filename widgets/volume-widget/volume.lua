local awful = require("awful")
local spawn = require("awful.spawn")
local watch = require("awful.widget.watch")

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

local function worker(user_args)
  local args = user_args or {}

  local mixer_cmd = "pavucontrol"
  local widget_type = args.widget_type
  local refresh_rate = args.refresh_rate or 1
  local step = args.step or 5
  local device = "pulse"

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

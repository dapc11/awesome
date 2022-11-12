local gtable = require("gears.table")
local spawn = require("awful.spawn")
local naughty = require("naughty")

local icon_path = ""

local function outputs()
  local active_outputs = {}
  local xrandr = io.popen("xrandr -q --current")

  if xrandr then
    for line in xrandr:lines() do
      local output = line:match("^([%w-]+) connected ")
      if output then
        active_outputs[#active_outputs + 1] = output
      end
    end
    xrandr:close()
  end

  return active_outputs
end

local function arrange(out)
  local choices = {}
  local previous = { {} }
  for _ = 1, #out do
    local new = {}
    for _, o in pairs(out) do
      for _, p in pairs(previous) do
        if not gtable.hasitem(p, o) then
          new[#new + 1] = gtable.join(p, { o })
        end
      end
    end
    choices = gtable.join(choices, new)
    previous = new
  end

  return choices
end

local function menu()
  local menu = {}
  local out = outputs()
  local choices = arrange(out)

  for _, choice in pairs(choices) do
    local cmd = "xrandr"
    -- Enabled outputs
    for i, o in pairs(choice) do
      cmd = cmd .. " --output " .. o .. " --auto"
      if i > 1 then
        cmd = cmd .. " --right-of " .. choice[i - 1]
      end
    end
    -- Disabled outputs
    for _, o in pairs(out) do
      if not gtable.hasitem(choice, o) then
        cmd = cmd .. " --output " .. o .. " --off"
      end
    end

    local label = ""
    if #choice == 1 then
      label = 'Only <span weight="bold">' .. choice[1] .. "</span>"
    else
      for i, o in pairs(choice) do
        if i > 1 then
          label = label .. " + "
        end
        label = label .. '<span weight="bold">' .. o .. "</span>"
      end
    end

    menu[#menu + 1] = { label, cmd }
  end

  return menu
end

-- Display xrandr notifications from choices
local state = {
  cid = nil,
}

local function naughty_destroy_callback(reason)
  if reason == naughty.notificationClosedReason.expired or reason == naughty.notificationClosedReason.dismissedByUser
  then
    local action = state.index and state.menu[state.index - 1][2]
    if action then
      spawn(action, false)
      state.index = nil
    end
  end
end

local function xrandr()
  -- Build the list of choices
  if not state.index then
    state.menu = menu()
    state.index = 1
  end

  -- Select one and display the appropriate notification
  local label
  local next = state.menu[state.index]
  state.index = state.index + 1

  if not next then
    label = "Keep the current configuration"
    state.index = nil
  else
    label = next[1]
  end
  state.cid = naughty.notify({
    text = label,
    icon = icon_path,
    timeout = 4,
    screen = mouse.screen,
    replaces_id = state.cid,
    destroy = naughty_destroy_callback,
  }).id
end

return {
  outputs = outputs,
  arrange = arrange,
  menu = menu,
  xrandr = xrandr,
}

--- Separating Multiple Monitor functions as a separeted module (taken from awesome wiki)
local gtable = require("gears.table")
local spawn = require("awful.spawn")
local naughty = require("naughty")

-- A path to a fancy icon
local icon_path = ""

-- Get active outputs
local function outputs()
  local o = {}
  local xrandr = io.popen("xrandr -q --current")

  if xrandr then
    for line in xrandr:lines() do
      local output = line:match("^([%w-]+) connected ")
      if output then
        o[#o + 1] = output
      end
    end
    xrandr:close()
  end

  return o
end

local function arrange(out)
  -- We need to enumerate all permutations of horizontal outputs.

  local choices = {}
  local previous = { {} }
  for _ = 1, #out do
    -- Find all permutation of length `i`: we take the permutation
    -- of length `i-1` and for each of them, we create new
    -- permutations by adding each output at the end of it if it is
    -- not already present.
    local new = {}
    for _, p in pairs(previous) do
      for _, o in pairs(out) do
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

local function simple_menu()
  local m = {}
  local out = outputs()

  m[1] = {
    '<span weight="bold">3 Screens</span>',
    "xrandr --output DP-2-1-8 --auto --output DP-1-8 --auto --right-of DP-2-1-8 --output DP-1-1-8 --auto --right-of DP-1-8",
  }
  m[2] = {
    '<span weight="bold">Home Office</span>',
    "xrandr --output eDP-1 --auto --output DP-1-8 --auto --right-of eDP-1",
  }
  m[3] = { '<span weight="bold">Laptop</span>', "xrandr --output eDP-1 --auto" }
  m[4] = { '<span weight="bold">HDMI</span>', "xrandr --output eDP-1 --auto --output HDMI-1 --auto --right-of eDP-1" }

  local choices = arrange(out)

  for i, d in pairs(m) do
    local cmd = d[2]
    -- Disable unused outputs
    for _, choice in pairs(choices) do
      for _, o in pairs(out) do
        if not gtable.hasitem(choice, o) then
          cmd = cmd .. " --output " .. o .. " --off"
        end
      end
    end
    m[i][2] = cmd
  end
  return m
end

-- Build available choices
local function menu()
  local m = {}
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

    m[#m + 1] = { label, cmd }
  end

  return m
end

-- Display xrandr notifications from choices
local state = {
  cid = nil,
}

local function naughty_destroy_callback(reason)
  if
    reason == naughty.notificationClosedReason.expired or reason == naughty.notificationClosedReason.dismissedByUser
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
    label, _ = next[1], next[2]
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

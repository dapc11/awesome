local xresources = require("beautiful.xresources")
local gears = require("gears")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir() .. "/icons/"

local m = {}
local font_size = 11

m.modkey = "Mod4"
m.terminal = "wezterm"

m.font = "SF Pro Display " .. font_size
m.wallpaper = os.getenv("HOME") .. "/.local/background.jpg"
-- Background
m.bg_normal = "#2d333b"
m.bg_dark = "#24292e"
m.bg_focus = nil
m.bg_urgent = "#ff7b72"
m.bg_minimize = "#586069"

-- Foreground
m.fg_normal = "#c9d1d9"
m.fg_focus = ""
m.fg_urgent = "#24292e"
m.fg_minimize = "#8b949e"

-- Window Gap Distance
m.useless_gap = dpi(7)

-- Do Not Show Gaps if Only One Client is Visible
m.gap_single_client = false

-- Window Borders
m.border_width = dpi(1)
m.border_normal = m.bg_normal
m.border_focus = "#6e7681"
m.border_marked = m.fg_urgent

-- Tasklist
m.tasklist_font = m.font

-- Notifications
m.notification_max_width = dpi(500)
m.notification_bg = "#2d333b"
m.notification_shape = gears.shape.rounded_rect
m.notification_font = m.font

-- System Tray
m.bg_systray = m.bg_normal
m.systray_icon_spacing = dpi(5)

-- Titlebars
m.titlebars_enabled = false
-- Define the image to load
m.titlebar_close_button_normal = themes_path .. "titlebar/close_normal.png"
m.titlebar_close_button_focus = themes_path .. "titlebar/close_focus.png"

m.titlebar_minimize_button_normal = themes_path .. "titlebar/minimize_normal.png"
m.titlebar_minimize_button_focus = themes_path .. "titlebar/minimize_focus.png"

m.titlebar_ontop_button_normal_inactive = themes_path .. "titlebar/ontop_normal_inactive.png"
m.titlebar_ontop_button_focus_inactive = themes_path .. "titlebar/ontop_focus_inactive.png"
m.titlebar_ontop_button_normal_active = themes_path .. "titlebar/ontop_normal_active.png"
m.titlebar_ontop_button_focus_active = themes_path .. "titlebar/ontop_focus_active.png"

m.titlebar_sticky_button_normal_inactive = themes_path .. "titlebar/sticky_normal_inactive.png"
m.titlebar_sticky_button_focus_inactive = themes_path .. "titlebar/sticky_focus_inactive.png"
m.titlebar_sticky_button_normal_active = themes_path .. "titlebar/sticky_normal_active.png"
m.titlebar_sticky_button_focus_active = themes_path .. "titlebar/sticky_focus_active.png"

m.titlebar_floating_button_normal_inactive = themes_path .. "titlebar/floating_normal_inactive.png"
m.titlebar_floating_button_focus_inactive = themes_path .. "titlebar/floating_focus_inactive.png"
m.titlebar_floating_button_normal_active = themes_path .. "titlebar/floating_normal_active.png"
m.titlebar_floating_button_focus_active = themes_path .. "titlebar/floating_focus_active.png"

m.titlebar_maximized_button_normal_inactive = themes_path .. "titlebar/maximized_normal_inactive.png"
m.titlebar_maximized_button_focus_inactive = themes_path .. "titlebar/maximized_focus_inactive.png"
m.titlebar_maximized_button_normal_active = themes_path .. "titlebar/maximized_normal_active.png"
m.titlebar_maximized_button_focus_active = themes_path .. "titlebar/maximized_focus_active.png"

m.parent_filter_list = { "Google-chrome", "firefox", "Gimp", "microsoft teams - preview", "Microsoft Teams - Preview", "Evolution" } -- class names list of parents that should not be swallowed
m.child_filter_list = { "Dragon", "microsoft teams - preview", "Microsoft Teams - Preview", "Evolution", "Google-chrome" } -- class names list that should not swallow their parents
m.swallowing_filter = false -- whether the filters above should be active

return m

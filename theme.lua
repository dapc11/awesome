local xresources = require("beautiful.xresources")
local gears = require("gears")
local c = require("colors")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir() .. "/icons/"

local theme = {}
theme.font = "SF Pro Display 11"
theme.gap_single_client = false
theme.modkey = "Mod4"
theme.notification_max_width = dpi(500)
theme.notification_shape = gears.shape.rounded_rect
theme.systray_icon_spacing = dpi(5)
theme.terminal = "alacritty"
theme.titlebars_enabled = false
theme.useless_gap = dpi(7)
theme.wallpaper = os.getenv("HOME") .. "/.local/background.jpg"

theme.bg_dark = c.base00
theme.bg_focus = c.base02
theme.bg_minimize = c.base03
theme.bg_normal = c.base01
theme.bg_systray = c.base01
theme.bg_urgent = c.base08

theme.border_focus = c.base04
theme.border_marked = c.base08
theme.border_normal = c.base01
theme.border_width = dpi(1)

theme.fg_focus = c.none
theme.fg_minimize = c.base05
theme.fg_normal = c.base06
theme.fg_urgent = c.base00

theme.notification_bg = c.base01
theme.notification_font = theme.font

theme.tasklist_font = theme.font

theme.titlebar_close_button_focus = themes_path .. "titlebar/close_focus.png"
theme.titlebar_close_button_normal = themes_path .. "titlebar/close_normal.png"

theme.titlebar_floating_button_focus_active = themes_path .. "titlebar/floating_focus_active.png"
theme.titlebar_floating_button_focus_inactive = themes_path .. "titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path .. "titlebar/floating_normal_active.png"
theme.titlebar_floating_button_normal_inactive = themes_path .. "titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active = themes_path .. "titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_focus_inactive = themes_path .. "titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path .. "titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_normal_inactive = themes_path .. "titlebar/maximized_normal_inactive.png"

theme.titlebar_minimize_button_focus = themes_path .. "titlebar/minimize_focus.png"
theme.titlebar_minimize_button_normal = themes_path .. "titlebar/minimize_normal.png"

theme.titlebar_ontop_button_focus_active = themes_path .. "titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_focus_inactive = themes_path .. "titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path .. "titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_normal_inactive = themes_path .. "titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active = themes_path .. "titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_focus_inactive = themes_path .. "titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path .. "titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_normal_inactive = themes_path .. "titlebar/sticky_normal_inactive.png"

theme.parent_filter_list = { "firefox", "Gimp", "microsoft teams - preview", "Microsoft Teams - Preview", "Evolution" } -- class names list of parents that should not be swallowed
theme.child_filter_list = { "Dragon", "microsoft teams - preview", "Microsoft Teams - Preview", "Evolution" } -- class names list that should not swallow their parents
theme.swallowing_filter = true -- whether the filters above should be active

return theme

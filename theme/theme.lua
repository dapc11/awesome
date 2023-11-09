local gfs = require("gears.filesystem")
local colors = require("colors")

local theme = {}

theme.font = "SF Pro Display 11"
theme.modkey = "Mod4"

theme.dir = string.format("%s/.config/awesome/theme/", os.getenv("HOME"))

theme.bg_normal = colors.base00
theme.bg_focus = colors.base00
theme.bg_urgent = colors.base00
theme.bg_minimize = colors.base00
theme.bg_systray = theme.bg_normal

theme.useless_gap = 10
theme.border_width = 2
theme.border_radius = 20
theme.border_normal = colors.base02
theme.border_focus = colors.base02
theme.border_marked = colors.base02

theme.tasklist_font = theme.font
-- theme.tag_preview_widget_border_radius = 10
-- theme.tag_preview_client_border_radius = 10
-- theme.tag_preview_client_opacity = 0.1
-- theme.tag_preview_client_bg = colors.base00
-- theme.tag_preview_client_border_color = colors.base02
-- theme.tag_preview_client_border_width = 2
-- theme.tag_preview_widget_bg = colors.base00
-- theme.tag_preview_widget_border_color = colors.base02
-- theme.tag_preview_widget_border_width = 2
-- theme.tag_preview_widget_margin = 0

theme.taglist_fg = colors.base0D
theme.taglist_fg_empty = colors.base02
theme.taglist_fg_occupied = colors.base05
theme.taglist_font = theme.font

theme.titlebar_close_button_normal = gfs.get_configuration_dir() .. "theme/titlebar/inactive.png"
theme.titlebar_close_button_focus = gfs.get_configuration_dir() .. "theme/titlebar/close.png"
theme.titlebar_close_button_focus_hover = gfs.get_configuration_dir() .. "theme/titlebar/close_hover.png"

theme.titlebar_minimize_button_normal = gfs.get_configuration_dir() .. "theme/titlebar/inactive.png"
theme.titlebar_minimize_button_focus = gfs.get_configuration_dir() .. "theme/titlebar/minimize.png"
theme.titlebar_minimize_button_focus_hover = gfs.get_configuration_dir() .. "theme/titlebar/minimize_hover.png"

theme.titlebar_floating_button_normal_inactive = gfs.get_configuration_dir() .. "theme/titlebar/inactive.png"
theme.titlebar_floating_button_focus_inactive = gfs.get_configuration_dir() .. "theme/titlebar/floating.png"
theme.titlebar_floating_button_normal_active = gfs.get_configuration_dir() .. "theme/titlebar/inactive.png"
theme.titlebar_floating_button_focus_active = gfs.get_configuration_dir() .. "theme/titlebar/floating.png"
theme.titlebar_floating_button_focus_active_hover = gfs.get_configuration_dir() .. "theme/titlebar/floating_hover.png"
theme.titlebar_floating_button_focus_inactive_hover = gfs.get_configuration_dir() .. "theme/titlebar/floating_hover.png"
theme.parent_filter_list = {
  "google-chrome",
  "Google-chrome",
  "firefox",
  "Gimp",
  "microsoft teams - preview",
  "Microsoft Teams - Preview",
  "Evolution",
  "Firefox",
} -- class names list of parents that should not be swallowed
theme.child_filter_list = {
  "Dragon",
  "microsoft teams - preview",
  "Microsoft Teams - Preview",
  "Evolution",
  "Google-chrome",
  "google-chrome",
  "firefox",
  "Firefox",
} -- class names list that should not swallow their parents
-- theme.swallowing_filter = true -- whether the filters above should be active

return theme

local awful = require("awful")
local theme_name = "my"
local theme_assets = require("beautiful.theme_assets")
local x = require("beautiful.xresources")
local dpi = x.apply_dpi
-- local gfs = require("gears.filesystem")
-- local themes_path = gfs.get_themes_dir()
-- local icon_path = os.getenv("HOME") .. "/.config/awesome/themes/" .. theme_name .. "/icons/"
local layout_icon_path = os.getenv("HOME") .. "/.config/awesome/themes/" .. theme_name .. "/layout/"
local titlebar_icon_path = os.getenv("HOME") .. "/.config/awesome/themes/" .. theme_name .. "/titlebar/"
-- local weather_icon_path = os.getenv("HOME") .. "/.config/awesome/themes/" .. theme_name .. "/weather/"
-- local taglist_icon_path = os.getenv("HOME") .. "/.config/awesome/themes/" .. theme_name .. "/taglist/"
local tip = titlebar_icon_path -- alias to save time/space
-- local xrdb = x.get_current_theme()

-- local theme = dofile(os.getenv("HOME") .. "/.config/awesome/themes/default/theme.lua")
local theme = {}

theme.font = "Iosevka Term, Medium 11"

theme.bg_dark = x.background
theme.bg_normal = "#1e1e1e40" -- x.color5
theme.bg_focus = "#1B2B34C0" -- x.color8
theme.bg_urgent = "#EC5f67" -- x.color8
theme.bg_minimize = x.color8
theme.bg_systray = x.background

theme.fg_normal = "#D8DEE9" -- x.color2
theme.fg_focus = "#ffffff" -- x.color4
theme.fg_urgent = "#ff0000" -- x.color3
theme.fg_minimize = x.color8

-- Gaps
theme.useless_gap = dpi(3)
-- This could be used to manually determine how far away from the
-- screen edge the bars / notifications should be.
theme.screen_margin = dpi(3)

-- Borders
theme.border_width = dpi(0)
theme.border_color = "#1e1e1e" -- x.color0
theme.border_normal = "#1e1e1e" -- x.color0
theme.border_focus = "#1B2B34" -- x.color0
theme.border_marked = x.color0
-- Rounded corners
theme.border_radius = dpi(60)

-- theme.bg_normal     = "#555555"
-- theme.bg_focus      = "#535d6c"
-- theme.bg_urgent     = "#ff0000"
-- theme.bg_minimize   = "#444444"
-- theme.bg_systray    = theme.bg_normal

-- theme.fg_normal     = "#aaaaaa"
-- theme.fg_focus      = "#ffffff"
-- theme.fg_urgent     = "#ffffff"
-- theme.fg_minimize   = "#ffffff"

-- theme.useless_gap   = dpi(0)
-- theme.border_width  = dpi(1)
-- theme.border_normal = "#000000"
-- theme.border_focus  = "#535d6c"
-- theme.border_marked = "#91231c"

-- -- Titlebars
-- -- (Titlebar items can be customized in titlebars.lua)
-- theme.titlebars_enabled = true
-- theme.titlebar_size = dpi(35)
-- theme.titlebar_title_enabled = true
-- -- theme.titlebar_font = "sans bold 9"
-- -- Window title alignment: left, right, center
-- theme.titlebar_title_align = "center"
-- -- Titlebar position: top, bottom, left, right
-- -- theme.titlebar_position = "top"
-- theme.titlebar_bg = x.color0
-- theme.titlebar_bg_focus = "#ff000010"
-- -- theme.titlebar_bg_normal = x.color13
-- theme.titlebar_fg_focus = x.color7
-- theme.titlebar_fg_normal = x.color8
-- --theme.titlebar_fg = x.color7

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
-- theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
-- local taglist_square_size = dpi(4)
-- theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
--     taglist_square_size, theme.fg_normal
-- )
-- theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
--     taglist_square_size, theme.fg_normal
-- )

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
-- theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width = dpi(100)

-- Notifications
-- Position: bottom_left, bottom_right, bottom_middle,
--         top_left, top_right, top_middle
theme.notification_position = "top_right" -- BUG: some notifications appear at top_right regardless
theme.notification_border_width = dpi(0)
theme.notification_border_radius = theme.border_radius
theme.notification_border_color = x.color10
theme.notification_bg = x.color0
theme.notification_fg = x.color7
theme.notification_crit_bg = x.color3
theme.notification_crit_fg = x.color0
theme.notification_icon_size = dpi(60)
-- theme.notification_height = dpi(80)
-- theme.notification_width = dpi(300)
theme.notification_margin = dpi(15)
theme.notification_opacity = 1
theme.notification_font = theme.font
theme.notification_padding = theme.screen_margin * 2
theme.notification_spacing = theme.screen_margin * 2

-- Edge snap
theme.snap_bg = theme.bg_focus
if theme.border_width == 0 then
    theme.snap_border_width = dpi(8)
else
    theme.snap_border_width = dpi(theme.border_width * 2)
end
-- Doesnt work with 4.2, need awesome-git?
-- theme.snapper_gap = theme.useless_gap

-- Tag names
theme.tagnames = {" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 ", " 0 "}

-- Widget separator
theme.separator_text = "|"
-- theme.separator_text = " :: "
-- theme.separator_text = " • "
-- theme.separator_text = " •• "
theme.separator_fg = x.color8

-- Wibar(s)
theme.wibar_position = "bottom"
theme.wibar_ontop = false
theme.wibar_height = dpi(24)
theme.wibar_fg = x.color7
theme.wibar_bg = x.color0
theme.wibar_opacity = 0.2
theme.wibar_border_color = "#6699CC"
theme.wibar_border_width = dpi(0)
theme.wibar_border_radius = dpi(0)

theme.prefix_fg = x.color8

-- Tasklist
theme.tasklist_disable_icon = true
theme.tasklist_plain_task_name = true
theme.tasklist_bg_focus = x.color0
theme.tasklist_fg_focus = x.color4
theme.tasklist_bg_normal = x.color0
theme.tasklist_fg_normal = x.color15
theme.tasklist_bg_minimize = x.color0
theme.tasklist_fg_minimize = theme.fg_minimize
theme.tasklist_bg_urgent = x.color0
theme.tasklist_fg_urgent = x.color3
theme.tasklist_spacing = dpi(5)
theme.tasklist_align = "center"

theme.taglist_text_color_empty = {
    x.color8, x.color8, x.color8, x.color8, x.color8, x.color8, x.color8, x.color8, x.color8, x.color8
}
theme.taglist_text_color_occupied = {
    x.color1, x.color2, x.color3, x.color4, x.color5, x.color6, x.color1, x.color2, x.color3, x.color4
}
theme.taglist_text_color_focused = {
    x.color1, x.color2, x.color3, x.color4, x.color5, x.color6, x.color1, x.color2, x.color3, x.color4
}
theme.taglist_text_color_urgent = {
    x.color9, x.color10, x.color11, x.color12, x.color13, x.color14, x.color9, x.color10, x.color11, x.color12
}

-- Prompt
theme.prompt_fg = x.color12

-- Text Taglist (default)
theme.taglist_font = "Iosevka Term, Heavy 11"
theme.taglist_bg_focus = x.background
theme.taglist_fg_focus = x.color12
theme.taglist_bg_occupied = x.background
theme.taglist_fg_occupied = x.color8
theme.taglist_bg_empty = x.background
theme.taglist_fg_empty = x.background
theme.taglist_bg_urgent = x.background
theme.taglist_fg_urgent = x.color3
theme.taglist_disable_icon = true
theme.taglist_spacing = dpi(1)
-- Generate taglist squares:
local taglist_square_size = dpi(0)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_focus)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)

-- Variables set for theming the menu:
-- theme.menu_submenu_icon = icon_path.."submenu.png"
theme.menu_height = dpi(35)
theme.menu_width = dpi(180)
theme.menu_bg_normal = x.color0
theme.menu_fg_normal = x.color7
theme.menu_bg_focus = x.color8
theme.menu_fg_focus = x.color7
theme.menu_border_width = dpi(0)
theme.menu_border_color = x.color0

-- Titlebar buttons
-- Define the images to load
theme.titlebar_close_button_normal = tip .. "close_normal.svg"
theme.titlebar_close_button_focus = tip .. "close_focus.svg"
theme.titlebar_minimize_button_normal = tip .. "minimize_normal.svg"
theme.titlebar_minimize_button_focus = tip .. "minimize_focus.svg"
theme.titlebar_ontop_button_normal_inactive = tip .. "ontop_normal_inactive.svg"
theme.titlebar_ontop_button_focus_inactive = tip .. "ontop_focus_inactive.svg"
theme.titlebar_ontop_button_normal_active = tip .. "ontop_normal_active.svg"
theme.titlebar_ontop_button_focus_active = tip .. "ontop_focus_active.svg"
theme.titlebar_sticky_button_normal_inactive = tip .. "sticky_normal_inactive.svg"
theme.titlebar_sticky_button_focus_inactive = tip .. "sticky_focus_inactive.svg"
theme.titlebar_sticky_button_normal_active = tip .. "sticky_normal_active.svg"
theme.titlebar_sticky_button_focus_active = tip .. "sticky_focus_active.svg"
theme.titlebar_floating_button_normal_inactive = tip .. "floating_normal_inactive.svg"
theme.titlebar_floating_button_focus_inactive = tip .. "floating_focus_inactive.svg"
theme.titlebar_floating_button_normal_active = tip .. "floating_normal_active.svg"
theme.titlebar_floating_button_focus_active = tip .. "floating_focus_active.svg"
theme.titlebar_maximized_button_normal_inactive = tip .. "maximized_normal_inactive.svg"
theme.titlebar_maximized_button_focus_inactive = tip .. "maximized_focus_inactive.svg"
theme.titlebar_maximized_button_normal_active = tip .. "maximized_normal_active.svg"
theme.titlebar_maximized_button_focus_active = tip .. "maximized_focus_active.svg"
-- (hover)
theme.titlebar_close_button_normal_hover = tip .. "close_normal_hover.svg"
theme.titlebar_close_button_focus_hover = tip .. "close_focus_hover.svg"
theme.titlebar_minimize_button_normal_hover = tip .. "minimize_normal_hover.svg"
theme.titlebar_minimize_button_focus_hover = tip .. "minimize_focus_hover.svg"
theme.titlebar_ontop_button_normal_inactive_hover = tip .. "ontop_normal_inactive_hover.svg"
theme.titlebar_ontop_button_focus_inactive_hover = tip .. "ontop_focus_inactive_hover.svg"
theme.titlebar_ontop_button_normal_active_hover = tip .. "ontop_normal_active_hover.svg"
theme.titlebar_ontop_button_focus_active_hover = tip .. "ontop_focus_active_hover.svg"
theme.titlebar_sticky_button_normal_inactive_hover = tip .. "sticky_normal_inactive_hover.svg"
theme.titlebar_sticky_button_focus_inactive_hover = tip .. "sticky_focus_inactive_hover.svg"
theme.titlebar_sticky_button_normal_active_hover = tip .. "sticky_normal_active_hover.svg"
theme.titlebar_sticky_button_focus_active_hover = tip .. "sticky_focus_active_hover.svg"
theme.titlebar_floating_button_normal_inactive_hover = tip .. "floating_normal_inactive_hover.svg"
theme.titlebar_floating_button_focus_inactive_hover = tip .. "floating_focus_inactive_hover.svg"
theme.titlebar_floating_button_normal_active_hover = tip .. "floating_normal_active_hover.svg"
theme.titlebar_floating_button_focus_active_hover = tip .. "floating_focus_active_hover.svg"
theme.titlebar_maximized_button_normal_inactive_hover = tip .. "maximized_normal_inactive_hover.svg"
theme.titlebar_maximized_button_focus_inactive_hover = tip .. "maximized_focus_inactive_hover.svg"
theme.titlebar_maximized_button_normal_active_hover = tip .. "maximized_normal_active_hover.svg"
theme.titlebar_maximized_button_focus_active_hover = tip .. "maximized_focus_active_hover.svg"

-- You can use your own layout icons like this:
theme.layout_fairh = layout_icon_path .. "fairh.png"
theme.layout_fairv = layout_icon_path .. "fairv.png"
theme.layout_floating = layout_icon_path .. "floating.png"
theme.layout_magnifier = layout_icon_path .. "magnifier.png"
theme.layout_max = layout_icon_path .. "max.png"
theme.layout_fullscreen = layout_icon_path .. "fullscreen.png"
theme.layout_tilebottom = layout_icon_path .. "tilebottom.png"
theme.layout_tileleft = layout_icon_path .. "tileleft.png"
theme.layout_tile = layout_icon_path .. "tile.png"
theme.layout_tiletop = layout_icon_path .. "tiletop.png"
theme.layout_spiral = layout_icon_path .. "spiral.png"
theme.layout_dwindle = layout_icon_path .. "dwindle.png"
theme.layout_cornernw = layout_icon_path .. "cornernw.png"
theme.layout_cornerne = layout_icon_path .. "cornerne.png"
theme.layout_cornersw = layout_icon_path .. "cornersw.png"
theme.layout_cornerse = layout_icon_path .. "cornerse.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(theme.menu_height, theme.bg_focus, theme.fg_focus)

theme.icon_theme = nil

return theme

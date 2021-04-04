--      ████████╗██╗  ██╗███████╗███╗   ███╗███████╗
--      ╚══██╔══╝██║  ██║██╔════╝████╗ ████║██╔════╝
--         ██║   ███████║█████╗  ██╔████╔██║█████╗
--         ██║   ██╔══██║██╔══╝  ██║╚██╔╝██║██╔══╝
--         ██║   ██║  ██║███████╗██║ ╚═╝ ██║███████╗
--         ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚══════╝

-- ===================================================================
-- Initialization
-- ===================================================================


local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

-- define module table
local theme = {}
local beautiful = require("beautiful")


-- ===================================================================
-- Theme Variables
-- ===================================================================


theme.name = "pastel"

-- Font
theme.font = "SF Pro Text 9"
theme.title_font = "SF Pro Display Medium 10"

-- Background
theme.background = "#212121e6"
theme.transparent = "#212121e6"
theme.bg_normal = "#212121"
theme.bg_dark = "#151515"
theme.bg_active = "#303030"
theme.bg_focus = "#444444e6"
theme.bg_urgent = "#ed827440"
theme.bg_minimize = "#313131e6"

-- Foreground
theme.fg_normal = "#ffffff"
theme.fg_focus = "#e4e4e4"
theme.fg_urgent = "#ffffff"
theme.fg_minimize = "#ffffff"

-- Window Gap Distance
theme.useless_gap = dpi(7)

-- Show Gaps if Only One Client is Visible
theme.gap_single_client = true

-- Window Borders
theme.border_width = dpi(1)
theme.border_normal = "#444444"
theme.border_focus = "#eeeeee"
theme.border_marked = "#ed8274"

-- Taglist
--
theme.taglist_bg_empty = "#21212100"
theme.taglist_bg_occupied = "#3939391a"
theme.taglist_bg_urgent = theme.bg_urgent
theme.taglist_bg_focus = "#ffffff1a"
-- Tasklist
theme.tasklist_font = theme.font

theme.tasklist_bg_normal = "#30303000"
theme.tasklist_bg_focus = theme.bg_focus
theme.tasklist_bg_urgent = theme.bg_urgent

theme.tasklist_fg_focus = theme.fg_focus
theme.tasklist_fg_urgent = theme.fg_urgent
theme.tasklist_fg_normal = theme.fg_normal

-- Panel Sizing
theme.left_panel_width = dpi(55)
theme.top_panel_height = dpi(26)

-- Notification Sizing
theme.notification_max_width = dpi(350)

-- System Tray
theme.bg_systray = "#354A50"
theme.systray_icon_spacing = dpi(10)

-- Titlebars
theme.titlebars_enabled = false


-- ===================================================================
-- Icons
-- ===================================================================


-- Define layout icons
theme.layout_tile = "~/.config/awesome/icons/layouts/tiled.png"
theme.layout_tileleft = "~/.config/awesome/icons/layouts/tiledleft.png"
theme.layout_fairh = "~/.config/awesome/icons/layouts/fairh.png"
theme.layout_floating = "~/.config/awesome/icons/layouts/floating.png"
theme.layout_max = "~/.config/awesome/icons/layouts/maximized.png"

--theme.icon_theme = "Tela-dark"

-- return theme
return theme

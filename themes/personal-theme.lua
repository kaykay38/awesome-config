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
-- local beautiful = require("beautiful")

-- ===================================================================
-- Theme Variables
-- ===================================================================


theme.name = "personal"

-- Font
theme.font = "NotoSans Nerd Font 12"
theme.title_font = "NotoSans Nerd Font 12"

-- Background
theme.background = "#21212199"
-- theme.transparent = "#212121b3"
theme.bg_normal = "#212121a6"
theme.bg_active = "#32323299"
theme.bg_focus = "#44444499"
theme.bg_urgent = "#ed827499"
theme.bg_minimize = "#10101040"

-- Foreground
theme.fg_normal = "#eeeeee"
theme.fg_focus = "#ffffff"
theme.fg_urgent = "#ffffff"
theme.fg_minimize = "#dcdcdc"

-- Window Gap Distance
theme.useless_gap = dpi(7)

-- Show Gaps if Only One Client is Visible
theme.gap_single_client = true

-- Window Borders
theme.border_width = dpi(2)
theme.border_normal = "#393939"
theme.border_focus = "#999999"
theme.border_marked = "#ed8274"

-- Taglist
--
theme.taglist_bg_empty = "#21212100"
theme.taglist_bg_occupied = "#99999959"
theme.taglist_bg_urgent = theme.bg_urgent
theme.taglist_bg_focus = "#ffffff59"

-- Tasklist
theme.tasklist_font = theme.font

theme.tasklist_bg_normal = "#21212126"
theme.tasklist_bg_focus = "#77777799"
theme.tasklist_bg_urgent = theme.bg_urgent

theme.tasklist_fg_normal = "999999"
theme.tasklist_fg_focus = "ffffff"
theme.tasklist_fg_urgent = theme.fg_urgent

-- Panel Sizing
theme.top_panel_height = dpi(28)

-- Notification Sizing
theme.notification_max_width = dpi(350)

-- System Tray
theme.bg_systray = "#505052"
theme.systray_icon_spacing = dpi(10)

-- Titlebars
theme.titlebars_enabled = false

-- ===================================================================
-- Icons
-- ===================================================================


-- Define layout icons
theme.layout_tileright = "~/.config/awesome/icons/layouts/tile.png"
theme.layout_tile = "~/.config/awesome/icons/layouts/tile.png"
theme.layout_tileleft = "~/.config/awesome/icons/layouts/tileleft.png"
theme.layout_fairv = "~/.config/awesome/icons/layouts/fairv.png"
theme.layout_floating = "~/.config/awesome/icons/layouts/floating.png"
theme.layout_max = "~/.config/awesome/icons/layouts/maximized.png"

theme.icon_theme = "ePapirus"

return theme

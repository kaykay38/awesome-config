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
-- theme.background = "#21212199"
-- theme.bg_normal = "#212121a6"
-- theme.bg_active = "#32323299"
-- theme.bg_focus = "#44444499"
-- theme.bg_urgent = "#ed827499"
-- theme.bg_minimize = "#18181899"
theme.bg_normal = "#414141"
theme.bg_active = "#505050"
theme.bg_focus = "#575757"
theme.bg_urgent = "#ed8274"
theme.bg_minimize = "#393939"

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
theme.border_normal = "#414141"
theme.border_focus = "#888888"
theme.border_marked = "#ed8274"

-- Taglist
--
theme.taglist_bg_empty = "#21212100"
-- theme.taglist_bg_empty = theme.bg_normal
theme.taglist_bg_occupied = "#99999959"
-- theme.taglist_bg_occupied = theme.bg_active
theme.taglist_bg_urgent = theme.bg_urgent
theme.taglist_bg_focus = "#cccccc59"
-- theme.taglist_bg_focus = theme.bg_focus

-- Tasklist
theme.tasklist_font = theme.font

theme.tasklist_bg_normal = theme.bg_normal
-- theme.tasklist_bg_focus = "#77777799"
theme.tasklist_bg_focus = "#77777799"
theme.tasklist_bg_urgent = theme.bg_urgent

-- theme.tasklist_fg_normal = "999999"
-- theme.tasklist_fg_focus = "ffffff"
theme.tasklist_fg_normal = theme.fg_normal
theme.tasklist_fg_focus = theme.fg_focus
theme.tasklist_fg_urgent = theme.fg_urgent

-- Panel Sizing
theme.top_panel_height = dpi(28)

-- Notification Sizing
theme.notification_max_width = dpi(350)

-- System Tray
-- theme.bg_systray = "#21212199"
theme.bg_systray = theme.bg_normal
theme.systray_icon_spacing = dpi(10)

-- Titlebars
theme.titlebars_enabled = false

-- ===================================================================
-- Icons
-- ===================================================================


-- Define layout icons
theme.layout_tile = "~/.config/awesome/icons/layouts/tile.png"
theme.layout_tileleft = "~/.config/awesome/icons/layouts/tileleft.png"
theme.layout_fairh = "~/.config/awesome/icons/layouts/fairh.png"
theme.layout_floating = "~/.config/awesome/icons/layouts/floating.png"
theme.layout_max = "~/.config/awesome/icons/layouts/maximized.png"

--theme.icon_theme = "Tela-dark"

return theme

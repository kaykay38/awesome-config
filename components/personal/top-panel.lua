--      ████████╗ ██████╗ ██████╗     ██████╗  █████╗ ███╗   ██╗███████╗██╗
--      ╚══██╔══╝██╔═══██╗██╔══██╗    ██╔══██╗██╔══██╗████╗  ██║██╔════╝██║
--         ██║   ██║   ██║██████╔╝    ██████╔╝███████║██╔██╗ ██║█████╗  ██║
--         ██║   ██║   ██║██╔═══╝     ██╔═══╝ ██╔══██║██║╚██╗██║██╔══╝  ██║
--         ██║   ╚██████╔╝██║         ██║     ██║  ██║██║ ╚████║███████╗███████╗
--         ╚═╝    ╚═════╝ ╚═╝         ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝

-- ===================================================================
-- Initialization
-- ===================================================================


local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local dpi = beautiful.xresources.apply_dpi
-- import widgets
local task_list = require("widgets.task-list")
local tag_list = require("widgets.tag-list_horizontal")
-- local tag_list = require("widgets.tag-list")


-- define module table
local top_panel = {}


-- ===================================================================
-- Bar Creation
-- ===================================================================

top_panel.create = function(s)
    local panel = awful.wibar({
        screen = s,
        position = "top",
        ontop = true,
        height = beautiful.top_panel_height,
        width = s.geometry.width,
        -- bg = "#21212199" --50% opacity
    })

    panel:setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            wibox.layout.margin(require("widgets.layout-box"), dpi(6), dpi(6), dpi(6), dpi(6)),
            tag_list.create(s),
        },
        task_list.create(s),
        {
            layout = wibox.layout.fixed.horizontal,
            wibox.layout.margin(wibox.widget.systray({opacity = 0}), dpi(5), dpi(6), dpi(4), dpi(4)),
            -- wibox.widget.systray({forced_height = 10, forced_width = 10, opacity = 0}),
            require("widgets.player")({
                font = beautiful.font
            }),
            -- require("widgets.playerctl"),
            require("widgets.weather"),
            require("widgets.vpn"),
            require("widgets.network")(),
            require("widgets.wifi")(),
            require("widgets.dictation"),
            wibox.layout.margin(require("widgets.calendar").create(s), dpi(5), dpi(5), dpi(5), dpi(5)),
        }
    }


    -- ===================================================================
    -- Functionality
    -- ===================================================================


    -- hide panel when client is fullscreen
    local function change_panel_visibility(client)
        if client.screen == s then
            panel.ontop = not client.fullscreen
        end
    end

    -- connect panel visibility function to relevant signals
    client.connect_signal("property::fullscreen", change_panel_visibility)
    client.connect_signal("focus", change_panel_visibility)

end

return top_panel

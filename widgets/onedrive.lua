----------------------------------------------------------------------------
--- OneDrive Widget
--
-- Depends: systemd, onedrive
--
--
-- @author kaykay38
-- @copyright 2021 kaykay38
-- @widget onedrive
----------------------------------------------------------------------------

local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi
local clickable_container = require('widgets.clickable-container')
local watch = require("awful.widget.watch")

local onedrive_widget = wibox.widget{
    widget = wibox.widget.textbox,
    font = "13"
}

local widget_button = wibox.widget {
    {
        onedrive_widget,
        margins = dpi(0),
        widget = wibox.container.margin
    },
    widget = clickable_container
}

widget_button:buttons(
    gears.table.join(
        awful.button({}, 1, nil,
            function()
                awful.spawn("alacritty -e journalctl --user-unit onedrive -n 50", false)
            end
        )
    )
)

local onedrive_tooltip = awful.tooltip {
    text = 'Loading...',
    objects = {widget_button},
    mode = 'outside',
    align = 'right',
    preferred_positions = {'left', 'right', 'top', 'bottom'},
    margin_leftright = dpi(8),
    margin_topbottom = dpi(8)
}

-- Update tooltip
local update_tooltip = function()
    awful.spawn.easy_async_with_shell(
        [[
        journalctl --user-unit onedrive -n 5 | tail -n 1
        ]],
        function(stdout)
            if stdout == nil or stdout == "" then
                onedrive_tooltip:set_markup("OneDrive is disconnected")
            end
        onedrive_tooltip:set_markup(stdout)
        end
    )
end

watch("/home/mia/.config/awesome/widgets/onedrive.sh", 1,
    function(_, stdout)
        onedrive_widget.text = stdout
        update_tooltip()
      collectgarbage("collect")
    end,
    onedrive_widget
)

return widget_button

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
    font = "14"
}

local widget_button = wibox.widget {
    {
        onedrive_widget,
        margins = dpi(2),
        widget = wibox.container.margin
    },
    widget = clickable_container
}

widget_button:buttons(
    gears.table.join(
        awful.button({}, 1, nil,
            function()
                awful.spawn("alacritty -e onedrive-log", false)
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
    margin_leftright = dpi(5),
}

-- Update tooltip
local update_tooltip = function()
    -- journalctl --user-unit onedrive -n 1 | tail -n 1 | sed 's/YOURHOSTNAME .*\[.*\]: /| /'
    awful.spawn.easy_async_with_shell(
        [[
        journalctl --user-unit onedrive -n 1 | tail -n 1 | sed 's#ArchAMDpc .*\[.*\]:#| #'
        ]],
        function(stdout)
            if stdout == nil or stdout == "" then
                onedrive_tooltip:set_markup("OneDrive is disconnected")
            end
        onedrive_tooltip:set_markup(stdout)
        end
    )
end

watch("/home/mia/.config/awesome/widgets/onedrive.sh", 5,
    function(_, stdout)
        onedrive_widget.text = stdout
        update_tooltip()
      collectgarbage("collect")
    end,
    onedrive_widget
)

return widget_button

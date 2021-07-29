----------------------------------------------------------------------------
--- Weather Widget
--
-- Depends: sb-weather, curl
--
--
-- @author kaykay38
-- @copyright 2021 kaykay38
-- @widget weather
----------------------------------------------------------------------------

local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi
local clickable_container = require('widgets.clickable-container')
local watch = require("awful.widget.watch")

local weather_widget = wibox.widget{
    widget = wibox.widget.textbox,
    font = "NotoSans Nerd Font 10.5"
}

local widget_button = wibox.widget {
    {
        weather_widget,
        margins = dpi(0),
        widget = wibox.container.margin
    },
    widget = clickable_container
}

widget_button:buttons(
    gears.table.join(
        awful.button({}, 1, nil,
            function()
                awful.spawn("xdg-open https://weather.com/weather/today/l/Spokane+WA?canonicalCityId=784528c5dca98e8cd5ea2ce0c075e263b2c1b9d2f03d3942f5cad896e2276751", false)
            end
        )
    )
)

local weather_tooltip = awful.tooltip {
    text = 'Spokane, WA current weather',
    objects = {widget_button},
    mode = 'outside',
    align = 'right',
    preferred_positions = {'left', 'right', 'top', 'bottom'},
    margin_leftright = dpi(5),
    margin_topbottom = dpi(5)
}

-- Update tooltip
-- local update_tooltip = function()
--     -- journalctl --user-unit onedrive -n 1 | tail -n 1 | sed 's/YOURHOSTNAME .*\[.*\]: /| /'
--     awful.spawn.easy_async_with_shell(
--         [[
--         journalctl --user-unit onedrive -n 1 | tail -n 1 | sed 's/ArchLinuxAMDpc .*\[.*\]: /| /'
--         ]],
--         function(stdout)
--             if stdout == nil or stdout == "" then
--                 onedrive_tooltip:set_markup("OneDrive is disconnected")
--             end
--         weather_tooltip:set_markup(stdout)
--         end
--     )
-- end

watch("/usr/local/bin/awm-weather", 300,
    function(_, stdout)
        weather_widget.text = stdout
        -- update_tooltip()
      collectgarbage("collect")
    end,
    weather_widget
)

return widget_button

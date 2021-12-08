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
-- local beautiful = require('beautiful')

local location = {"Spokane","WA"}
-- local location = {"Yiyang","Hunan"}
local url = "https://weather.com/weather/today/l/Spokane+WA?canonicalCityId=784528c5dca98e8cd5ea2ce0c075e263b2c1b9d2f03d3942f5cad896e2276751"
-- local url="https://weather.com/weather/today/l/Yiyang+Hunan+People's+Republic+of+China?canonicalCityId=f384de187fe2a6b51324439f3344f9d716a3842d48e581bf2333a003c62f860b"

local weather_widget = wibox.widget{
    widget = wibox.widget.textbox,
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
                awful.spawn('xdg-open "'..url..'"', false)
            end
        )
        -- awful.button({}, 2, nil,
        --     function()
        --         awful.spawn("", false)
        --     end
        -- )

    )
)

local weather_tooltip = awful.tooltip {
    text = location[1]..", "..location[2]..' current weather',
    objects = {widget_button},
    mode = 'outside',
    align = 'right',
    preferred_positions = {'left', 'right', 'top', 'bottom'},
    margin_leftright = dpi(5),
    margin_topbottom = dpi(5)
}

watch("awm-weather".." "..location[1]..' "'..url..'"', 300,
    function(_, stdout)
        weather_widget.text = stdout
        -- update_tooltip()
      collectgarbage("collect")
    end,
    weather_widget
)

return widget_button

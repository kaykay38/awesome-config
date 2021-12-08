----------------------------------------------------------------------------
--- Dictation Widget
--
-- Depends: awm-dictation-mic, dictation-toggle, pgrep
--
--
-- @author kaykay38
-- @copyright 2021 kaykay38
-- @widget dictation
----------------------------------------------------------------------------

local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi
local clickable_container = require('widgets.clickable-container')
local watch = require("awful.widget.watch")

local dictation_widget = wibox.widget{
    widget = wibox.widget.textbox,
    font = "14"
}

local widget_button = wibox.widget {
    {
        dictation_widget,
        margins = dpi(3),
        widget = wibox.container.margin
    },
    widget = clickable_container
}

widget_button:buttons(
    gears.table.join(
        awful.button({}, 1, nil,
            function()
                awful.spawn("dictation-toggle", false)
            end
        )
    )
)

watch("awm-dictation-mic", 1,
    function(_, stdout)
    if stdout == "" then
        dictation_widget.text = ""
        widget_button.widget.margins = dpi(0)
        dictation_widget.margins = dpi(0)
        widget_button.margins = dpi(0)
    else
        widget = wibox.container.margin
        dictation_widget.text = stdout
        widget_button.widget.margins = dpi(6)
        dictation_widget.margins = dpi(5)
        widget_button.margins = dpi(5)
    end
      collectgarbage("collect")
    end,
    dictation_widget
)


return widget_button

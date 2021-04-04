-- ===================================================================
-- Initialization
-- ===================================================================
local awful = require('awful')
local wibox = require('wibox')
local watch = awful.widget.watch

local vpn_widget = wibox.widget.textbox()

local leftpadding = 0
local rightpadding = 0
local toppadding = 0
local bottompadding = 0

watch("ip addr show tun0", 2,
    function(_, stdout)
        if(stdout == '' or stdout==nil or stdout == 'Device \"tun0\" does not exist.') then
            vpn_widget.text = ""
            leftpadding = 0
            rightpadding = 0
            toppadding = 0
            bottompadding = 0
        else
            vpn_widget.font = "11.5"
            vpn_widget.text = "ﱾ"
            leftpadding = 10
            rightpadding = 10
            toppadding = 5
            bottompadding = 5

        end
          collectgarbage("collect")
    end,
    vpn_widget
)

return wibox.layout.margin(vpn_widget, leftpadding, rightpadding, toppadding, bottompadding)

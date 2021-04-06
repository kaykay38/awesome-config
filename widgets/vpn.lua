----------------------------------------------------------------------------
--- VPN Widget
--
-- Depends: ip
--
--
-- @author kaykay38
-- @copyright 2021 kaykay38
-- @widget vpn
----------------------------------------------------------------------------
local awful = require('awful')
local wibox = require('wibox')
local watch = awful.widget.watch
local dpi = require('beautiful').xresources.apply_dpi

local vpn_widget = wibox.widget {
    widget = wibox.widget.textbox,
    font = "11.5"
}
local vpn_button = wibox.widget {
    vpn_widget,
    widget = wibox.container.margin
}

watch("ip addr show tun0", 2,
    function(_, stdout)
        if(stdout == '' or stdout==nil or stdout == 'Device \"tun0\" does not exist.') then
            vpn_widget.text = ""
            vpn_button.margins = dpi(0)
        else
            vpn_widget.text = "ﱾ"
            vpn_button.margins = dpi(7)

        end
          collectgarbage("collect")
    end,
    vpn_widget
)

return vpn_button

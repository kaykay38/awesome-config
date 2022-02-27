----------------------------------------------------------------------------
--- VPN Widget
--
-- Depends: ip
--
-- @author kaykay38
-- @copyright 2021 kaykay38
-- @widget vpn
----------------------------------------------------------------------------
-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require('awful')
local wibox = require('wibox')
local dpi = require('beautiful').xresources.apply_dpi
local clickable_container = require('widgets.clickable-container')


-- ===================================================================
-- Appearance & Functionality
-- ===================================================================


local vpn_widget = wibox.widget {
    widget = wibox.widget.textbox,
    text = " ﱾ ",
    font = "11.5",
}

local vpn_button = wibox.widget {
    {
        vpn_widget,
        margins = dpi(1),
        widget = wibox.container.margin
    },
    widget = clickable_container,
    visible = false
}

-- show/hide vpn icon when "vpn_change" signal is emitted
awesome.connect_signal("vpn_change",
   function()

      awful.spawn.easy_async_with_shell(
		 "ip addr show tun0",
         function(stdout)
            if(stdout == '' or stdout==nil or stdout == 'Device \"tun0\" does not exist.') then
                vpn_button.visible = true
            else
                vpn_button.visible = false

            end
        end,
         false
      )
   end
)

return vpn_button

----------------------------------------------------------------------------
--- Simple Network Widget
--
-- Depends: iproute2, iw
--
--
-- @author manilarome &lt;gerome.matilla07@gmail.com&gt; kaykay38
-- @copyright 2020 manilarome, 2021 kaykay38
-- @widget network
----------------------------------------------------------------------------

local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local naughty = require('naughty')
local dpi = require('beautiful').xresources.apply_dpi
local clickable_container = require('widgets.clickable-container')

local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'icons/network/'

local network_mode = nil

local return_button = function()

	local update_notify_no_access = true
	local notify_no_access_quota = 0

	local startup = true
	local reconnect_startup = true
	local notify_new_wifi_conn = false

	local widget = wibox.widget {
		{
			id = 'icon',
			image = widget_icon_dir .. 'loading.svg',
			widget = wibox.widget.imagebox,
			resize = true
		},
		layout = wibox.layout.align.horizontal
	}

	local widget_button = wibox.widget {
		{
			widget,
			margins = dpi(7),
			widget = wibox.container.margin
		},
		widget = clickable_container
	}
	
	widget_button:buttons(
		gears.table.join(
			awful.button({}, 1, nil,
				function()
					awful.spawn(apps.network_manager, false)
				end
			)
		)
	)

	local network_tooltip = awful.tooltip {
		text = 'Loading...',
		objects = {widget_button},
		mode = 'outside',
		align = 'right',
		preferred_positions = {'left', 'right', 'top', 'bottom'},
		margin_leftright = dpi(8),
		margin_topbottom = dpi(8)
	}

	local check_internet_health = [=[
	status_ping=0

	packets="$(ping -q -w2 -c2 example.com | grep -o "100% packet loss")"
	if [ ! -z "${packets}" ];
	then
		status_ping=0
	else
		status_ping=1
	fi

	if [ $status_ping -eq 0 ];
	then
		echo 'Connected but no internet'
	fi
	]=]

	-- Awesome/System startup
	local update_startup = function()
		if startup then
			startup = false
		end
	end

	-- Consider reconnecting a startup
	local update_reconnect_startup = function(status)
		reconnect_startup = status
	end

	-- Update tooltip
	local update_tooltip = function(message)
		network_tooltip:set_markup(message)
	end

	local network_notify = function(message, title, app_name, icon)
		naughty.notify({
			message = message,
			title = title,
			app_name = app_name,
			icon = icon
		})
	end

	local update_wired = function()

		network_mode = 'wired'

		local notify_connected = function()
			local message = 'Connected to internet with <b>\"' .. network_interfaces.lan .. '\"</b>'
			local title = 'Connection Established'
			local app_name = 'System Notification'
			local icon = widget_icon_dir .. 'wired.svg'
			network_notify(message, title, app_name, icon)
		end

		awful.spawn.easy_async_with_shell(
			check_internet_health,
			function(stdout)

				local widget_icon_name = 'wired'
				
				if stdout:match('Connected but no internet') then
					widget_icon_name = widget_icon_name .. '-alert'
					update_tooltip(
						'<b>Connected but no internet!</b>' ..
						'\nEthernet Interface: <b>' .. network_interfaces.lan .. '</b>'
					)
				else
					update_tooltip('Ethernet Interface: <b>' .. network_interfaces.lan .. '</b>')
					if startup or reconnect_startup then
						awesome.emit_signal('system::network_connected')
						notify_connected()
						update_startup(false)
					end
					update_reconnect_startup(false)
				end
				widget.icon:set_image(widget_icon_dir .. widget_icon_name .. '.svg')
			end
		)
	end

	local update_disconnected = function()

		local notify_wired_disconnected = function(essid)
			local message = 'Ethernet has been disconnected'
			local title = 'Connection Disconnected'
			local app_name = 'System Notification'
			local icon = widget_icon_dir .. 'wired-off.svg'
			network_notify(message, title, app_name, icon)
		end

		local widget_icon_name = 'wired-off'

		if network_mode == 'wired' then
			widget_icon_name = 'wired-off'
			if not reconnect_startup then
				update_reconnect_startup(true)
				notify_wired_disconnected()
			end
		end
		update_tooltip('Ethernet disconnected')
		widget.icon:set_image(widget_icon_dir .. widget_icon_name .. '.svg')
	end

	local check_network_mode = function()
		awful.spawn.easy_async_with_shell(
			[=[
			wireless="]=] .. tostring(network_interfaces.wlan) .. [=["
			wired="]=] .. tostring(network_interfaces.lan) .. [=["
			net="/sys/class/net/"

			wired_state="down"
			wireless_state="down"
			network_mode=""

			# Check network state based on interface's operstate value
			function check_network_state() {
				# Check what interface is up
				if [[ "${wired_state}" == "up" ]];
				then
					network_mode='wired'
				else
					network_mode='No internet connection'
				fi
			}

			# Check if network directory exist
			function check_network_directory() {
				if [[ -n "${wired}" && -d "${net}${wired}" ]]; then
					wired_state="$(cat "${net}${wired}/operstate")"
				fi
				check_network_state
			}

			# Start script
			function print_network_mode() {
				# Call to check network dir
				check_network_directory
				# Print network mode
				printf "${network_mode}"
			}

			print_network_mode

			]=],
			function(stdout)
				local mode = stdout:gsub('%\n', '')
				if stdout:match('No internet connection') then
					update_disconnected()
				elseif stdout:match('wired') then
					update_wired()
				end
			end
		)
	end

	local network_updater = gears.timer {
		timeout = 5,
		autostart = true,
		call_now = true,
		callback = function()
			check_network_mode()
		end	
	}

	return widget_button
end

return return_button

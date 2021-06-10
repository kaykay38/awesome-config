----------------------------------------------------------------------------
--- Playerctl Widget
--
-- Depends: playerctl, sb-playerctl
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

local playerctl_widget = wibox.widget{
    widget = wibox.widget.textbox,
	font = 'NotoSans Nerd Font 10'
}

local widget_button = wibox.widget {
    {
        playerctl_widget,
        margins = dpi(0),
        widget = wibox.container.margin
    },
    widget = clickable_container
}

widget_button:buttons(
    gears.table.join(
        awful.button({}, 1, nil,
            function()
                awful.spawn("playerctl --player=spotify,mpv,%any play-pause", false)
            end
        ),
        awful.button({}, 3, nil,
            function()
                awful.spawn("playerctl-info", false)
            end
        ),
        awful.button({}, 4, nil,
            function()
                awful.spawn("playerctl --player=spotify,mpv,%any next", false)
            end
        ),
        awful.button({}, 5, nil,
            function()
                awful.spawn("playerctl --player=spotify,mpv,%any previous", false)
            end
        )
    )
)

local widget_tooltip = awful.tooltip {
    text = 'Loading...',
    objects = {widget_button},
    mode = 'outside',
    align = 'right',
    preferred_positions = {'left', 'right', 'top', 'bottom'},
    margin_leftright = dpi(8),
    margin_topbottom = dpi(8)
}

local cur_title = nil
local cur_artist = nil
local cur_album = nil
-- Update tooltip
local update_tooltip = function()
    -- journalctl --user-unit onedrive -n 1 | tail -n 1 | sed 's/YOURHOSTNAME .*\[.*\]: /| /'
    awful.spawn.easy_async_with_shell(
        [[
			playerctl --player=spotify,mpv,%any metadata --format "{{title}}\n{{artist}}\n{{album}}"
        ]],
        function(stdout)
            if stdout ~= nil or stdout ~= "" then
				local escaped = string.gsub(stdout, "&", '&amp;')
				local title, artist, album = string.match(escaped, '(.*)\\n(.*)\\n(.*)')
				-- local title, artist, album = string.match(stdout, '(.*)\n(.*)\n(.*)')
				if title ~=nil then
					cur_title = title
				end
				if artist ~= nil then
					cur_artist = artist
				end
				if album ~= nil then
					cur_album = album
				end
            end
			playerctl_widget:connect_signal('mouse::enter',
				function()
					if cur_album ~= "" and cur_album ~= nil and
						cur_artist ~= "" and cur_artist ~= nil and
						cur_title ~= "" and cur_title ~= nil then
						widget_tooltip.markup = '<b>Title</b>: ' .. cur_title
						.. '\n<b>Artist</b>: ' .. cur_artist
						.. '\n<b>Album</b>: ' .. cur_album
					elseif cur_artist ~= "" and cur_artist ~= nil and
						cur_title ~= "" and cur_title ~= nil then
						widget_tooltip.markup = '<b>Title</b>: ' .. cur_title
						.. '\n<b>Artist</b>: ' .. cur_artist
					elseif cur_title ~= "" and cur_title ~= nil then
						widget_tooltip.markup = '<b>Title</b>: ' .. cur_title
					end
				end
			)
		end
	)
end

watch("/usr/local/bin/sb-playerctl", 1,
    function(_, stdout)
        playerctl_widget.text = stdout
        update_tooltip()
      collectgarbage("collect")
    end,
    playerctl_widget
)

return widget_button

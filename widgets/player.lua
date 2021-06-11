-------------------------------------------------
-- Media Widget for Awesome Window Manager
-- Shows metadata for currently playing video/audio

-- Dependencies: playerctl, playerstatus & tooltip-playerctl scripts

-- Adapted from https://github.com/streetturtle/awesome-wm-widgets/tree/master/spotify-widget

-- @author kaykay38, Pavel Makhov
-------------------------------------------------

local awful = require("awful")
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local dpi = require('beautiful').xresources.apply_dpi
local clickable_container = require('widgets.clickable-container')

local GET_STATUS_CMD = '/usr/local/bin/playerstatus'
local GET_CURRENT_SONG_CMD = '/usr/local/bin/tooltip-playerctl'

local function ellipsize(text, length)
    return (text:len() > length and length > 0)
        and text:sub(0, length - 3) .. '...'
        or text
end

local player_widget = {}
local widget_button = {}

local function worker(user_args)

    local args = user_args or {}

    local spotify_play_icon = args.spotify_play_icon or '/home/mia/.config/awesome/icons/spotify.svg'
    local spotify_pause_icon = args.spotify_pause_icon or '/home/mia/.config/awesome/icons/spotify-gray.svg'
    local mpv_play_icon = args.mpv_play_icon or '/home/mia/.config/awesome/icons/mpv.svg'
    local mpv_pause_icon = args.mpv_pause_icon or '/home/mia/.config/awesome/icons/mpv-gray.svg'
    local play_icon = args.mpv_play_icon or '/home/mia/.config/awesome/icons/play.svg'
    local pause_icon = args.mpv_pause_icon or '/home/mia/.config/awesome/icons/pause.svg'

    local font = args.font or 'NotoSans Nerd Font 10'
    local dim_when_paused = args.dim_when_paused == nil and false or args.dim_when_paused
    local dim_opacity = args.dim_opacity or 0.2
    local title_max_length = args.title_max_length or 40
    local artist_max_length = args.artist_max_length or 25
    local show_tooltip = args.show_tooltip == nil and true or args.show_tooltip
    local timeout = args.timeout or 1

    local cur_artist = ""
    local cur_title = ""
    local cur_album = ""

    player_widget = wibox.widget {
        {
            id = 'icon',
            widget = wibox.widget.imagebox,
        },
        {
            id = 'artistw',
            font = font,
            widget = wibox.widget.textbox,
        },
        {
            id = 'titlew',
            font = font,
            widget = wibox.widget.textbox,
        },
        layout = wibox.layout.align.horizontal,

        set_status = function(self, current_player, is_playing)
            if current_player == "spotify" then
                if is_playing and spotify_play_icon then
                    self.icon.image = spotify_play_icon
                else
                    self.icon.image = spotify_pause_icon
                end
            elseif current_player == "mpv" then
                if is_playing and mpv_play_icon then
                    self.icon.image = mpv_play_icon
                else
                    self.icon.image = mpv_pause_icon
                end
            elseif current_player == "any" then
                if is_playing and play_icon then
                    self.icon.image = play_icon
                else
                    self.icon.image = pause_icon
                end
            end
            if dim_when_paused then
                self:get_children_by_id('icon')[1]:set_opacity(is_playing and 1 or dim_opacity)

                self:get_children_by_id('titlew')[1]:set_opacity(is_playing and 1 or dim_opacity)
                self:get_children_by_id('titlew')[1]:emit_signal('widget::redraw_needed')

                self:get_children_by_id('artistw')[1]:set_opacity(is_playing and 1 or dim_opacity)
                self:get_children_by_id('artistw')[1]:emit_signal('widget::redraw_needed')
            end
        end,

        set_text = function(self, artist, title)
            local artist_to_display = ""
            if artist ~= "" then
                artist_to_display = " " .. ellipsize(artist, artist_max_length) .. "  - "
            end
            if self:get_children_by_id('artistw')[1]:get_markup() ~= artist_to_display then
                self:get_children_by_id('artistw')[1]:set_markup(artist_to_display)
            end
            local title_to_display = ellipsize(title, title_max_length) .. " "
            if self:get_children_by_id('titlew')[1]:get_markup() ~= title_to_display then
                self:get_children_by_id('titlew')[1]:set_markup(title_to_display)
            end
        end
    }

    widget_button = {
        {
            player_widget,
            margins = dpi(2),
            widget = wibox.container.margin
        },
        widget = clickable_container
    }

    local update_widget_icon = function(widget, stdout, _, _, _)
        stdout = string.gsub(stdout, "\n", "")
        if string.match(stdout, 'no players') then
            widget:set_text('','')
            widget:set_visible(false)
            player_widget.margins = dpi(0);
            return
        end
        local current_player, status = string.match(stdout, '(.*)%s(.*)')
        widget:set_status(current_player, status == 'playing')
        widget:set_visible(true)
    end

    local update_widget_text = function(widget, stdout, _, _, _)
        stdout = string.gsub(stdout, "\n", "")
        if string.match(stdout, 'no players') then
            widget:set_text('','')
            widget:set_visible(false)
            player_widget.margins = dpi(0);
            return
        end

        -- local escaped = string.gsub(stdout, "&", '&amp;')
        local title, artist, album = string.match(stdout, '(.*)\\n(.*)\\n(.*)')
        if  title ~= "" and title ~=nil and not string.match(title,"^\r?\n$") then
            cur_title = title
			else cur_title = ""
        end
        if artist ~= "" and artist ~= nil and not string.match(artist,"^\r?\n$") then
            cur_artist = artist
			else cur_artist = ""
        end
        if album ~= "" and album ~= nil and not string.match(album,"^\r?\n$") then
            cur_album = album
			else cur_album = ""
        end
        widget:set_text(cur_artist, cur_title)
        widget:set_visible(true)
    end

    watch(GET_STATUS_CMD, timeout, update_widget_icon, player_widget)
    watch(GET_CURRENT_SONG_CMD, timeout, update_widget_text, player_widget)

    -- Adds mouse controls to the widget:
      -- left click - play/pause
      -- scroll down - play next song
      -- scroll up - play previous song
     player_widget:connect_signal("button::press", function(_, _, _, button)
         if (button == 1) then
             awful.spawn("playerctl --player=spotify,mpv,%any play-pause", false)      -- left click
         elseif (button == 3) then
             awful.spawn("playerctl-info", false)      -- right click
         elseif (button == 4) then
             awful.spawn("playerctl --player=spotify,mpv,%any next", false)  -- scroll down
         elseif (button == 5) then
             awful.spawn("playerctl --player=spotify,mpv,%any previous", false)  -- scroll up
         end
         awful.spawn.easy_async(GET_STATUS_CMD, function(stdout, stderr, exitreason, exitcode)
             update_widget_icon(player_widget, stdout, stderr, exitreason, exitcode)
         end)
     end)

    if show_tooltip then
        local player_tooltip = awful.tooltip {
            mode = 'outside',
            preferred_positions = {'bottom'},
         }

        player_tooltip:add_to_object(player_widget)

        player_widget:connect_signal('mouse::enter',
            function()
                if cur_album ~= nil and cur_album ~= "" and 
                   cur_artist ~= nil and cur_artist ~= "" and
                   cur_title ~= nil and cur_title ~= "" then
                    player_tooltip.markup = '<b>Title</b>: ' .. cur_title
                    .. '\n<b>Artist</b>: ' .. cur_artist
                    .. '\n<b>Album</b>: ' .. cur_album
              elseif cur_artist ~= nil and cur_artist ~= "" and
                   cur_title ~= nil and cur_title ~= "" then
                    player_tooltip.markup = '<b>Title</b>: ' .. cur_title
                    .. '\n<b>Artist</b>: ' .. cur_artist
                elseif cur_title ~= nil and cur_title ~= "" then
                    player_tooltip.markup = '<b>Title</b>: ' .. cur_title
                end
            end
        )
    end

    return widget_button

end

return setmetatable(player_widget, { __call = function(_, ...)
    return worker(...)
end })

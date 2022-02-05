--      ██╗  ██╗███████╗██╗   ██╗███████╗
--      ██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔════╝
--      █████╔╝ █████╗   ╚████╔╝ ███████╗
--      ██╔═██╗ ██╔══╝    ╚██╔╝  ╚════██║
--      ██║  ██╗███████╗   ██║   ███████║
--      ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝


-- ===================================================================
-- Initialization
-- ===================================================================


local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local hotkeys_popup = require("awful.hotkeys_popup")
-- Define mod keys
local modkey = "Mod4"
local altkey = "Mod1"

-- define module table
local keys = {}


-- ===================================================================
-- Movement Functions (Called by some keybinds)
-- ===================================================================


-- Move given client to given direction
local function move_client(c, direction)
   -- If client is floating, move to edge
   if c.floating or (awful.layout.get(mouse.screen) == awful.layout.suit.floating) then
      local workarea = awful.screen.focused().workarea
      if direction == "up" then
         c:geometry({nil, y = workarea.y + beautiful.useless_gap * 2, nil, nil})
      elseif direction == "down" then
         c:geometry({nil, y = workarea.height + workarea.y - c:geometry().height - beautiful.useless_gap * 2 - beautiful.border_width * 2, nil, nil})
      elseif direction == "left" then
         c:geometry({x = workarea.x + beautiful.useless_gap * 2, nil, nil, nil})
      elseif direction == "right" then
         c:geometry({x = workarea.width + workarea.x - c:geometry().width - beautiful.useless_gap * 2 - beautiful.border_width * 2, nil, nil, nil})
      end
   -- Otherwise swap the client in the tiled layout
   elseif awful.layout.get(mouse.screen) == awful.layout.suit.max then
      if direction == "up" or direction == "left" then
         awful.client.swap.byidx(-1, c)
      elseif direction == "down" or direction == "right" then
         awful.client.swap.byidx(1, c)
      end
   else
      awful.client.swap.bydirection(direction, c, nil)
   end
end


-- Resize client in given direction
local floating_resize_amount = dpi(20)
local tiling_resize_factor = 0.05

local function resize_client(c, direction)
   if awful.layout.get(mouse.screen) == awful.layout.suit.floating or (c and c.floating) then
      if direction == "up" then
         c:relative_move(0, 0, 0, -floating_resize_amount)
      elseif direction == "down" then
         c:relative_move(0, 0, 0, floating_resize_amount)
      elseif direction == "left" then
         c:relative_move(0, 0, -floating_resize_amount, 0)
      elseif direction == "right" then
         c:relative_move(0, 0, floating_resize_amount, 0)
      end
   else
      if direction == "up" then
         awful.client.incwfact(-tiling_resize_factor)
      elseif direction == "down" then
         awful.client.incwfact(tiling_resize_factor)
      elseif direction == "left" then
         awful.tag.incmwfact(-tiling_resize_factor)
      elseif direction == "right" then
         awful.tag.incmwfact(tiling_resize_factor)
      end
   end
end

-- raise focused client
local function raise_client()
   if client.focus then
      client.focus:raise()
   end
end


-- ===================================================================
-- Mouse bindings
-- ===================================================================


-- Mouse buttons on the desktop
keys.desktopbuttons = gears.table.join(
   -- left click on desktop to hide notification
   awful.button({}, 1,
      function ()
         naughty.destroy_all_notifications()
      end
   )
)

-- Mouse buttons on the client
keys.clientbuttons = gears.table.join(
   -- Raise client
   awful.button({}, 1,
      function(c)
         client.focus = c
         c:raise()
      end
   ),

   -- Move and Resize Client
   awful.button({modkey}, 1, awful.mouse.client.move),
   awful.button({modkey}, 3, awful.mouse.client.resize)
)


-- ===================================================================
-- Desktop Key bindings
-- ===================================================================


keys.globalkeys = gears.table.join(
   -- =========================================
   -- SPAWN APPLICATION KEY BINDINGS
   -- =========================================

   -- Spawn terminal
   awful.key({modkey}, "Return",
      function()
         awful.spawn(apps.tabbedTerminal)
      end,
      {description = "Default Terminal", group = "launcher"}
   ),

   -- Spawn tabbed terminal
   awful.key({modkey, "Control"}, "Return",
      function()
         awful.spawn(apps.terminal)
      end,
      {description = "Tabbed Default Terminal", group = "launcher"}
   ),

   -- Spawn alternate terminal
   awful.key({modkey, "Control", "Shift"}, "Return",
      function()
         awful.spawn("/usr/bin/kitty")
      end,
      {description = "Kitty Terminal", group = "launcher"}
   ),

   -- toggle dictation
   awful.key({modkey}, "/",
      function()
         awful.spawn("dictation-toggle")
         awesome.emit_signal("dictation_change")
      end,
      {description = "dictation toggle", group = "utilities"}
   ),

   -- launch rofi
   awful.key({altkey}, "space",
      function()
         awful.spawn(apps.launcher)
      end,
      {description = "Rofi", group = "launcher"}
   ),

   -- launch mpv playlists
   awful.key({modkey}, "p",
      function()
         awful.spawn("mpvplaylist")
      end,
      {description = "mpv playlists", group = "media"}
   ),

   -- launch mpv playlists
   awful.key({modkey}, "e",
      function()
         awful.spawn(apps.emoji_selector)
      end,
      {description = "emoji selector", group = "launcher"}
   ),

   -- show currently playing media
   awful.key({modkey, "Shift"}, "s",
      function()
         awful.spawn("playerctl-info")
      end,
      {description = "show currently playing media", group = "media"}
   ),

   -- launch rofi
   awful.key({modkey}, "r",
      function()
         awful.spawn(apps.run)
      end,
      {description = "Rofi run", group = "launcher"}
   ),

   -- launch shortcut keys cheatsheet
    awful.key({ modkey }, "s",
        hotkeys_popup.show_help,
    {description="show help", group="awesome"}
    ),

   -- launch browser
   awful.key({modkey, altkey}, "space",
      function()
         awful.spawn(apps.browser)
      end,
      {description = "Default Browser", group = "applications"}
   ),

   -- launch greenclip
   awful.key({modkey}, "v",
      function()
         awful.spawn(apps.greenclip)
      end,
      {description = "greenclip", group = "clipboard"}
   ),
   -- show spotify song cover
   awful.key({ modkey, }, "d",
        function ()
            awful.spawn("spotify-cover")
        end,
        {description = "Spotify song cover", group = "media"}
    ),

   -- toggle dual monitors
   awful.key({ modkey, "Shift"}, "d",
       function ()
           awful.spawn("/usr/local/bin/dual-horizontal-left-monitor")
       end,
       {description = "toggle left vertical monitor", group = "screen"}
   ),

   -- toggle bluetooth
   awful.key({modkey}, "b",
      function()
         awful.spawn("/usr/local/bin/bluetooth")
      end,
      {description = "toggle bluetooth", group = "system"}
   ),

   -- launch Pavucontrol
   awful.key({modkey, "Shift"}, "m",
      function()
         awful.spawn(apps.audio_mixer)
      end,
      {description = "Pavucontrol", group = "applications"}
   ),

   -- launch Canvas
   awful.key({modkey, altkey}, "Return",
      function()
         awful.spawn(apps.browser.." https://canvas.ewu.edu/")
      end,
      {description = "Canvas", group = "applications"}
   ),

   -- launch Youtube
   awful.key({modkey}, "F1",
      function()
         awful.spawn(apps.browser.." https://youtube.com/")
      end,
      {description = "Youtube", group = "applications"}
   ),

   -- launch file browser
   awful.key({modkey}, "F2",
      function()
         awful.spawn(apps.file_browser)
      end,
      {description = "pcmanfm file browser", group = "applications"}
   ),

   -- launch EWU VPN
   awful.key({modkey}, "F3",
      function()
         awful.spawn(apps.vpn)
         awesome.emit_signal("vpn_change")
      end,
      {description = "EWU VPN", group = "system"}
   ),

   -- launch Discord
   awful.key({modkey}, "F4",
      function()
         awful.spawn("discord")
      end,
      {description = "Discord", group = "applications"}
   ),

   -- launch Spotify
    awful.key({ modkey, altkey }, "s",
      function()
         awful.spawn("spotify")
      end,
      {description="Spotify", group="media"}
     ),

   awful.key({modkey, "Shift"}, "u",
      function()
         awful.spawn("dmenuumount", false)
      end,
      {description = "mount drives (dmenu)", group = "utilities"}
   ),
   awful.key({modkey}, "u",
      function()
         awful.spawn("dmenumount", false)
      end,
      {description = "unmount drives (dmenu)", group = "utilities"}
   ),
   -- =========================================
   -- FUNCTION KEYS
   -- =========================================

   -- Brightness
   awful.key({}, "XF86MonBrightnessUp",
      function()
         awful.spawn("xbacklight -inc 10", false)
      end,
      {description = "+10%", group = "function keys"}
   ),
   awful.key({}, "XF86MonBrightnessDown",
      function()
         awful.spawn("xbacklight -dec 10", false)
      end,
      {description = "-10%", group = "function keys"}
   ),

   -- Pulseaudio volume control
   awful.key({}, "XF86AudioRaiseVolume",
      function()
         awful.spawn("awm-volume-up", false)
         awesome.emit_signal("volume_change")
      end,
      {description = "volume up", group = "function keys"}
   ),
   awful.key({}, "XF86AudioLowerVolume",
      function()
         awful.spawn("awm-volume-down", false)
         awesome.emit_signal("volume_change")
      end,
      {description = "volume down", group = "function keys"}
   ),
   awful.key({}, "XF86AudioMute",
      function()
         awful.spawn("pamixer -t", false)
         awesome.emit_signal("volume_change")
      end,
      {description = "toggle mute", group = "function keys"}
   ),
   awful.key({}, "XF86AudioNext",
      function()
         awful.spawn("playerctl --player=spotify,spotifyd,mpv,%any next", false)
      end,
      {description = "next music", group = "function keys"}
   ),
   awful.key({}, "XF86AudioPrev",
      function()
         awful.spawn("playerctl --player=spotify,spotifyd,mpv,%any previous", false)
      end,
      {description = "previous music", group = "function keys"}
   ),
   awful.key({}, "XF86AudioPlay",
      function()
         awful.spawn("playerctl --player=spotify,spotifyd,mpv,%any play-pause", false)
      end,
      {description = "play/pause music", group = "function keys"}
   ),

   -- =========================================
   -- SCREENSHOTS
   -- =========================================

   --Screenshot on prtscn using scrot
   awful.key({}, "Print",
      function()
         awful.spawn(apps.full_screenshot, false)
      end,
      {description = "full screenshot", group = "utilities"}
   ),

   awful.key({modkey}, "Print",
      function()
         awful.spawn(apps.cur_window_screenshot, false)
      end,
      {description = "current window screenshot", group = "utilities"}
   ),

   awful.key({modkey,"Shift"}, "Print",
      function()
         awful.spawn(apps.selection_screenshot, false)
      end,
      {description = "selection screenshot", group = "utilities"}
   ),

   -- quit flameshot
   awful.key({altkey}, "Print",
      function()
         awful.spawn("killall -9 /usr/bin/flameshot", false)
      end,
      {description = "quit flameshot", group = "utilities"}
   ),

   -- =========================================
   -- RELOAD / QUIT AWESOME
   -- =========================================

   -- Reload Awesome
   awful.key({modkey, "Shift"}, "r",
      awesome.restart,
      {description = "reload awesome", group = "awesome"}
   ),

   -- Quit Awesome
   awful.key({modkey, "Control", "Shift"}, "Escape",
      function()
         awful.spawn(apps.power_menu, false)
      end,
      {description = "open power menu", group = "system"}
   ),

   -- Quit Awesome
   awful.key({modkey, "Shift"}, "Escape",
      function()
         -- emit signal to show the exit screen
         awesome.emit_signal("show_exit_screen")
      end,
      {description = "toggle exit screen", group = "system"}
   ),

   awful.key({}, "XF86PowerOff",
      function()
         -- emit signal to show the exit screen
         awesome.emit_signal("show_exit_screen")
      end,
      {description = "toggle exit screen", group = "system"}
   ),

   -- =========================================
   -- CLIENT FOCUSING
   -- =========================================

   -- -- Dashboard (show all open windows)
   -- awful.key({modkey, altkey, "Control"}, "space",
   --    function()
   --       awful.spawn("skippy-xd")
   --       raise_client()
   --    end,
   --    {description = "dashboard view all open windows", group = "client"}
   -- ),

   -- Rofi windows (show all open windows)
   awful.key({modkey}, "w",
      function()
         awful.spawn(apps.windows)
         raise_client()
      end,
      {description = "rofi list all open windows", group = "client"}
   ),
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
    	    raise_client()
        end,
        {description = "focus next client", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
    		raise_client()
        end,
        {description = "focus previous client", group = "client"}
    ),
   -- Focus client by direction (hjkl keys)
   -- awful.key({modkey}, "j",
   --    function()
   --       awful.client.focus.bydirection("down")
   --       raise_client()
   --    end,
   --    {description = "focus down", group = "client"}
   -- ),
   -- awful.key({modkey}, "k",
   --    function()
   --       awful.client.focus.bydirection("up")
   --       raise_client()
   --    end,
   --    {description = "focus up", group = "client"}
   -- ),
   awful.key({modkey}, "h",
      function()
         awful.client.focus.bydirection("left")
         raise_client()
      end,
      {description = "focus left", group = "client"}
   ),

   awful.key({modkey}, "l",
      function()
         awful.client.focus.bydirection("right")
         raise_client()
      end,
      {description = "focus right", group = "client"}
   ),

   -- Focus client by direction (arrow keys)
   awful.key({modkey}, "Down",
      function()
         awful.client.focus.bydirection("down")
         raise_client()
      end,
      {description = "focus down", group = "client"}
   ),

   awful.key({modkey}, "Up",
      function()
         awful.client.focus.bydirection("up")
         raise_client()
      end,
      {description = "focus up", group = "client"}
   ),
   -- awful.key({modkey}, "Left",
   --    function()
   --       awful.client.focus.bydirection("left")
   --       raise_client()
   --    end,
   --    {description = "focus left", group = "client"}
   -- ),
   -- awful.key({modkey}, "Right",
   --    function()
   --       awful.client.focus.bydirection("right")
   --       raise_client()
   --    end,
   --    {description = "focus right", group = "client"}
   -- ),

   -- =========================================
   -- SCREEN FOCUSING
   -- =========================================

   -- Focus screen by index (cycle through screens)
   awful.key({modkey}, ",",
      function()
         awful.screen.focus_relative(-1)
      end,
      {description = "focus previous screen", group = "screen"}
   ),
   -- Focus screen by index (cycle through screens)
   awful.key({modkey}, ".",
      function()
         awful.screen.focus_relative(1)
      end,
      {description = "focus next screen", group = "screen"}
   ),

   -- =========================================
   -- CLIENT RESIZING
   -- =========================================

   awful.key({modkey, "Control"}, "Down",
      function(c)
         resize_client(client.focus, "down")
      end,
      {description = "decrease window height", group = "client"}
   ),
   awful.key({modkey, "Control"}, "Up",
      function(c)
         resize_client(client.focus, "up")
      end,
      {description = "increase window height", group = "client"}
   ),
   awful.key({modkey, "Control"}, "Left",
      function(c)
         resize_client(client.focus, "left")
      end,
      {description = "resize window width left", group = "client"}
   ),
   awful.key({modkey, "Control"}, "Right",
      function(c)
         resize_client(client.focus, "right")
      end,
      {description = "resize window width right", group = "client"}
   ),
   awful.key({modkey, "Control"}, "j",
      function(c)
         resize_client(client.focus, "down")
      end,
      {description = "increase window height", group = "client"}
   ),
   awful.key({ modkey, "Control" }, "k",
      function(c)
         resize_client(client.focus, "up")
      end,
      {description = "decrease window height", group = "client"}
   ),
   awful.key({modkey, "Control"}, "h",
      function(c)
         resize_client(client.focus, "left")
      end,
      {description = "resize window width left", group = "client"}
   ),
   awful.key({modkey, "Control"}, "l",
      function(c)
         resize_client(client.focus, "right")
      end,
      {description = "resize window width right", group = "client"}
   ),

   -- =========================================
   -- NUMBER OF MASTER / COLUMN CLIENTS
   -- =========================================

   -- Number of master clients
   awful.key({modkey, altkey}, "k",
      function()
         awful.tag.incnmaster( 1, nil, true)
      end,
      {description = "increase the number of master clients", group = "layout"}
   ),
   awful.key({ modkey, altkey}, "j",
      function()
         awful.tag.incnmaster(-1, nil, true)
      end,
      {description = "decrease the number of master clients", group = "layout"}
   ),

   -- Number of columns
   awful.key({modkey, altkey, "Control"}, "k",
      function()
         awful.tag.incncol(1, nil, true)
      end,
      {description = "increase the number of columns", group = "layout"}
   ),
   awful.key({modkey, altkey, "Control"}, "j",
      function()
         awful.tag.incncol(-1, nil, true)
      end,
      {description = "decrease the number of columns", group = "layout"}
   ),

   -- =========================================
   -- GAP CONTROL
   -- =========================================

   -- Gap control
   awful.key({modkey, "Shift"}, "minus",
      function()
         awful.tag.incgap(5, nil)
      end,
      {description = "increment gaps size for the current tag", group = "gaps"}
   ),
   awful.key({modkey}, "minus",
      function()
         awful.tag.incgap(-5, nil)
      end,
      {description = "decrement gap size for the current tag", group = "gaps"}
   ),

   -- =========================================
   -- LAYOUT SELECTION
   -- =========================================

   -- select next layout
   awful.key({modkey}, "space",
      function()
         awful.layout.inc(1)
      end,
      {description = "select next layout", group = "layout"}
   ),

   -- =========================================
   -- CLIENT MINIMIZATION
   -- =========================================

   -- restore minimized client
   awful.key({modkey, "Shift"}, "n",
      function()
         local c = awful.client.restore()
         -- Focus restored client
         if c then
            client.focus = c
            c:raise()
         end
      end,
      {description = "restore minimized", group = "client"}
   )
)


-- ===================================================================
-- Client Key bindings
-- ===================================================================


keys.clientkeys = gears.table.join(

   -- Move to master
    awful.key({ modkey, "Shift" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),

   -- Move to edge or swap by direction
   awful.key({modkey, "Shift"}, "Down",
      function(c)
         move_client(c, "down")
      end,
	  {description = "move client down", group = "client"}
   ),
   awful.key({modkey, "Shift"}, "Up",
      function(c)
         move_client(c, "up")
      end,
	  {description = "move client up", group = "client"}
   ),
   awful.key({modkey, "Shift"}, "Left",
      function(c)
         move_client(c, "left")
      end,
	  {description = "move client left", group = "client"}
   ),
   awful.key({modkey, "Shift"}, "Right",
      function(c)
         move_client(c, "right")
      end,
	  {description = "move client right", group = "client"}
   ),
   awful.key({modkey, "Shift"}, "j",
      function(c)
         move_client(c, "down")
      end,
	  {description = "move client down", group = "client"}
   ),
   awful.key({modkey, "Shift"}, "k",
      function(c)
         move_client(c, "up")
      end,
	  {description = "move client up", group = "client"}
   ),
   awful.key({modkey, "Shift"}, "h",
      function(c)
         move_client(c, "left")
      end,
	  {description = "move client left", group = "client"}
   ),
   awful.key({modkey, "Shift"}, "l",
      function(c)
         move_client(c, "right")
      end,
	  {description = "move client right", group = "client"}
   ),

   -- move client to previous screen
   awful.key({modkey, "Shift"}, ".",
      function(c)
         c:move_to_screen(-1)
      end,
	  {description = "move client to next screen", group = "client"}
   ),

   -- move client to next screen
   awful.key({modkey, "Shift"}, ",",
      function(c)
         c:move_to_screen(1)
      end,
	  {description = "move client to previous screen", group = "client"}
   ),

   -- toggle fullscreen
   awful.key({modkey}, "f",
      function(c)
         c.fullscreen = not c.fullscreen
      end,
      {description = "toggle fullscreen", group = "client"}
   ),

   -- close client
   awful.key({modkey,"Shift"}, "q",
      function(c)
         c:kill()
      end,
      {description = "close", group = "client"}
   ),

   -- toggle Floating
   awful.key({ modkey, "Shift" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),

   -- Minimize
   awful.key({modkey}, "n",
      function(c)
         c.minimized = true
		 c:raise()
      end,
      {description = "minimize", group = "client"}
   ),

   -- Maximize
   awful.key({modkey}, "m",
      function(c)
         c.maximized = not c.maximized
         c:raise()
      end,
      {description = "(un)maximize", group = "client"}
   )
)

-- ===================================================================
-- Tag Key bindings
-- ===================================================================
keys.globalkeys = gears.table.join(keys.globalkeys,
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous tag", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next tag", group = "tag"}),
  awful.key({modkey, altkey}, "h",
        awful.tag.viewprev,
     {description = "view prev tag", group = "tag"}
  ),
  awful.key({modkey, altkey}, "l",
        awful.tag.viewnext,
     {description = "view next tag", group = "tag"}
  )
)

-- Bind all key numbers to tags
for i = 1, 9 do
   keys.globalkeys = gears.table.join(keys.globalkeys,
      -- Switch to tag
      awful.key({modkey}, "#" .. i + 9,
         function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
               tag:view_only()
            end
         end,
         {description = "view tag #"..i, group = "tag"}
      ),
      -- Move client to tag
      awful.key({modkey, "Shift"}, "#" .. i + 9,
         function()
            if client.focus then
               local tag = client.focus.screen.tags[i]
               if tag then
                  client.focus:move_to_tag(tag)
				  raise_client()
               end
            end
         end,
         {description = "move focused client to tag #"..i, group = "tag"}
      )
   )
end
return keys

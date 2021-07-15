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
      {description = "Brave Browser", group = "applications"}
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
           awful.spawn("/usr/local/bin/dual-vertical-left-monitor")
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
         awful.spawn(apps.filebrowser)
      end,
      {description = "pcmanfm file browser", group = "applications"}
   ),

   -- launch EWU VPN
   awful.key({modkey}, "F3",
      function()
         awful.spawn(apps.vpn)
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
         awful.spawn("pamixer --allow-boost -i 5", false)
         awesome.emit_signal("volume_change")
      end,
      {description = "volume up", group = "function keys"}
   ),
   awful.key({}, "XF86AudioLowerVolume",
      function()
         awful.spawn("pamixer --allow-boost -d 5", false)
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
         awful.spawn(apps.fullScreenshot, false)
      end,
      {description = "full screenshot", group = "utilities"}
   ),

   awful.key({modkey}, "Print",
      function()
         awful.spawn(apps.curWindowScreenshot, false)
      end,
      {description = "current window screenshot", group = "utilities"}
   ),

   awful.key({modkey,"Shift"}, "Print",
      function()
         awful.spawn(apps.selectionScreenshot, false)
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
         -- emit signal to show the exit screen
         awesome.emit_signal("show_exit_screen")
      end,
      {description = "toggle exit screen", group = "system"}
   ),

   -- Quit Awesome
   awful.key({modkey, "Shift"}, "Escape",
      function()
         awful.spawn("/home/mia/.config/.system/sysmenu", false)
      end,
      {description = "open power menu", group = "system"}
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

   -- Dashboard (show all open windows)
   awful.key({modkey, altkey, "Control"}, "space",
      function()
         awful.spawn("skippy-xd")
         raise_client()
      end,
      {description = "dashboard view all open windows", group = "client"}
   ),

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
   awful.key({modkey, altkey}, "Control", "s",
      function()
         awful.screen.focus_relative(1)
      end,
      {description = "cycle focus screens", group = "client"}
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
         resize_client(client.focus, "right")
      end,
      {description = "resize window width right", group = "client"}
   ),
   awful.key({modkey, "Control"}, "l",
      function(c)
         resize_client(client.focus, "left")
      end,
      {description = "resize window width left", group = "client"}
   ),

   -- =========================================
   -- NUMBER OF MASTER / COLUMN CLIENTS
   -- =========================================

   -- Number of master clients
   awful.key({modkey, altkey}, "Shift", "h",
      function()
         awful.tag.incnmaster( 1, nil, true)
      end,
      {description = "increase the number of master clients", group = "layout"}
   ),
   awful.key({ modkey, altkey },"Shift", "l",
      function()
         awful.tag.incnmaster(-1, nil, true)
      end,
      {description = "decrease the number of master clients", group = "layout"}
   ),
   awful.key({ modkey, altkey },"Shift", "Left",
      function()
         awful.tag.incnmaster( 1, nil, true)
      end,
      {description = "increase the number of master clients", group = "layout"}
   ),
   awful.key({ modkey, altkey }, "Shfit", "Right",
      function()
         awful.tag.incnmaster(-1, nil, true)
      end,
      {description = "decrease the number of master clients", group = "layout"}
   ),

   -- Number of columns
   awful.key({modkey, altkey}, "k",
      function()
         awful.tag.incncol(1, nil, true)
      end,
      {description = "increase the number of columns", group = "layout"}
   ),
   awful.key({modkey, altkey}, "j",
      function()
         awful.tag.incncol(-1, nil, true)
      end,
      {description = "decrease the number of columns", group = "layout"}
   ),
   awful.key({modkey, altkey}, "Up",
      function()
         awful.tag.incncol(1, nil, true)
      end,
      {description = "increase the number of columns", group = "layout"}
   ),
   awful.key({modkey, altkey}, "Down",
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
      {description = "select next", group = "layout"}
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

   -- toggle fullscreen
   awful.key({modkey}, "f",
      function(c)
         c.fullscreen = not c.fullscreen
      end,
      {description = "toggle fullscreen", group = "client"}
   ),

   -- close client
   awful.key({modkey}, "q",
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

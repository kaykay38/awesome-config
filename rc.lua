--       █████╗ ██╗    ██╗███████╗███████╗ ██████╗ ███╗   ███╗███████╗
--      ██╔══██╗██║    ██║██╔════╝██╔════╝██╔═══██╗████╗ ████║██╔════╝
--      ███████║██║ █╗ ██║█████╗  ███████╗██║   ██║██╔████╔██║█████╗
--      ██╔══██║██║███╗██║██╔══╝  ╚════██║██║   ██║██║╚██╔╝██║██╔══╝
--      ██║  ██║╚███╔███╔╝███████╗███████║╚██████╔╝██║ ╚═╝ ██║███████╗
--      ╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝


-- Standard awesome libraries
local gears = require("gears")
local awful = require("awful")


-- ===================================================================
-- User Configuration
-- ===================================================================


local themes = {
   "personal", -- 1
   "mirage", -- 2
}

-- change this number to use the corresponding theme
local theme = themes[1]
local rofi_launcher_theme = "/home/mia/.config/rofi/themes/launchpad.rasi"

-- define default apps (global variable so other components can access it)
apps = {
   browser = "brave",
   vpn = "/home/mia/Security/autovpn",
   audio_mixer = "pavucontrol",
   network_manager = "alacritty -e nmtui", -- recommended: nm-connection-editor
   power_manager = "", -- recommended: xfce4-power-manager
   terminal = "alacritty",
   tabbedTerminal = "tabbed -r 2 alacritty --embed \"\"",
   launcher = "rofi -show drun -show-icons",
   windows = "rofi -show window -show-icons",
   launchpad = "rofi -normal-window -modi drun -show drun -theme " .. rofi_launcher_theme,
    greenclip = "rofi -modi 'Clipboard:greenclip print' -show Clipboard -run-command '{cmd}'",
   lock = "betterlockscreen -l",
   fullScreenshot = "/home/mia/.config/.system/fullScreenshot.sh",
   curWindowScreenshot = "/home/mia/.config/.system/curWindowScreenshot.sh",
   selectionScreenshot = "flameshot gui",
   filebrowser = "pcmanfm"
}

-- define wireless and ethernet interface names for the network widget
-- use `ip link` command to determine these
network_interfaces = {
   wlan = 'wlp5s0',
   lan = 'enp4s0',
   vpn = 'tun0'
}

-- List of apps to run on start-up
local run_on_start_up = {
   "xset r rate 200 95",
    "picom -b",
    "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1",
    "greenclip daemon",
   "unclutter",
}


-- ===================================================================
-- Initialization
-- ===================================================================

-- Import notification appearance
require("components.notifications")

-- Run all the apps listed in run_on_start_up
for _, app in ipairs(run_on_start_up) do
   local findme = app
   local firstspace = app:find(" ")
   if firstspace then
      findme = app:sub(0, firstspace - 1)
   end
   -- pipe commands to bash to allow command to be shell agnostic
   awful.spawn.with_shell(string.format("echo 'pgrep -u $USER -x %s > /dev/null || (%s)' | bash -", findme, app), false)
end

-- Import theme
local beautiful = require("beautiful")
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/" .. theme .. "-theme.lua")

-- Import hotkeys appearance
require("components.hotkeys_window")

-- Initialize theme
local selected_theme = require(theme)
selected_theme.initialize()

-- Import Keybinds
local keys = require("keys")
root.keys(keys.globalkeys)
root.buttons(keys.desktopbuttons)

-- Import rules
local create_rules = require("rules").create
awful.rules.rules = create_rules(keys.clientkeys, keys.clientbuttons)

-- Define layouts
-- dynamite.layout.layouts = {
--    dynamite.layout.tabbed
-- }
awful.layout.layouts = {
   awful.layout.suit.tile.left,
   awful.layout.suit.fair.horizontal,
   awful.layout.suit.floating,
   awful.layout.suit.max,
}

-- remove gaps if layout is set to max
tag.connect_signal('property::layout', function(t)
   local current_layout = awful.tag.getproperty(t, 'layout')
   if (current_layout == awful.layout.suit.max) then
      t.gap = 0
   else
      t.gap = beautiful.useless_gap
   end
end)

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
   -- Set the window as a slave (put it at the end of others instead of setting it as master)
   if not awesome.startup then
      awful.client.setslave(c)
   end

   if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
      -- Prevent clients from being unreachable after screen count changes.
      awful.placement.no_offscreen(c)
   end
end)


-- ===================================================================
-- Client Focusing
-- ===================================================================


-- Autofocus a new client when previously focused one is closed
require("awful.autofocus")

-- Focus clients under mouse
client.connect_signal("mouse::enter", function(c)
   c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

-- Focus urgent clients automatically
client.connect_signal("property::urgent", function(c)
    c.minimized = false
    c:jump_to()
end)
-- ===================================================================
-- Screen Change Functions (ie multi monitor)
-- ===================================================================


-- Reload config when screen geometry changes
screen.connect_signal("property::geometry", awesome.restart)


-- ===================================================================
-- Garbage collection (allows for lower memory consumption)
-- ===================================================================


collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)

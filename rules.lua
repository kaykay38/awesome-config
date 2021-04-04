--      ██████╗ ██╗   ██╗██╗     ███████╗███████╗
--      ██╔══██╗██║   ██║██║     ██╔════╝██╔════╝
--      ██████╔╝██║   ██║██║     █████╗  ███████╗
--      ██╔══██╗██║   ██║██║     ██╔══╝  ╚════██║
--      ██║  ██║╚██████╔╝███████╗███████╗███████║
--      ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝╚══════╝

-- ===================================================================
-- Initialization
-- ===================================================================


local awful = require("awful")
local beautiful = require("beautiful")

-- define screen height and width
local screen_height = awful.screen.focused().geometry.height
local screen_width = awful.screen.focused().geometry.width

-- define module table
local rules = {}


-- ===================================================================
-- Rules
-- ===================================================================


-- return a table of client rules including provided keys / buttons
function rules.create(clientkeys, clientbuttons)
   local rofi_rule = {}

   if beautiful.name == "mirage" then
      rofi_rule = {
         rule_any = {name = {"rofi"}},
         properties = {floating = true, titlebars_enabled = false, border_width = 0},
         callback = function(c)
            if beautiful.name == "mirage" then
               awful.placement.left(c)
            end
         end
      }
   else rofi_rule = {
         rule_any = {name = {"rofi"}},
         properties = {maximized = true, floating = true, titlebars_enabled = false, border_width = 0},
      }
   end

   return {
      -- All clients will match this rule.
      {
         rule = {},
         properties = {
            titlebars_enabled = beautiful.titlebars_enabled,
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.centered
         },
      },
      -- Floating clients.
      {
         rule_any = {
            instance = {
               "DTA",
               "copyq",
            },
            class = {
              "Nm-connection-editor",
              "Arandr",
              "Blueman-manager",
              "Gpick",
              "Kruler",
              "MessageWin",  -- kalarm.
              "Pavucontrol",
              "Sxiv",
              "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
              "Wpa_gui",
              "veromix",
              "xtightvncviewer",
              "Gcolor",
              "Gcr-prompter",
            },
            name = {
               "Event Tester",
               "Steam Guard - Computer Authorization Required",
            },
            role = {
               "pop-up",
              "AlarmWindow",  -- Thunderbird's calendar.
              "ConfigManager",  -- Thunderbird's about:config.
               "GtkFileChooserDialog"
              },
              type = {
               "dialog"
                }
             }, properties = { floating = true, ontop =true, placement = awful.placement.centered}
      },
      {
         rule_any = {
            class = {
               "libreoffice-startcenter", "libreoffice-writer",  "libreoffice-calc", "libreoffice-impress", "libreoffice-draw", "libreoffice-math", "libreoffice-base"
            },
         }, properties = {maximized_horizontal = false, maximized_vertical = false, maximized = false}
      },
      {
         rule_any = {
            name = {
              "albert - Albert",
             }
         }, properties = { floating = true, ontop =true, placement = awful.placement.centered, border_width = 0 }
     },

      -- Fullscreen clients
      {
         rule_any = {
            class = {
               "Terraria.bin.x86",
            },
         }, properties = {fullscreen = true}
      },

      -- "Switch to tag"
      -- These clients make you switch to their tag when they appear
      {
         rule_any = {
            class = {
               "Spotify"
            },
         }, properties = {switchtotag = true, tag = '5'}
      },
      {
         rule_any = {
            class = {
               "Gimp"
            },
         }, properties = {switchtotag = true, tag = '4'}
      },
      {
         rule_any = {
            class = {
               "discord"
            },
         }, properties = {switchtotag = true, tag = '3'}
      },
      {
         rule_any = {
            class = {
               "zoom"
            },
         }, properties = {switchtotag = true, tag = '3'}
      },
      {
         rule_any = {
            class = {
               "Microsoft Teams - Preview"
            },
         }, properties = {switchtotag = true, tag = '3'}
      },
      {
         rule_any = {
            class = {
               "Substance Painter"
            },
         }, properties = {switchtotag = true, tag = '4', border_width=0}
      },
      {
         rule_any = {
            class = {
               "Substance Designer"
            },
         }, properties = {switchtotag = true, tag = '4',  border_width=0}
      },
      {
         rule_any = {
            class = {
               "Substance Architect"
            },
         }, properties = {switchtotag = true, tag = '4',  border_width=0}
      },
      {
         rule_any = {
            class = {
               "Steam"
            },
         }, properties = {switchtotag = true, tag = '7'}
      },
      -- Visualizer
      {
         rule_any = {name = {"cava"}},
         properties = {
            floating = true,
            maximized_horizontal = true,
            sticky = true,
            ontop = false,
            skip_taskbar = true,
            below = true,
            focusable = false,
            height = screen_height * 0.40,
            opacity = 0.6
         },
         callback = function (c)
            decorations.hide(c)
            awful.placement.bottom(c)
         end
      },

      -- rofi rule determined above
      rofi_rule,

      -- File chooser dialog
      {
         rule_any = {role = {"GtkFileChooserDialog"}},
         properties = {floating = true, width = screen_width * 0.55, height = screen_height * 0.65}
      },

      -- Pavucontrol & Bluetooth Devices
      {
         rule_any = {class = {"Pavucontrol"}, name = {"Bluetooth Devices"}},
         properties = {floating = true, width = screen_width * 0.3, height = screen_height * 0.45}
      },
   }
end

-- return module table
return rules

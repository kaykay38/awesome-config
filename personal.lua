--      ██████╗  █████╗ ███████╗████████╗███████╗██╗
--      ██╔══██╗██╔══██╗██╔════╝╚══██╔══╝██╔════╝██║
--      ██████╔╝███████║███████╗   ██║   █████╗  ██║
--      ██╔═══╝ ██╔══██║╚════██║   ██║   ██╔══╝  ██║
--      ██║     ██║  ██║███████║   ██║   ███████╗███████╗
--      ╚═╝     ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝╚══════╝

-- ===================================================================
-- Initialization
-- ===================================================================


local awful = require("awful")
local gears = require("gears")

local pastel = {}


-- ===================================================================
-- Pastel setup
-- ===================================================================


pastel.initialize = function()
   -- Import components
   require("components.pastel.wallpaper")
   require("components.exit-screen")
   require("components.volume-adjust")

   -- Import panels
   local top_panel = require("components.personal.top-panel")

   -- Set up each screen (add tags & panels)
   awful.screen.connect_for_each_screen(function(s)
      for i = 1, 8, 1
      do
         awful.tag.add(i, {
            icon = gears.filesystem.get_configuration_dir() .. "/icons/tags/personal/" .. i .. ".svg",
            layout = awful.layout.suit.tile.left,
            screen = s,
            selected = i == 1
         })
      end

      -- Add the top panel to every screen
      top_panel.create(s)
   end)
end

return pastel

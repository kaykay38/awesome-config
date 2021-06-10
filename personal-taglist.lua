-- ██████╗ ███████╗██████╗ ███████╗ ██████╗ ███╗   ██╗ █████╗ ██╗     
-- ██╔══██╗██╔════╝██╔══██╗██╔════╝██╔═══██╗████╗  ██║██╔══██╗██║     
-- ██████╔╝█████╗  ██████╔╝███████╗██║   ██║██╔██╗ ██║███████║██║     
-- ██╔═══╝ ██╔══╝  ██╔══██╗╚════██║██║   ██║██║╚██╗██║██╔══██║██║     
-- ██║     ███████╗██║  ██║███████║╚██████╔╝██║ ╚████║██║  ██║███████╗
-- ╚═╝     ╚══════╝╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝
                                                                   

-- ===================================================================
-- Initialization
-- ===================================================================


local awful = require("awful")
local gears = require("gears")

local personal = {}


-- ===================================================================
-- Pastel setup
-- ===================================================================


personal.initialize = function()
   -- Import components
   require("components.personal.wallpaper")
   require("components.exit-screen")
   require("components.volume-adjust")

   -- Import panels
   local top_panel = require("components.personal.top-panel")
   local tags = { "", "", "", "","", "", "", "" }
   -- Set up each screen (add tags & panels)
   awful.screen.connect_for_each_screen(function(s)
      for i = 1, 8, 1
      do
         awful.tag.add(i, {
            text = tags[i],
            layout = awful.layout.suit.tile.left,
            screen = s,
            selected = i == 1
         })
      end

      -- Add the top panel to every screen
      top_panel.create(s)
   end)
end

return personal

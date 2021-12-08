--      ██╗    ██╗ █████╗ ██╗     ██╗     ██████╗  █████╗ ██████╗ ███████╗██████╗
--      ██║    ██║██╔══██╗██║     ██║     ██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗
--      ██║ █╗ ██║███████║██║     ██║     ██████╔╝███████║██████╔╝█████╗  ██████╔╝
--      ██║███╗██║██╔══██║██║     ██║     ██╔═══╝ ██╔══██║██╔═══╝ ██╔══╝  ██╔══██╗
--      ╚███╔███╔╝██║  ██║███████╗███████╗██║     ██║  ██║██║     ███████╗██║  ██║
--       ╚══╝╚══╝ ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝

-- ===================================================================
-- Imports
-- ===================================================================


local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")


-- ===================================================================
-- Initialization
-- ===================================================================


local is_blurred = false;

local wallpaper_dir = "/home/mia/Pictures/Wallpapers/"
local wallpaper = wallpaper_dir .. "gaetan-weltzer-challenge-11-painting5-1920.jpg"
local blurred_wallpaper = wallpaper_dir .. "gaetan-weltzer-challenge-11-painting5-1920-blurred.jpg"

awful.spawn.with_shell("xwallpaper --zoom " .. wallpaper)

--- Check if a file or directory exists in this path
local function exists(file)
    local ok, err, code = os.rename(file, file)
    if not ok then
        if code == 13 then
            -- Permission denied, but it exists
            return true
        end
    end
    return ok, err
end

-- check if blurred wallpaper needs to be created
if not exists(blurred_wallpaper) then
    naughty.notify({
        preset = naughty.config.presets.normal,
        title = "Wallpaper",
        text = "Generating blurred wallpaper..."
    })
    -- uses image magick to create a blurred version of the wallpaper
    awful.spawn.with_shell("convert -filter Gaussian -blur 0x05 " .. wallpaper .. " " .. blurredWallpaper)
end


-- ===================================================================
-- Functionality
-- ===================================================================


-- changes to blurred wallpaper
local function blur()
    if not is_blurred then
        awful.spawn.with_shell("xwallpaper --zoom " .. blurred_wallpaper)
        is_blurred = true
    end
end

-- changes to normal wallpaper
local function unblur()
    if is_blurred then
        awful.spawn.with_shell("xwallpaper --zoom " .. wallpaper)
        is_blurred = false
    end
end

-- blur / unblur on tag change
tag.connect_signal("property::selected", function(t)
    -- check if tag has any clients
    for _,cc in pairs(t:clients()) do
        if not cc.minimized then
            blur()
            return
        end
    end
    -- unblur if tag has no clients
    unblur()
end)

-- blur / unblur on tag change
tag.connect_signal("raised", function(t)
    -- check if tag has any clients
    for _,cc in pairs(t:clients()) do
        if not cc.minimized then
            blur()
            return
        end
    end
    -- unblur if tag has no clients
    unblur()
end)

-- check if wallpaper should be blurred on client open
client.connect_signal("manage", function(c)
    blur()
end)

client.connect_signal("property::minimized", function(c)
    local t = awful.screen.focused().selected_tag
    -- check if tag has any clients
    for _,cc in pairs(t:clients()) do
        if not cc.minimized then
            blur()
            return
        end
    end
    unblur()
end)

-- client.connect_signal("property::minimized", function(c)
--    local t = awful.screen.focused().selected_tag
--    -- check if tag has any clients
--    for _,cc in pairs(t:clients()) do
-- 	  if not cc.minimized then
--          blur()
--          return
-- 	  end
--    end
--    unblur()
-- end)
-- 
-- check if wallpaper should be unblurred on client close
client.connect_signal("unmanage", function(c)
    local t = awful.screen.focused().selected_tag
    -- check if tag has any clients
    for _,cc in pairs(t:clients()) do
        if not cc.minimized then
            return
        end
    end
    -- unblur if tag has no clients
    unblur()
end)

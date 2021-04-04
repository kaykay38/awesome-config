local awful = require("awful")
local naughty = require("naughty")

local timers = { 5,10 }
local screenshot = os.getenv("HOME") .. "Pictures/Screenshots/(date +%Y-%m-%d_%Hh%Mm%S).png"

Scrot_full = function()
    Scrot("scrot \"".. screenshot .."\" && echo \""..screenshot.."\" | xclip -i", "Full Screenshot", "Saved to Pictures/Screenshots\nFile path copied to primary"
    )
end

Scrot_window = function()
    Scrot("scrot -u \"".. screenshot .."\" && echo \""..screenshot.."\" | xclip -i", "Current Window Screenshot", "Saved to Pictures/Screenshots\nFile path copied to primary"
    )
end

Scrot_selection = function()
    Scrot("sleep 0.5 && scrot -s \"".. screenshot .."\" && echo \""..screenshot.."\" | xclip -i", "Selection Screenshot", "Saved to Pictures/Screenshots\nFile path copied to primary"
    )
end

Scrot_delay = function()
    Items={}
    for key, value in ipairs(timers)  do
        Items[#Items+1]={tostring(value) , "scrot -d ".. value.." " .. screenshot .. " && echo\""..screenshot.."\" xclip -i" }
    end
    awful.menu.new(
    {
        items = Items
    }
    ):show({keygrabber= true})
    Scrot_notify("Delayed Screenshot", "Saved to Picture/Screenshots\nFile path saved to primary")
end

Scrot = function(cmd , title, text)
    awful.util.spawn_with_shell(cmd)
    Scrot_notify(title, text)
end

Scrot_notify = function(title, text)
    naughty.notify({
        title = title,
        app_name = "Scrot",
        text = text,
        icon = screenshot,
        timeout = 2,
    })
end

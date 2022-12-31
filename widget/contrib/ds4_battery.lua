--[[

     Licensed under GNU General Public License v2
      * (c) 2013, Luca CPZ
      * (c) 2022, tronfy <https://github.com/tronfy>

--]]

local helpers  = require("lain.helpers")
local wibox    = require("wibox")

-- DualShock 4 battery info
-- lain.widget.contrib.ds4_battery

local function factory(args)
    args           = args or {}

    local battery  = { widget = args.widget or wibox.widget.textbox() }
    local timeout  = args.timeout or 5
    local batfile  = args.batfile or "/sys/class/power_supply/sony_controller_battery_84:30:95:0c:8b:d3/capacity"
    local settings = args.settings or function() end

    function battery.update()
        bat = "off"

        helpers.async(string.format("cat %s", batfile), function(f)
            bat_fl = f:match("([%d]+)")
            if bat_fl then
                bat = bat_fl .. "%"
            end
            widget = battery.widget
            settings()
        end)
    end

    helpers.newtimer("ds4-battery", timeout, battery.update)

    return battery
end

return factory

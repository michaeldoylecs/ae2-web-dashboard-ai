local component = require("lib/component")
local gps = component.gps

local sensors = {}

function sensors.collect_data()
    local data = {
        coordinates = gps.locate(),
        inventory = component.inventory_controller.getInventory(),
        energy = component.generator.energy(),
        time = os.time()
    }
    return data
end

return sensors

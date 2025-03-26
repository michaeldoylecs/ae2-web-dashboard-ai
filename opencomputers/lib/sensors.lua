local component = require("component")
local sensors = {}

function sensors.collect_data()
    local data = {
        time = os.time()
    }
    
    -- Check if GPS component is available
    if component.isAvailable("gps") then
        local gps = component.gps
        data.coordinates = gps.locate()
    else
        data.coordinates = {0, 0, 0} -- Default coordinates when GPS is not available
    end
    
    -- Check if inventory controller is available
    if component.isAvailable("inventory_controller") then
        data.inventory = component.inventory_controller.getInventory()
    else
        data.inventory = {} -- Empty inventory when controller is not available
    end
    
    -- Check if generator is available
    if component.isAvailable("generator") then
        data.energy = component.generator.energy()
    else
        data.energy = 0 -- Default energy value when generator is not available
    end
    
    return data
end

return sensors

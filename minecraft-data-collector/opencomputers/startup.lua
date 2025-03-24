-- Main OpenComputers startup script
local config = require("lib/config")
local sensors = require("lib/sensors")
local http = require("lib/http")

local function main()
    while true do
        local data = sensors.collect_data()
        local success, response = http.send_to_api(data)
        
        if not success then
            print("API Error: " .. response)
        end
        
        os.sleep(config.data_interval)
    end
end

main()

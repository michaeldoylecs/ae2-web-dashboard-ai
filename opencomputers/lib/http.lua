local component = require("component")
local internet = component.internet

local http = {}

function http.send_to_api(data)
    local json = require("json")
    local config = require("config")
    
    local headers = {
        ["Content-Type"] = "application/json",
        ["Authorization"] = config.api_key
    }
    
    -- Create the request but don't read it immediately
    local request = internet.request(config.api_url, json.encode(data), headers)
    
    -- Wait for the request to complete
    local responseData = ""
    local success = pcall(function()
        -- Set a timeout to avoid hanging
        request.finishConnect(3)
        
        -- Read the response in chunks to avoid yielding issues
        while true do
            local chunk = request.read()
            if chunk then
                responseData = responseData .. chunk
            else
                break
            end
        end
        
        -- Close the connection
        request.close()
    end)
    
    if success then
        return true, responseData
    else
        return false, "Failed to connect to API"
    end
end

return http

local component = require("lib/component")
local internet = component.internet

local http = {}

function http.send_to_api(data)
    local json = require("lib/json")
    local config = require("lib/config")
    
    local headers = {
        ["Content-Type"] = "application/json",
        ["Authorization"] = config.api_key
    }
    
    local request = internet.request(config.api_url, json.encode(data), headers)
    local response = request:readAll()
    
    return true, response
end

return http

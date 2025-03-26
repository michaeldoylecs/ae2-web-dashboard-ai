local json = {}

-- Helper function to determine if a table is an array
local function isArray(t)
    local count = 0
    local isArray = true
    for k, v in pairs(t) do
        if type(k) ~= "number" or k <= 0 or math.floor(k) ~= k then
            isArray = false
            break
        end
        count = count + 1
    end
    return isArray and count > 0
end

-- Encode a Lua value to JSON
function json.encode(value)
    local valueType = type(value)
    
    if valueType == "nil" then
        return "null"
    elseif valueType == "boolean" then
        return value and "true" or "false"
    elseif valueType == "number" then
        return tostring(value)
    elseif valueType == "string" then
        -- Escape special characters
        local escaped = value:gsub("\\", "\\\\")
                             :gsub('"', '\\"')
                             :gsub("\n", "\\n")
                             :gsub("\r", "\\r")
                             :gsub("\t", "\\t")
        return '"' .. escaped .. '"'
    elseif valueType == "table" then
        local parts = {}
        
        if isArray(value) then
            -- Array
            for i, v in ipairs(value) do
                parts[i] = json.encode(v)
            end
            return "[" .. table.concat(parts, ",") .. "]"
        else
            -- Object
            for k, v in pairs(value) do
                if type(k) == "string" then
                    table.insert(parts, json.encode(k) .. ":" .. json.encode(v))
                end
            end
            return "{" .. table.concat(parts, ",") .. "}"
        end
    else
        error("Cannot encode " .. valueType .. " to JSON")
    end
end

-- Simple JSON decode is not implemented as it's not needed by http.lua
-- But we could add it later if needed

return json

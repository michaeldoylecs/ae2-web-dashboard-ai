-- update.lua - Downloads the latest code from GitHub repository
local component = require("component")
local fs = require("filesystem")
local shell = require("shell")
local computer = require("computer")

-- Configuration
local REPO_URL = "https://raw.githubusercontent.com/michaeldoylecs/ae2-web-dashboard-ai/main/"
local FILES = {
  -- Main files
  {path = "opencomputers/startup.lua", dest = "startup.lua"},
  
  -- Library files
  {path = "opencomputers/lib/http.lua", dest = "lib/http.lua"},
  {path = "opencomputers/lib/sensors.lua", dest = "lib/sensors.lua"},
  {path = "opencomputers/lib/config.lua", dest = "lib/config.lua"}
}

-- Download a file from the repository
local function downloadFile(path, destination)
  print("Downloading " .. path .. " to " .. destination)
  
  local url = REPO_URL .. path
  print("URL: " .. url)
  
  -- Create parent directories if they don't exist
  local destDir = fs.path(destination)
  if destDir ~= "" and not fs.exists(destDir) then
    fs.makeDirectory(destDir)
    print("Created directory: " .. destDir)
  end
  
  -- Use a different approach to download files
  local result = nil
  
  -- Try to use the wget program directly
  local wgetPath = "/bin/wget"
  if fs.exists(wgetPath) then
    -- Use os.execute instead of shell.execute
    result = os.execute(wgetPath .. " -f \"" .. url .. "\" \"" .. destination .. "\"")
  else
    print("wget not found at " .. wgetPath .. ", trying alternative method")
    -- Alternative method using component.internet
    if component.isAvailable("internet") then
      local internet = require("internet")
      local success, reason = pcall(function()
        local handle = internet.request(url)
        local content = ""
        
        -- Wait for connection
        local timeout = 5
        local connected = false
        for i = 1, timeout * 10 do
          if handle.finishConnect() then
            connected = true
            break
          end
          os.sleep(0.1)
        end
        
        if not connected then
          error("Connection timed out")
        end
        
        -- Read content
        while true do
          local chunk = handle.read()
          if chunk then
            content = content .. chunk
          else
            break
          end
        end
        
        -- Write to file
        local file = io.open(destination, "w")
        if file then
          file:write(content)
          file:close()
          result = true
        else
          error("Could not open file for writing: " .. destination)
        end
      end)
      
      if not success then
        print("Error: " .. tostring(reason))
        result = false
      end
    else
      print("No internet component available")
      result = false
    end
  end
  
  if result then
    if fs.exists(destination) then
      print("Successfully downloaded " .. destination)
      return true
    else
      print("Download reported success but file not found: " .. destination)
      return false
    end
  else
    print("Failed to download " .. path)
    return false
  end
end

-- Main execution
print("Starting update from GitHub repository...")
print("Repository: " .. REPO_URL)

-- Create lib directory first, before any downloads
print("Checking for lib directory...")
if not fs.exists("lib") then
  local success = fs.makeDirectory("lib")
  if success then
    print("Created lib directory successfully")
  else
    print("Failed to create lib directory!")
    return
  end
else
  print("lib directory already exists")
end

local successCount = 0
local failCount = 0

for _, file in ipairs(FILES) do
  if downloadFile(file.path, file.dest) then
    successCount = successCount + 1
  else
    failCount = failCount + 1
  end
end

print("\nUpdate completed!")
print("Files downloaded successfully: " .. successCount)
print("Files failed: " .. failCount)

if failCount == 0 then
  print("All files were updated successfully!")
else
  print("Some files failed to update. Please check your internet connection and try again.")
end

print("\nReboot the computer to apply changes? (y/n)")
local input = io.read():lower()
if input == "y" or input == "yes" then
  print("Rebooting...")
  os.sleep(1)
  computer.shutdown(true)
end

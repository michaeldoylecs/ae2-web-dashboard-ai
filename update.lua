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
  
  -- Use the component.internet directly
  -- Use the built-in wget program
  local success = shell.execute("wget", "-f", url, destination)
  
  if success then
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

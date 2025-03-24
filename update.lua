-- update.lua - Downloads the latest code from GitHub repository
local fs = require("filesystem")

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
  print("destDir = " .. destDir)
  if destDir ~= "/" then
    os.execute("mkdir " .. destDir)
  end

  local result = os.execute("wget -f \"" .. url .. "\" \"" .. destination .. "\"")
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
print("Repository: " .. REPO_URL .. "\n")

local successCount = 0
local failCount = 0

for _, file in ipairs(FILES) do
  if downloadFile(file.path, file.dest) then
    successCount = successCount + 1
  else
    failCount = failCount + 1
  end
  print("")
end

print("\nUpdate completed!")
print("Files downloaded successfully: " .. successCount)
print("Files failed: " .. failCount)

if failCount == 0 then
  print("All files were updated successfully!")
else
  print("Some files failed to update. Please check your internet connection and try again.")
end

print("\nUpdate process completed. You may need to reboot the computer for changes to take effect.")

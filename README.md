# Minecraft Data Collector

An OpenComputers program to collect and transmit sensor data from Minecraft machines.

## Installation

### Automatic Installation (Recommended)

The easiest way to install this project on your OpenComputers computer is using the update script:

1. **Create the update script**:
   - In your OpenComputers terminal, run: `edit update.lua`
   - Copy and paste the contents of the update script (see below)
   - Save the file (Ctrl+S, then Enter, then Ctrl+W to exit)

2. **Run the update script**:
   - Execute the script by typing: `lua update.lua`
   - The script will download all necessary files from the GitHub repository
   - When prompted, type 'y' to reboot the computer and apply changes

3. **Verify installation**:
   - After reboot, the data collection should start automatically
   - Check the console for any error messages

### Manual Installation

If you prefer to install the files manually:

1. Download all files from the `opencomputers` directory in this repository
2. Place them in the corresponding locations on your OpenComputers computer
3. Reboot the computer to start the data collection

## Updating

To update to the latest version:

1. Run the update script: `lua update.lua`
2. The script will download the latest files from the repository
3. Reboot when prompted to apply the changes

## Configuration

Edit the `lib/config.lua` file to customize:
- API endpoint URL
- Data collection intervals
- Other settings specific to your setup

## Usage

The program will automatically:
- Collect machine sensor data
- Transmit it to the configured API endpoint
- Handle errors and retries automatically

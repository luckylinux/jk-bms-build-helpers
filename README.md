# Introduction
JK BMS Build Helpers.

Tested with:
- syssi esphome-jk-bms: https://github.com/syssi/esphome-jk-bms
- sleeper85 esphome-jk-bms-can: https://github.com/Sleeper85/esphome-jk-bms-can

# Quick Start Guide
```
# Clone Repository
git clone https://github.com/luckylinux/jk-bms-build-helpers.git

# Change to cloned folder of Repository
cd jk-bms-build-helpers

# Modify your secrets (WiFi, OTA, WebServer Auth, MQTT, ...)
nano secrets.sh

# Modify your BMS List for BLE (name for HA/MQTT, MAC Address, Driver/Protocol for syssi software)
nano devices.sh

# Change to the esphome-jk-bms-can folder for Sleeper85 code
cd esphome-jk-bms-can

# Modify Other Settings in the YAML file directly
# This includes Battery Voltage, Current, etc (depending on your chemistry - this was done for 16s LFP)
nano esp32-ble-1.17.4.yaml

# Build it
./build_esphome_jk_bms_can.sh

# In case of errors, it will ask you if you want to clean & try again the Build
# Select Y if you want so
```

# Download
Run in the desired directory
```
git clone https://github.com/luckylinux/jk-bms-build-helpers.git
```

# Configure Device Database
A very rudimentary Device Database is provided in `devices.sh`.

This containts:
- The device name
- The device mac address
- The driver to be used (refer to syssi esphome-jk-bms documentation)


# Configure Secrets (WiFi, MQTT, etc)
Set the required secrets/parameters in `secrets.sh`.

# Configure Board and set Other Parameters
## Board Configuration
The board can **only** be configured in the respective build script (e.g. `esphome-jk-bms/build_esphome_jk_bms.sh`) as ESPHome doesn't allow this variable/parameter to be set as a secret.

## Text Substitution using BASH Script
In order to fix this, `functions.sh` can perform text-substitution in the .yaml file **after** it is copied to the build directory and **before** `esphome run` launches the build).

The usage is illustrated in e.g. `esphome-jk-bms/build_esphome_jk_bms.sh`.

```
# Execute Text Replacement
source $parentpath/functions.sh
replace_text "./$esphomeconfig" "board" "$board"

```

This **MUST** be used to set the board (which is defined at the **TOP** of e.g. `esphome-jk-bms/build_esphome_jk_bms.sh`).

It can also be used to set other variables though.

The syntax that will be replaced is: `{{variablename}}` in the YAML file.

```
replace_text "$filelocation" "variablename" "variablevalue"
```

Important: do **not** add extra `{{` or `}}` in `variablename` as this is done directly by the `replace_text` function (internally) !

# Manually (Re)upload Compiled Firmware
In case you want to manually (re)upload the compiled Firmware, the following should get the job done:
```
# Change to root folder of Project Release
cd /root/ESPHome/esphome-jk-bms-can-1.17.4/

# Activate Python venv
source ../venv/bin/activate

# Upload Firmare
esphome upload esp32-ble-1.17.4.yaml
```

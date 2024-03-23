# Introduction
JK BMS Build Helpers.

Tested with:
- syssi esphome-jk-bms: https://github.com/syssi/esphome-jk-bms
- sleeper85 esphome-jk-bms-can: https://github.com/Sleeper85/esphome-jk-bms-can

# Configure
## General
Set the required secrets/parameters in `secrets.sh`.

## Board Configuration
The board can **only** be configured in the respective build script (e.g. `esphome-jk-bms/build_esphome_jk_bms.sh`) as ESPHome doesn't allow this variable/parameter to be set as a secret.

# Text Substitution using BASH Script
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


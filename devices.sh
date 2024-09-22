#!/bin/bash

# Configurations
names=()
macs=()
protocols=()
topic_prefix=()

# Protocol: according to https://github.com/syssi/esphome-jk-bms
# - Please "JK02" (hardware version >= 6.0 and < 11.0)
# - Please use "JK02_32S" if you own a new JK-BMS >= hardware version 11.0 (f.e. JK-B2A8S20P hw 11.XW, sw 11.26)
# - Please use "JK04" if you have some old JK-BMS <= hardware version 3.0 (f.e. JK-B2A16S hw 3.0, sw. 3.3.0)

# jk-bms-bat01
names[0]="jk-bms-bat01"
macs[0]="C8:47:8C:EC:1E:60"
protocols[0]="JK02_32S"                      # HW v11.x for JK-BMS-BAT01
#topic_prefix[0]="battery/jk-bms-bat01"      # Changing to this will require refactoring all the entities in Home Assistant
#topic_prefix[0]=""                          # This seems to disable MQTT altogether
topic_prefix[0]="jk-bms-bat01"               # Original

# jk-bms-bat02
names[1]="jk-bms-bat02"
macs[1]="C8:47:8C:E5:98:96"
protocols[1]="JK02_24S"                      # HW v10.x for JK-BMS-BAT02
#topic_prefix[1]="battery/jk-bms-bat02"      # Changing to this will require refactoring all the entities in Home Assistant"
#topic_prefix[1]=""                          # This seems to disable MQTT altogether
topic_prefix[1]="jk-bms-bat02"               # Original

# jk-bms-bat03
names[2]="jk-bms-bat03"
macs[2]="C8:47:80:07:BC:75"
protocols[2]="JK02_32S"                      # HW v10.x for JK-BMS-BAT02
#topic_prefix[2]="battery/jk-bms-bat03"      # Changing to this will require refactoring all the entities in Home Assistant"
#topic_prefix[2]=""                          # This seems to disable MQTT altogether
topic_prefix[2]="jk-bms-bat03"               # Original

# jk-bms-bat04
names[3]="jk-bms-bat04"
macs[3]="12:34:56:78:99:01"
protocols[3]="JK02_32S"                      # HW v10.x for JK-BMS-BAT02
#topic_prefix[3]="battery/jk-bms-bat04"      # Changing to this will require refactoring all the entities in Home Assistant"
#topic_prefix[3]=""                          # This seems to disable MQTT altogether
topic_prefix[3]="jk-bms-bat04"               # Original

# Dummy Device to test build & prevent automatic OTA Upload
# jk-bms-dummy
names[4]="jk-bms-dummy"                      # Dummy Name
macs[4]="12:34:56:78:90:AB"                  # Dummy MAC Address
protocols[4]="JK02_32S"
#topic_prefix[4]="battery/jk-bms-dummy"      # Changing to this will require refactoring all the entities in Home Assistant
#topic_prefix[4]=""                          # This seems to disable MQTT altogether
topic_prefix[4]="jk-bms-dummy"               # Original

# Dummy Device to test build & prevent automatic OTA Upload
# jk-bms-dummy-canbus-tester
names[5]="jk-bms-dummy-canbus-tester"        # Dummy Name
macs[5]="12:34:56:78:90:AB"                  # Dummy MAC Address
protocols[5]="JK02_32S"
#topic_prefix[5]="battery/jk-bms-dummy-canbus-tester"      # Changing to this will require refactoring all the entities in Home Assistant
#topic_prefix[5]=""                          # This seems to disable MQTT altogether
topic_prefix[5]="jk-bms-dummy-canbus-tester" # Original


# Determine Number of Devices
num=${#names[@]}
maxindex=$(($num - 1))
selected=$((-1))              # Default value (nothing selected)

while [[ $selected -gt $maxindex ]] || [[ $selected -lt 0 ]]
do
    for ((index=0;index<=$maxindex;index++))
    do
        name=${names[$index]}
        protocol=${protocols[$index]}
        mac=${macs[$index]}

        selection=$((index+1))
        echo -e "[${selection}]"
        echo -e "\t Hostname: ${name}"
        echo -e "\t MAC Address: ${mac}"
        echo -e "\t Protocol: ${protocol}"
    done

    read -p "Enter desired configuration: " selection
    selected=$((selection-1))
    name=${names[$selected]}
    mac=${macs[$selected]}
    protocol=${protocols[$selected]}
    topic_prefix=${topic_prefix[$selected]}
done

# Determine entities prefix
entities_id_prefix="${name}"
entities_name_prefix="${name}"

echo "Hostname set to <$name>"
echo "MAC Addres set to <$mac>"
echo "MQTT Topic Prefix: ${topic_prefix}"
echo "MQTT Topic: ${topic_prefix}/${entities_prefix}"

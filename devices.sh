#!/bin/bash

# Configurations
names=()
#names+=("jk-bms-can-bat01")
#names+=("jk-bms-can-bat02")
names+=("jk-bms-bat01")
names+=("jk-bms-bat02")

macs=()
macs+=("C8:47:8C:EC:1E:60")
macs+=("C8:47:8C:E5:98:96")

# Please "JK02" (hardware version >= 6.0 and < 11.0)
# Please use "JK02_32S" if you own a new JK-BMS >= hardware version 11.0 (f.e. JK-B2A8S20P hw 11.XW, sw 11.26)
# Please use "JK04" if you have some old JK-BMS <= hardware version 3.0 (f.e. JK-B2A16S hw 3.0, sw. 3.3.0)
protocols=()
protocols+=("JK02_32S") # HW v11.x for JK-BMS-BAT01
protocols+=("JK02_24S") # HW v10.x for JK-BMS-BAT02

num=${#names[@]}
maxindex=$(($num - 1))
selected=$((-1))

# Enter hostname
#read -p "Enter hostname (only lowercase characters a-z, digits 0-9 and hypthens - are allowed): " name

# Select Configuration
#echo $selected
#echo $maxindex

while [[ $selected -gt $maxindex ]] || [[ $selected -lt 0 ]]
do
    for ((index=0;index<=$maxindex;index++))
    do
        selection=$((index+1))
        echo -e "[${selection}]"
        echo -e "\t Hostname: ${names[${index}]}"
        echo -e "\t MAC Address: ${macs[${index}]}"
        echo -e "\t Protocol: ${protocols[${index}]}"
    done

    read -p "Enter desired configuration: " selection
    selected=$((selection-1))
    name=${names[$selected]}
    mac=${macs[$selected]}
    protocol=${protocols[$selected]}
done

echo "Hostname set to <$name>"
echo "MAC Addres set to <$mac>"

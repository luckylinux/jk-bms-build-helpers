#!/bin/bash

# Store current path
currentpath=$(pwd)

# Get Parent path
parentpath=$(dirname $currentpath)

# Define Board
board="nodemcu-32s"

# Build folder
buildpath="$HOME/ESPHome"
mkdir -p $buildpath
cd $buildpath

# Create venv
#apt-get -y install python3.11-venv
python3 -m venv ./venv

# Active venv
source venv/bin/activate

# Install esphome
pip3 install esphome

# Clone this external component
#git clone https://github.com/syssi/esphome-jk-bms.git esphome-jk-bms-master
#cd esphome-jk-bms-master
#version="1.5.0"
version="2.0.0"
if [[ ! -f "esphome-jk-bms-$version.tar.gz" ]]
then
   wget https://github.com/syssi/esphome-jk-bms/archive/refs/tags/$version.tar.gz -O esphome-jk-bms-$version.tar.gz
fi

if [[ ! -d  "esphome-jk-bms-$version" ]]
then
   tar xvf esphome-jk-bms-$version.tar.gz
fi
cd esphome-jk-bms-$version

# Define ESPHome configuration file
esphomeconfig="esp32-ble-$version.yaml"

# Configure Device based on Database
source $parentpath/devices.sh

# Set Secrets
source $parentpath/secrets.sh

# Validate the configuration, create a binary, upload it, and start logs
# If you use a esp8266 run the esp8266-examle.yaml
cp $currentpath/$esphomeconfig ./$esphomeconfig

# Execute Text Replacement
source $parentpath/functions.sh
replace_text "./$esphomeconfig" "board" "$board"

# Build ESPHome
esphome run $esphomeconfig

# Change back to currentpath
cd $currentpath

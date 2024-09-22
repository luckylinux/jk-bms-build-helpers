#!/bin/bash

# Determine toolpath if not set already
relativepath="./" # Define relative path to go from this script to the root level of the tool
if [[ ! -v esphometoolpath ]]; then scriptpath=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ); esphometoolpath=$(realpath --canonicalize-missing $scriptpath/$relativepath); fi

# Get Parent path
parentpath=$(dirname $esphometoolpath)

# Define Project
projectname="esphome-jk-bms-can"

# Build Project Path
projectpath="${parentpath}/${projectname}"

# Build Configuration Path
# !! To be changed in the Future !!
configpath="${esphometoolpath}"

# Define board
board="esp32-s3-devkitc-1" # Works for Atom S3 Lite

# Define variant
variant="esp32s3" # Works for Atom S3 Lite

# Build folder
buildbasepath="$HOME/ESPHome"
mkdir -p $buildbasepath
cd $buildbasepath || exit

# Create venv
#sudo apt-get -y install python3.12-venv
#python3 -m venv ./venv

# Active venv
source venv/bin/activate

# Install ESPHome
#pip3 install esphome # Optionally specify the desired version

# Upgrade ESPHome
#pip install --upgrade esphome # Force upgrade to latest version

# Clone this external component
#git clone https://github.com/syssi/esphome-jk-bms.git esphome-jk-bms-master
#cd esphome-jk-bms-master

# Define Version
version="1.4.3"

# Define ESPHome configuration file
#esphomeconfig="esp32-ble-${version}.yaml"
esphomeconfig="esp32-ble-1.17.5.yaml"
#esphomeconfig="one-bms_JK-ALL_BLE.yaml"

# Define Build Path
buildfullpath="${buildbasepath}/${projectname}/${version}"

# Create Folder if not Exist
mkdir -p ${buildfullpath}

# No need to clone the whole Repository for a single File - It just makes stuff confusing
#if [[ ! -f "esphome-jk-bms-can-$version.tar.gz" ]]
#then
#   wget https://github.com/Sleeper85/esphome-jk-bms-can/archive/refs/tags/V$version.tar.gz -O esphome-jk-bms-can-$version.tar.gz
#fi
#if [[ ! -d  "esphome-jk-bms-can-$version" ]]
#then
#   tar xvf esphome-jk-bms-can-$version.tar.gz
#fi

# Change Folder
cd ${buildfullpath} || exit

# Echo
echo "Using ${buildfullpath} as Build Folder"

# Configure Device based on Database
source ${configpath}/devices.sh

# Validate the configuration, create a binary, upload it, and start logs
cp ${projectpath}/${esphomeconfig} ./${esphomeconfig}

# Copy all Files to the Build Folder
cp -ar ${projectpath}/* ./

# Set Secrets
source ${configpath}/secrets.sh

# Copy Required CSS/JS For Webserver into BuildFolder
#cp -r ${projectpath}/v1 ./
#cp -r ${projectpath}/v2 ./

# Execute Text Replacement
source ${esphometoolpath}/functions.sh

# Echo
echo "Using ${buildfullpath} as Build Folder"

files=$(find ${buildfullpath}/ -iname "*.yaml")
for file in $files
do
   replace_text $file "board" "$board"
   replace_text $file "variant" "$variant"
   replace_text $file "mqtt_topic_prefix" "${topic_prefix}"
done

# Clean Build Files to make sure all new/updated Entities Appear Correctly
# esphome clean $esphomeconfig

# Build ESPHome
esphome run $esphomeconfig

# Manage errors & try again
echo -e "In case of errors, it is suggested to run: esphome clean.\n"
read -p "Do you want to clean the build files & try build again: [Y/N] " tryagain
echo -e "\n"

# Clean build files and try again ?
if [ "$tryagain" == "Y" ] || [ "$tryagain" == "y" ]
then
   # Run clean & try again"
   esphome clean $esphomeconfig
   esphome run $esphomeconfig
fi

# Change back to currentpath
cd $esphometoolpath

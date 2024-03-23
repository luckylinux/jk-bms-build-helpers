#!/bin/bash

# Create a secrets.yaml containing some setup specific secrets
cat > secrets.yaml <<EOF
host_name: $name

wifi_ssid: MY_WIFI_SSID
wifi_password: MY_WIFI_PASSWORD
wifi_domain: .solar.MY_DOMAIN.TLD

jk_mac_address: $mac
jk_protocol: $protocol

project_name: Sleeper85.esphome-jk-bms-can
project_version: $version

board: $board

mqtt_host: 172.22.1.1
mqtt_port: 1883
mqtt_username: ""
mqtt_password: ""
EOF

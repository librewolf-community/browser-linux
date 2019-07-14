#!/usr/bin/env bash

# PROFILE SPECIFIC SETTINGS WILL NOT WORK, DO NOT UNCOMMENT
# Adds option to install settings if argument is passed
# if [ "$1" = "--install-settings" ]; then
#    ./install_settings;
# fi

# Sets env variables to disable dedicated profiles (which breaks in some cases)
export MOZ_LEGACY_PROFILES=1;
export SNAP_NAME="firefox";
SCRIPT_FOLDER=$(realpath $(dirname $0));
chmod +x $SCRIPT_FOLDER/librewolf;
$SCRIPT_FOLDER/librewolf "$@"; 




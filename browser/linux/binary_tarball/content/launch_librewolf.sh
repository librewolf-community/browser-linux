#!/usr/bin/env bash

INSTALL_FOLDER=$(realpath $(dirname $0));
INSTALL_SETTINGS_FOLDER=$INSTALL_FOLDER/settings;
PROFILE_SETTINGS_FOLDER=$HOME/.librewolf/settings;

# Adds option to install settings if argument is passed
if [ "$1" = "--install-settings" ]; then
    mkdir -p $PROFILE_SETTINGS_FOLDER;
    cp $INSTALL_SETTINGS_FOLDER/defaults/pref/local-settings.js $PROFILE_SETTINGS_FOLDER/local-settings.js;
    cp $INSTALL_SETTINGS_FOLDER/distribution/policies.json      $PROFILE_SETTINGS_FOLDER/policies.json;
    cp $INSTALL_SETTINGS_FOLDER/librewolf.cfg                   $PROFILE_SETTINGS_FOLDER/librewolf.cfg;
    cp $INSTALL_SETTINGS_FOLDER/toggle-settings.sh              $PROFILE_SETTINGS_FOLDER/toggle-settings.sh;
fi

# Sets up settings links
mkdir -p $INSTALL_FOLDER/defaults/pref/;
mkdir -p $INSTALL_FOLDER/distribution/;
ln -s $PROFILE_SETTINGS_FOLDER/local-settings.js $INSTALL_FOLDER/defaults/pref/local-settings.js;
ln -s $PROFILE_SETTINGS_FOLDER/policies.json $INSTALL_FOLDER/distribution/policies.json;
ln -s $PROFILE_SETTINGS_FOLDER/librewolf.cfg $INSTALL_FOLDER/librewolf.cfg;

# Sets env variables to disable dedicated profiles (which breaks some packaging methods)
export MOZ_LEGACY_PROFILES=1;
export SNAP_NAME="firefox";

# Launches librewolf
chmod +x $INSTALL_FOLDER/librewolf;
$INSTALL_FOLDER/librewolf "$@"; 




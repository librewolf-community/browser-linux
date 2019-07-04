#!/bin/bash
# Moves the settings from the main program folder to the settings folder, disabling it

SETTINGS_FOLDER=$(realpath $(dirname $0));
PROGRAM_FOLDER=$SETTINGS_FOLDER/../;

mv $PROGRAM_FOLDER/defaults/pref/local-settings.js $SETTINGS_FOLDER/defaults/pref/local-settings.js;
mv $PROGRAM_FOLDER/distribution/policies.json      $SETTINGS_FOLDER/distribution/policies.json;
mv $PROGRAM_FOLDER/librewolf.cfg                   $SETTINGS_FOLDER/librewolf.cfg;


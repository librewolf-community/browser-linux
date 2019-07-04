#!/bin/bash
# Copies settings from the settings folder to the main program folder, enabling them

SETTINGS_FOLDER=$(realpath $(dirname $0));
PROGRAM_FOLDER=$SETTINGS_FOLDER/../;

mkdir -p $PROGRAM_FOLDER/defaults/pref/;
mkdir -p $PROGRAM_FOLDER/distribution/;

cp $SETTINGS_FOLDER/defaults/pref/local-settings.js $PROGRAM_FOLDER/defaults/pref/local-settings.js;
cp $SETTINGS_FOLDER/distribution/policies.json      $PROGRAM_FOLDER/distribution/policies.json;
cp $SETTINGS_FOLDER/librewolf.cfg                   $PROGRAM_FOLDER/librewolf.cfg;

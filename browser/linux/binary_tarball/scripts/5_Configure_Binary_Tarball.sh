#!/bin/sh

PACKAGE_FILE=$1
SETTINGS_FOLDER_TO_ADD=$2 #$REPOSITORY_FOLDER/settings
LAUNCHER_SCRIPT=$3 #$SCRIPT_FOLDER/resources/launch_librewolf.sh

printf "\n\n--------------------------------- SETTINGS INTEGRATION --------------------------------------\n";

# Extracts the binary tarball
printf "\nExtracting librewolf binary tarball\n";
tar -xvf ./$PACKAGE_FILE;

# Adds the librefox config files to the packaged tarball
printf "\nCopying librewolf settings to extracted binary tarball\n";
cp -r $SETTINGS_FOLDER_TO_ADD ./librewolf/settings;
cp $LAUNCHER_SCRIPT ./librewolf/launch_librewolf.sh
mkdir -p ./librewolf/defaults/pref/;
mkdir -p ./librewolf/distribution/;

# Repacks the binary tarball
printf "\nRecompressing binary tarball\n";
tar -jcvf ./$PACKAGE_FILE librewolf;



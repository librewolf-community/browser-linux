#!/bin/sh

BINARY_TARBALL=$1
SETTINGS_FOLDER_TO_ADD=$2 
LAUNCHER_SCRIPT=$3

printf "\n\n--------------------------------- SETTINGS INTEGRATION --------------------------------------\n";

# Extracts the binary tarball
printf "\nExtracting librewolf binary tarball\n";
tar -xvf ./$BINARY_TARBALL;

# Adds the librefox config files to the packaged tarball
printf "\nCopying librewolf settings to extracted binary tarball\n";
cp -r $SETTINGS_FOLDER_TO_ADD ./librewolf/settings;
cp $LAUNCHER_SCRIPT ./librewolf/launch_librewolf.sh;
mkdir -p ./librewolf/defaults/pref/;
mkdir -p ./librewolf/distribution/;

# Repacks the binary tarball
printf "\nRecompressing binary tarball\n";
tar -jcvf ./$BINARY_TARBALL librewolf;



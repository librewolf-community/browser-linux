#!/bin/sh
printf "\n\n--------------------------------- SETTINGS INTEGRATION --------------------------------------\n";

# Setup Script Variables
BINARY_TARBALL=$1;
TOGGLE_SETTINGS_SCRIPT=$2l
LAUNCHER_SCRIPT=$3;
_EXTRACTED_TARBALL_FOLDER=./librewolf;
_SETTINGS_REPO='https://gitlab.com/librewolf-community/settings.git'; 

# Extracts the binary tarball
printf "\nExtracting librewolf binary tarball\n";
tar -xf $BINARY_TARBALL;

# Adds the librefox config files to the packaged tarball
printf "\nCopying librewolf settings to extracted binary tarball\n";

git clone $_SETTINGS_REPO $_EXTRACTED_TARBALL_FOLDER/settings;
cp $TOGGLE_SETTINGS_SCRIPT $_EXTRACTED_TARBALL_FOLDER/settings;
cp $LAUNCHER_SCRIPT $_EXTRACTED_TARBALL_FOLDER/launch_librewolf.sh;

# Repacks the binary tarball
printf "\nRecompressing binary tarball\n";
tar -jcf $BINARY_TARBALL $_EXTRACTED_TARBALL_FOLDER;



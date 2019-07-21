#!/bin/sh
printf "\n\n--------------------------------- SETTINGS INTEGRATION --------------------------------------\n";

# Setup Script Variables
BINARY_TARBALL=$1;
SETTINGS_FOLDER=$2; 
LAUNCHER_SCRIPT=$3;
_EXTRACTED_TARBALL_FOLDER=./librewolf;

# Extracts the binary tarball
printf "\nExtracting librewolf binary tarball\n";
tar -xvf $BINARY_TARBALL;

# Adds the librefox config files to the packaged tarball
printf "\nCopying librewolf settings to extracted binary tarball\n";
cp -r $SETTINGS_FOLDER $_EXTRACTED_TARBALL_FOLDER$/settings;
cp $LAUNCHER_SCRIPT $_EXTRACTED_TARBALL_FOLDER/launch_librewolf.sh;

# Repacks the binary tarball
printf "\nRecompressing binary tarball\n";
tar -jcvf $BINARY_TARBALL $_EXTRACTED_TARBALL_FOLDER;



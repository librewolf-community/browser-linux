#!/bin/sh
printf "\n------------------------------------- SCRIPT SETUP ------------------------------------------\n";

# Aborts the script upon any faliure
set -e;

# Sets up script variables
SCRIPT_FOLDER=$(realpath $(dirname $0));
REPOSITORY_FOLDER=$(realpath $SCRIPT_FOLDER/../../);
BINARY_TARBALL=$REPOSITORY_FOLDER/LibreWolf.tar.bz2;
APPIMAGE_FILE=$REPOSITORY_FOLDER/LibreWolf.AppImage;
FLATPAK_REPO=$REPOSITORY_FOLDER/librewolf-flatpak-repo;
FLATPAK_BUNDLE=$REPOSITORY_FOLDER/LibreWolf.flatpak;

$SCRIPT_FOLDER/binary_tarball/build_tarball.sh $BINARY_TARBALL;
$SCRIPT_FOLDER/appimage/build_appimage.sh $BINARY_TARBALL $APPIMAGE_FILE;
$SCRIPT_FOLDER/flatpak/build_flatpak.sh $BINARY_TARBALL $FLATPAK_REPO $FLATPAK_BUNDLE;


  

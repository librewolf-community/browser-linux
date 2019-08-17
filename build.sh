#!/bin/sh
printf "\n------------------------------------- SCRIPT SETUP ------------------------------------------\n";

# Aborts the script upon any faliure
set -e;

# Sets up script variables
SCRIPT_FOLDER=$(realpath $(dirname $0));
BINARY_TARBALL=$SCRIPT_FOLDER/LibreWolf.tar.bz2;
APPIMAGE_FILE=$SCRIPT_FOLDER/LibreWolf.AppImage;
FLATPAK_REPO=$SCRIPT_FOLDER/librewolf-flatpak-repo;
FLATPAK_BUNDLE=$SCRIPT_FOLDER/LibreWolf.flatpak;

$SCRIPT_FOLDER/binary_tarball/build_tarball.sh $BINARY_TARBALL;
$SCRIPT_FOLDER/appimage/build_appimage.sh $BINARY_TARBALL $APPIMAGE_FILE;
$SCRIPT_FOLDER/flatpak/build_flatpak.sh $BINARY_TARBALL $FLATPAK_REPO $FLATPAK_BUNDLE;

#!/bin/sh
printf "\n------------------------------------- SCRIPT SETUP ------------------------------------------\n";

# Aborts the script upon any faliure
set -e;

# Sets up script variables
SCRIPT_FOLDER=$(realpath $(dirname $0));
REPOSITORY_FOLDER=$(realpath $SCRIPT_FOLDER/../../);
BINARY_TARBALL_SOURCE_FOLDER=$SCRIPT_FOLDER/compile;
BINARY_TARBALL_SOURCE_CONTENT_FOLDER=$REPOSITORY_FOLDER/browser/common/source_files/;
BINARY_TARBALL_SETTINGS_FOLDER=$REPOSITORY_FOLDER/settings;
BINARY_TARBALL_LAUNCH_SCRIPT=$SCRIPT_FOLDER/binary_tarball/content/launch_librewolf.sh;
BINARY_TARBALL=$REPOSITORY_FOLDER/LibreWolf.tar.bz2;
APPIMAGE_CONTENT=$SCRIPT_FOLDER/appimage/content;
APPIMAGE_FILE=$REPOSITORY_FOLDER/LibreWolf.AppImage;
FLATPAK_JSON_FILE=$SCRIPT_FOLDER/flatpak/content/io.gitlab.LibreWolf.json;
FLATPAK_REPO=$REPOSITORY_FOLDER/librewolf-flatpak-repo;
FLATPAK_BUNDLE=$REPOSITORY_FOLDER/LibreWolf.flatpak;

# Executes the build
$SCRIPT_FOLDER/binary_tarball/scripts/1_Install_Dependencies.sh;
$SCRIPT_FOLDER/binary_tarball/scripts/2_Download_Source_Code.sh $BINARY_TARBALL_SOURCE_FOLDER;
$SCRIPT_FOLDER/binary_tarball/scripts/3_Configure_Source_Code.sh $BINARY_TARBALL_SOURCE_FOLDER $BINARY_TARBALL_SOURCE_CONTENT_FOLDER;
$SCRIPT_FOLDER/binary_tarball/scripts/4_Build_Binary_Tarball.sh $BINARY_TARBALL_SOURCE_FOLDER $BINARY_TARBALL;
$SCRIPT_FOLDER/binary_tarball/scripts/5_Configure_Binary_Tarball.sh $BINARY_TARBALL $BINARY_TARBALL_SETTINGS_FOLDER $BINARY_TARBALL_LAUNCH_SCRIPT;
$SCRIPT_FOLDER/appimage/build_appimage.sh $BINARY_TARBALL $APPIMAGE_CONTENT $APPIMAGE_FILE;
$SCRIPT_FOLDER/flatpak/build_flatpak.sh $BINARY_TARBALL $FLATPAK_JSON_FILE $FLATPAK_REPO $FLATPAK_BUNDLE;


  

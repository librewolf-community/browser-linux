#!/bin/sh
printf "\n------------------------------------- SCRIPT SETUP ------------------------------------------\n";

# Aborts the script upon any faliure
set -e;

# Sets up internal script variables
printf "\nSetting up script variables\n";
SCRIPT_FOLDER=$(realpath $(dirname $0)) && printf "SCRIPT_FOLDER: $SCRIPT_FOLDER\n";
REPOSITORY_FOLDER=$(realpath $SCRIPT_FOLDER/../../) && printf "REPOSITORY_FOLDER: $REPOSITORY_FOLDER\n";
SOURCE_FOLDER=$SCRIPT_FOLDER/compile && printf "SOURCE_FOLDER: $SOURCE_FOLDER\n";
SOURCE_CONTENT_FOLDER=$REPOSITORY_FOLDER/browser/common/source_files/ && printf "SOURCE_CONTENT_FOLDER: $SOURCE_CONTENT_FOLDER\n";
BINARY_TARBALL=$REPOSITORY_FOLDER/LibreWolf.tar.bz2 && printf "BINARY_TARBALL: $BINARY_TARBALL\n";
APPIMAGE_FILE=$REPOSITORY_FOLDER/LibreWolf.AppImage

$SCRIPT_FOLDER/binary_tarball/scripts/1_Install_Dependencies.sh;
$SCRIPT_FOLDER/binary_tarball/scripts/2_Download_Source_Code.sh $SOURCE_FOLDER;
$SCRIPT_FOLDER/binary_tarball/scripts/3_Configure_Source_Code.sh $SOURCE_FOLDER $SOURCE_CONTENT_FOLDER;
$SCRIPT_FOLDER/binary_tarball/scripts/4_Build_Binary_Tarball.sh $SOURCE_FOLDER $BINARY_TARBALL;
$SCRIPT_FOLDER/binary_tarball/scripts/5_Configure_Binary_Tarball.sh $BINARY_TARBALL $REPOSITORY_FOLDER/settings $SCRIPT_FOLDER/binary_tarball/content/launch_librewolf.sh;

$SCRIPT_FOLDER/appimage/build_appimage.sh $BINARY_TARBALL $SCRIPT_FOLDER/appimage/content $APPIMAGE_FILE;


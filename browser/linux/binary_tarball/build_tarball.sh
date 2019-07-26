#!/bin/sh
printf "\n------------------------------------- BINARY TARBALL BUILD ------------------------------------------\n";

# Aborts the script upon any faliure
set -e;

# Sets up script variables
BINARY_TARBALL=$1;
_SCRIPT_FOLDER=$(realpath $(dirname $0));
_REPOSITORY_FOLDER=$(realpath $_SCRIPT_FOLDER/../../../);
_BINARY_TARBALL_SOURCE_FOLDER=$_SCRIPT_FOLDER/compile;
_BINARY_TARBALL_SOURCE_CONTENT_FOLDER=$_REPOSITORY_FOLDER/browser/common/source_files/;
_BINARY_TARBALL_SETTINGS_FOLDER=$_REPOSITORY_FOLDER/settings;
_BINARY_TARBALL_LAUNCH_SCRIPT=$_SCRIPT_FOLDER/binary_tarball/content/launch_librewolf.sh;

# Executes the build
$_SCRIPT_FOLDER/scripts/1_Install_Dependencies.sh;
$_SCRIPT_FOLDER/scripts/2_Download_Source_Code.sh $_BINARY_TARBALL_SOURCE_FOLDER;
$_SCRIPT_FOLDER/scripts/3_Configure_Source_Code.sh $_BINARY_TARBALL_SOURCE_FOLDER $_BINARY_TARBALL_SOURCE_CONTENT_FOLDER;
$_SCRIPT_FOLDER/scripts/4_Build_Binary_Tarball.sh $_BINARY_TARBALL_SOURCE_FOLDER $BINARY_TARBALL;
$_SCRIPT_FOLDER/scripts/5_Configure_Binary_Tarball.sh $BINARY_TARBALL $_BINARY_TARBALL_SETTINGS_FOLDER $_BINARY_TARBALL_LAUNCH_SCRIPT;


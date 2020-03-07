#!/bin/bash
printf "\n------------------------------------- BINARY TARBALL BUILD ------------------------------------------\n";

# Aborts the script upon any faliure
set -e;

# Sets up script variables
BINARY_TARBALL=$1;
_SCRIPT_FOLDER=$(realpath $(dirname $0));
_SOURCE_FOLDER=$_SCRIPT_FOLDER/compile;
_TOGGLE_SETTINGS_SCRIPT=$_SCRIPT_FOLDER/content/toggle-settings.sh;
_LAUNCH_SCRIPT=$_SCRIPT_FOLDER/content/launch_librewolf.sh;

# Executes the build
$_SCRIPT_FOLDER/scripts/1_Install_Dependencies.sh;
$_SCRIPT_FOLDER/scripts/2_Download_Source_Code.sh $_SOURCE_FOLDER;
$_SCRIPT_FOLDER/scripts/3_Configure_Source_Code.sh $_SOURCE_FOLDER;
$_SCRIPT_FOLDER/scripts/4_Build_Binary_Tarball.sh $_SOURCE_FOLDER $BINARY_TARBALL;
$_SCRIPT_FOLDER/scripts/5_Configure_Binary_Tarball.sh $BINARY_TARBALL $_TOGGLE_SETTINGS_SCRIPT  $_LAUNCH_SCRIPT;


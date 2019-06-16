#!/bin/bash
printf "\n------------------------------------- SCRIPT SETUP ------------------------------------------\n";

# Prevents build from breaking in CI/CD environments
export SHELL=/bin/bash;

# Sets up internal script variables
printf "\nSetting up script variables\n";
SCRIPT_FOLDER=$(realpath $(dirname $0));
REPOSITORY_FOLDER=$(realpath $SCRIPT_FOLDER/../);
printf "SCRIPT_FOLDER: $SCRIPT_FOLDER\n";
printf "REPOSITORY_FOLDER: $REPOSITORY_FOLDER\n";

# Installs some needed dependencies
printf "\nInstalling script dependencies\n";
sudo apt update;
sudo apt install python python3 inkscape wget -y;

printf "\n\n------------------------------------ ICON GENERATION ----------------------------------------\n";

ICON_FILE=$REPOSITORY_FOLDER/branding/icon/icon.svg;
BRANDING_FOLDER=$SCRIPT_FOLDER/resources/source_files/browser/branding/librewolf;
printf "\nGenerating icons from $ICON_FILE and moving to $BRANDING_FOLDER\n";

# Linux Icons
inkscape -z -f $ICON_FILE -e $BRANDING_FOLDER/default16.png -w 16 -h16;
inkscape -z -f $ICON_FILE -e $BRANDING_FOLDER/default32.png -w 32 -h32;
inkscape -z -f $ICON_FILE -e $BRANDING_FOLDER/default48.png -w 48 -h48;
inkscape -z -f $ICON_FILE -e $BRANDING_FOLDER/default64.png -w 64 -h64;
inkscape -z -f $ICON_FILE -e $BRANDING_FOLDER/default128.png -w 128 -h128;

# Windows Icons
inkscape -z -f $ICON_FILE -e $BRANDING_FOLDER/VisualElements_70.png -w 70 -h70;
inkscape -z -f $ICON_FILE -e $BRANDING_FOLDER/VisualElements_150.png -w 150 -h150;

# TODO: Add Apple Icons

printf "\n\n--------------------------------------- PREBUILD --------------------------------------------\n";

# Downloads and runs bootstrapper to install dependencies.
printf "\nRunning bootstrapper to install build dependencies\n";
wget -nv -O - \
https://hg.mozilla.org/mozilla-central/raw-file/default/python/mozboot/bin/bootstrap.py \
| python - --application-choice=browser --no-interactive;

# adds the new rust install to PATH
printf "\nAdding new rust install to PATH\n";
. $HOME/.cargo/env;

printf "\n\n---------------------------------------- BUILD ----------------------------------------------\n";

# Creates and enters the folder where compiling will take place
printf "\nCreating compile folder\n";
mkdir compile_folder; 
cd compile_folder;

# Clones the firefox source code for compiling
printf "\nCloning Firefox Source Code\n";
hg clone https://hg.mozilla.org/releases/mozilla-release;

# Copies our branding to the source code, changing it from firefox to librewolf
printf "\nCopying branding to firefox source code\n";
cp -r $SCRIPT_FOLDER/resources/source_files/* mozilla-release;

# Bootstraps, builds and packages librewolf
cd mozilla-release;
printf "\nRunning bootstrapper to install build dependencies\n";
./mach bootstrap --application-choice=browser --no-interactive;
printf "\nBuilding LibreWolf\n";
./mach build;
printf "\nPackaging LibreWolf\n";
./mach package;
cd $SCRIPT_FOLDER;

printf "\n\n-------------------------------------- POSTBUILD --------------------------------------------\n";

# moves the packaged tarball to the main folder
printf "\nRelocating binary tarball to script folder\n"
cp ./compile_folder/mozilla-release/obj*/dist/librewolf*.tar.bz2 ./;

# Remove the compile folder
printf "\nDeleting the compile_folder\n";
rm -rf ./compile_folder;

printf "\n\n--------------------------------- SETTINGS INTEGRATION --------------------------------------\n";

# Adds the librefox config files to the packaged tarball
PACKAGE_FILE_NAME="librewolf*.tar.bz2\n";
printf "\nExtracting librewolf binary tarball\n";
tar -xvf ./$PACKAGE_FILE_NAME;
printf "\nCopying librewolf settings to extracted binary tarball\n";
cp -r $REPOSITORY_FOLDER/settings/* ./librewolf;
printf "\nRecompressing binary tarball\n";
tar -jcvf ./$PACKAGE_FILE_NAME librewolf;
printf "\nDeleting extracted binary tarball folder\n";
rm -rvf ./librewolf;

# BUILD APP IMAGE #################################################################################
# cp -r $BINARY_FOLDER ./app_image_build_folder
# Adds the librefox config files to the packaged tarball
# PACKAGE_FILE_NAME="librewolf*.tar.bz2";
# tar -xvf ./$PACKAGE_FILE_NAME;
# cp -r ../settings/* ./librewolf;
# tar -jcvf ./$PACKAGE_FILE_NAME librewolf;
# rm -rvf ./librewolf;



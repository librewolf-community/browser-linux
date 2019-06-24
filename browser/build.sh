#!/bin/bash
printf "\n------------------------------------- SCRIPT SETUP ------------------------------------------\n";

# Prevents build from breaking in CI/CD environments
export SHELL=/bin/bash;

# Sets up internal script variables
printf "\nSetting up script variables\n";
SCRIPT_FOLDER=$(realpath $(dirname $0));
REPOSITORY_FOLDER=$(realpath $SCRIPT_FOLDER/../);
BRANDING_FOLDER=$SCRIPT_FOLDER/resources/source_files/browser/branding/librewolf;
ICON_FOLDER=$REPOSITORY_FOLDER/branding/icon/;
PACKAGE_FILE="librewolf*.tar.bz2";
APPIMAGE_RESOURCE_FOLDER=$SCRIPT_FOLDER/resources/appimage;
printf "SCRIPT_FOLDER: $SCRIPT_FOLDER\n";
printf "REPOSITORY_FOLDER: $REPOSITORY_FOLDER\n";
printf "BRANDING_FOLDER: $BRANDING_FOLDER\n";
printf "ICON_FOLDER: $ICON_FOLDER\n";
printf "PACKAGE_FILE: $PACKAGE_FILE\n";
printf "APPIMAGE_RESOURCE_FOLDER: $APPIMAGE_RESOURCE_FOLDER\n";

# Installs some needed dependencies
printf "\nInstalling script dependencies\n";
apt update;
apt install sudo python python3 inkscape icnsutils wget fuse libfuse-dev kmod -y;

# Loads the FUSE kernel module
sudo depmod;
sudo modprobe fuse;

printf "\n\n---------------------------------- ICON GENERATION ------------------------------------------\n";

printf "\nGenerating icons from $ICON_FOLDER and moving to $BRANDING_FOLDER\n";

# Linux Icons
inkscape -z -f $ICON_FOLDER/icon.svg -e $BRANDING_FOLDER/default16.png -w 16 -h 16;
inkscape -z -f $ICON_FOLDER/icon.svg -e $BRANDING_FOLDER/default32.png -w 32 -h 32;
inkscape -z -f $ICON_FOLDER/icon.svg -e $BRANDING_FOLDER/default48.png -w 48 -h 48;
inkscape -z -f $ICON_FOLDER/icon.svg -e $BRANDING_FOLDER/default64.png -w 64 -h 64;
inkscape -z -f $ICON_FOLDER/icon.svg -e $BRANDING_FOLDER/default128.png -w 128 -h 128;

# Windows Icons
inkscape -z -f $ICON_FOLDER/icon.svg -e $BRANDING_FOLDER/VisualElements_70.png -w 70 -h70;
inkscape -z -f $ICON_FOLDER/icon.svg -e $BRANDING_FOLDER/VisualElements_150.png -w 150 -h150;

# TODO: Add Apple Icons
png2icns $BRANDING_FOLDER/firefox.icns $BRANDING_FOLDER/default128.png;

inkscape -z -f $ICON_FOLDER/document-icon.svg -e $BRANDING_FOLDER/document-icon.png -w 128 -h 128;
png2icns $BRANDING_FOLDER/document.icns $BRANDING_FOLDER/document-icon.png;
rm -r $BRANDING_FOLDER/document-icon.png
printf "\n\n-------------------------------------- PREBUILD ---------------------------------------------\n";

# Downloads and runs bootstrapper to install dependencies.
printf "\nRunning bootstrapper to install build dependencies\n";
wget https://hg.mozilla.org/mozilla-central/raw-file/default/python/mozboot/bin/bootstrap.py;
python ./bootstrap.py --application-choice=browser --no-interactive;

# adds the new rust install to PATH
printf "\nAdding new rust install to PATH\n";
. $HOME/.cargo/env;

printf "\n\n--------------------------------------- BUILD -----------------------------------------------\n";

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

cd mozilla-release;

# Bootstraps librewolf again (using the ./mach script inside the source code)
printf "\nRunning bootstrapper to install build dependencies (using ./mach script within source code)\n";
./mach bootstrap --application-choice=browser --no-interactive;

# Builds librewolf
printf "\nBuilding LibreWolf\n";
./mach build;

# Packages LibreWolf
printf "\nPackaging LibreWolf\n";
./mach package;

cd $SCRIPT_FOLDER;

# moves the packaged tarball to the main folder
printf "\nRelocating binary tarball to script folder\n"
cp ./compile_folder/mozilla-release/obj*/dist/librewolf*.tar.bz2 ./;

printf "\n\n--------------------------------- SETTINGS INTEGRATION --------------------------------------\n";

# Extracts the binary tarball
printf "\nExtracting librewolf binary tarball\n";
tar -xvf ./$PACKAGE_FILE;

# Adds the librefox config files to the packaged tarball
printf "\nCopying librewolf settings to extracted binary tarball\n";
cp -r $REPOSITORY_FOLDER/settings/* ./librewolf;

# Repacks the binary tarball
printf "\nRecompressing binary tarball\n";
tar -jcvf ./$PACKAGE_FILE librewolf;

# Moves the final binary tarball to build_output
printf "\nMoving binary tarball to build_output folder\n";
mv $PACKAGE_FILE $SCRIPT_FOLDER/build_output/;

printf "\n\n------------------------------------ APPIMAGE BUILD -----------------------------------------\n";

# Copy and generate icons
printf "\nGenerating AppImage Icons\n";
cp $ICON_FOLDER/icon.svg $APPIMAGE_RESOURCE_FOLDER/librewolf.svg;
ln -rs $APPIMAGE_RESOURCE_FOLDER/librewolf.svg $SCRIPT_FOLDER/resources/appimage/.DirIcon;

# Copy appimage resources to main tarball
printf "Copying AppImage resources to binary tarball folder\n";
cp -vrT $APPIMAGE_RESOURCE_FOLDER ./librewolf;

# Downloads appimage tool
printf "\nDownloading AppImage Tool\n";
wget https://github.com/AppImage/AppImageKit/releases/latest/download/appimagetool-x86_64.AppImage;
chmod +x ./appimagetool-x86_64.AppImage;

# Generate AppImage
printf "\nGenerating AppImage\n";
./appimagetool-x86_64.AppImage ./librewolf;
chmod +x ./LibreWolf*.AppImage; 

# Move AppImage to build_output folder
printf "\nMoving AppImage to build_output folder\n";
mv ./LibreWolf*.AppImage ./build_output;

printf "\n\n---------------------------------------- CLEANUP --------------------------------------------\n";

# Remove the compile folder
printf "\nDeleting the compile_folder\n";
rm -rf ./compile_folder;

# Delete the extracted binary tarball folder
printf "\nDeleting extracted binary tarball folder\n";
rm -rf ./librewolf;

# Delete the appimage tool
printf "\nRemoving AppImage tool\n";
rm -f ./appimagetool-x86_64.AppImage

# Delete the bootstrapper script
printf "\nRemoving bootstrapper.py\n";
rm -f ./bootstrap.py;

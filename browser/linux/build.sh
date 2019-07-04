#!/bin/bash
printf "\n------------------------------------- SCRIPT SETUP ------------------------------------------\n";

# Prevents build from breaking in CI/CD environments
export SHELL=/bin/bash;
printf "SHELL=$SHELL\n";

# Aborts the script upon any faliure
set -e;

# Sets up internal script variables
printf "\nSetting up script variables\n";
SCRIPT_FOLDER=$(realpath $(dirname $0));
REPOSITORY_FOLDER=$(realpath $SCRIPT_FOLDER/../../);
SOURCE_FOLDER=$REPOSITORY_FOLDER/browser/common/source_files/
BRANDING_FOLDER=$SOURCE_FOLDER/browser/branding/librewolf;
ICON_FOLDER=$REPOSITORY_FOLDER/branding/icon/;
PACKAGE_FILE="librewolf*.tar.bz2";
APPIMAGE_RESOURCE_FOLDER=$SCRIPT_FOLDER/resources/appimage;
printf "SCRIPT_FOLDER: $SCRIPT_FOLDER\n";
printf "REPOSITORY_FOLDER: $REPOSITORY_FOLDER\n";
printf "SOURCE_FOLDER: $SOURCE_FOLDER\n";
printf "BRANDING_FOLDER: $BRANDING_FOLDER\n";
printf "ICON_FOLDER: $ICON_FOLDER\n";
printf "PACKAGE_FILE: $PACKAGE_FILE\n";
printf "APPIMAGE_RESOURCE_FOLDER: $APPIMAGE_RESOURCE_FOLDER\n";

printf "\n\n-------------------------------------- PREBUILD ---------------------------------------------\n";

# Installs some needed dependencies
printf "\nInstalling script dependencies\n";
apt update;
apt install python python3 inkscape icnsutils wget -y;

# Downloads and runs bootstrapper to install more dependencies.
printf "\nRunning bootstrapper to install build dependencies\n";
wget https://hg.mozilla.org/mozilla-central/raw-file/default/python/mozboot/bin/bootstrap.py;
python ./bootstrap.py --application-choice=browser --no-interactive || true
rm -f ./bootstrap.py;

# adds the new rust install to PATH
printf "\nAdding new rust install to PATH\n";
. $HOME/.cargo/env;

printf "\n\n---------------------------------- ICON GENERATION ------------------------------------------\n";
# Generates Icons for branding
printf "\nGenerating icons from $ICON_FOLDER and moving to $BRANDING_FOLDER\n";

# Generates Linux Icons
printf "\nGenerating Linux Icons\n";
inkscape -z -f $ICON_FOLDER/icon.svg -e $BRANDING_FOLDER/default16.png -w 16 -h 16;
inkscape -z -f $ICON_FOLDER/icon.svg -e $BRANDING_FOLDER/default32.png -w 32 -h 32;
inkscape -z -f $ICON_FOLDER/icon.svg -e $BRANDING_FOLDER/default48.png -w 48 -h 48;
inkscape -z -f $ICON_FOLDER/icon.svg -e $BRANDING_FOLDER/default64.png -w 64 -h 64;
inkscape -z -f $ICON_FOLDER/icon.svg -e $BRANDING_FOLDER/default128.png -w 128 -h 128;

# Generates Windows Icons
printf "\nGenerating Windows Icons\n";
inkscape -z -f $ICON_FOLDER/icon.svg -e $BRANDING_FOLDER/VisualElements_70.png -w 70 -h70;
inkscape -z -f $ICON_FOLDER/icon.svg -e $BRANDING_FOLDER/VisualElements_150.png -w 150 -h150;

# Generates Apple Icons
printf "\nGenerating Apple Icons\n";
png2icns $BRANDING_FOLDER/firefox.icns $BRANDING_FOLDER/default128.png;
inkscape -z -f $ICON_FOLDER/document-icon.svg -e $BRANDING_FOLDER/document-icon.png -w 128 -h 128;
png2icns $BRANDING_FOLDER/document.icns $BRANDING_FOLDER/document-icon.png;
rm -r $BRANDING_FOLDER/document-icon.png

printf "\n\n--------------------------------- SOURCE CODE DOWNLOAD --------------------------------------\n";

# Creates and enters the folder where compiling will take place
printf "\nCreating compile folder\n";
mkdir -p compile_folder; 
cd compile_folder;

# Clones the firefox source code for compiling
printf "\nCloning Firefox Source Code\n";
hg clone https://hg.mozilla.org/releases/mozilla-release;
cd mozilla-release;

printf "\n\n------------------------------ FINAL PREBUILD CONFIGURATION ---------------------------------\n";

# Copies our branding to the source code, changing it from firefox to librewolf
printf "\nCopying branding to firefox source code\n";
cp -r $SOURCE_FOLDER/* ./;

# Disables pocket
printf "\nDisabling Pocket\n";
sed -i "s/'pocket'/#'pocket'/g" ./browser/components/moz.build;

printf "\n\n--------------------------------------- BUILD -----------------------------------------------\n";

# Bootstraps librewolf again (using the ./mach script inside the source code)
printf "\nRunning bootstrapper to install build dependencies (using ./mach script within source code)\n";
./mach bootstrap --application-choice=browser --no-interactive;

# Builds librewolf
printf "\nBuilding LibreWolf\n";
./mach build;

# Packages LibreWolf
printf "\nPackaging LibreWolf\n";
./mach package;

# moves the packaged tarball to the script folder
printf "\nRelocating binary tarball to script folder\n";
cp ./obj*/dist/librewolf*.tar.bz2 $SCRIPT_FOLDER;

# Remove the compile folder
printf "\nDeleting the compile_folder\n";
cd $SCRIPT_FOLDER;
rm -rf ./compile_folder;


printf "\n\n--------------------------------- SETTINGS INTEGRATION --------------------------------------\n";

# Extracts the binary tarball
printf "\nExtracting librewolf binary tarball\n";
tar -xvf ./$PACKAGE_FILE;

# Adds the librefox config files to the packaged tarball
printf "\nCopying librewolf settings to extracted binary tarball\n";
cp -r $REPOSITORY_FOLDER/settings ./librewolf/settings;

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
wget https://github.com/AppImage/AppImageKit/releases/latest/download/appimagetool-x86_64.AppImage -O appimagetool;
chmod +x ./appimagetool;
./appimagetool --appimage-extract;

# Generate AppImage
printf "\nGenerating AppImage\n";
./squashfs-root/AppRun ./librewolf;
chmod +x ./LibreWolf*.AppImage; 

# Move AppImage to build_output folder
printf "\nMoving AppImage to build_output folder\n";
mv ./LibreWolf*.AppImage ./build_output;

# Delete the appimage tool
printf "\nRemoving AppImage tool\n";
rm -f ./appimagetool;
rm -rf ./squashfs-root;

# Delete the extracted binary tarball folder
printf "\nDeleting extracted binary tarball folder\n";
rm -rf ./librewolf;

#printf "\n\n---------------------------------------- FLATPAK BUILD --------------------------------------------\n";
#sudo apt install flatpak-builder;


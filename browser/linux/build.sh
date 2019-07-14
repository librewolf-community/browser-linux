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
FLATPAK_MANIFEST_FILE=$SCRIPT_FOLDER/resources/flatpak/io.gitlab.LibreWolf.json;
printf "SCRIPT_FOLDER: $SCRIPT_FOLDER\n";
printf "REPOSITORY_FOLDER: $REPOSITORY_FOLDER\n";
printf "SOURCE_FOLDER: $SOURCE_FOLDER\n";
printf "BRANDING_FOLDER: $BRANDING_FOLDER\n";
printf "ICON_FOLDER: $ICON_FOLDER\n";
printf "PACKAGE_FILE: $PACKAGE_FILE\n";
printf "APPIMAGE_RESOURCE_FOLDER: $APPIMAGE_RESOURCE_FOLDER\n";
printf "FLATPAK_MANIFEST_FILE: $FLATPAK_MANIFEST_FILE\n";

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
cp $SCRIPT_FOLDER/resources/launch_librewolf.sh ./librewolf/launch_librewolf.sh
mkdir -p $INSTALL_FOLDER/defaults/pref/;
mkdir -p $INSTALL_FOLDER/distribution/;

printf "\n\n--------------------------------- BINARY TARBALL RECREATION --------------------------------------\n";

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


printf "\n\n---------------------------------------- FLATPAK BUILD --------------------------------------------\n";

# Install flatpak
printf "\nInstalling Flatpak Builder\n";
sudo add-apt-repository -y ppa:alexlarsson/flatpak;
sudo apt update;
sudo apt install -y flatpak flatpak-builder;

# Install build dependencies
printf "\nInstalling flatpak build dependencies\n";
flatpak install -y org.gnome.Platform//3.32 org.gnome.Sdk//3.32;

# Prepare for flatpak build
printf "\nPreparing files for flatpak build\n";
mkdir "source";
cp -r ./librewolf ./source/librewolf;

# Build Repo and standalone bundle
printf "\nBuilding flatpak repository and bundle\n";
flatpak-builder --repo=librewolf-flatpak-repo build-dir $FLATPAK_MANIFEST_FILE;
flatpak build-bundle librewolf-flatpak-repo LibreWolf.flatpak $FLATPAK_MANIFEST_FILE master;

# move repo and bundle to build output here
printf "\nMoving repository and bundle to build output folder\n";
mv libreWolf-flatpak-repo build_output;
mv LibreWolf.flatpak build_output;

# Clean up flatpak files
printf "\nCleaning up flatpak related files\n";
rm -rf ./build-dir;
rm -rf ./source;
rm -rf ./.flatpak-builder;

# Delete the extracted binary tarball folder
printf "\nDeleting extracted binary tarball folder\n";
rm -rf ./librewolf;

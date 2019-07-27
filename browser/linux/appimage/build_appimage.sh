#!/bin/sh
printf "\n\n------------------------------------ APPIMAGE BUILD -----------------------------------------\n";

# Aborts the script upon any faliure
set -e;

# Sets up script variables
BINARY_TARBALL=$1
APPIMAGE_FILE=$2
SCRIPT_FOLDER=$(realpath $(dirname $0));
_BINARY_TARBALL_EXTRACTED_FOLDER=$SCRIPT_FOLDER/librewolf;
_BUILD_APPIMAGE_FILE=$SCRIPT_FOLDER/LibreWolf*.AppImage;
_APPIMAGETOOL_DOWNLOAD_URL=https://github.com/AppImage/AppImageKit/releases/latest/download/appimagetool-x86_64.AppImage;
_APPIMAGETOOL_EXTRACTED_FOLDER=$SCRIPT_FOLDER/squashfs-root;
_APPIMAGETOOL_FILE=$SCRIPT_FOLDER/appimagetool;
_APPIMAGE_CONTENT_FOLDER=$SCRIPT_FOLDER/content

# Extracts the binary tarball
printf "\nExtracting librewolf binary tarball\n";
tar -xvf $BINARY_TARBALL;

# Copy appimage resources to main tarball
printf "Copying AppImage resources to binary tarball folder\n";
cp -vrT $_APPIMAGE_CONTENT_FOLDER $_BINARY_TARBALL_EXTRACTED_FOLDER;

# Downloads appimage tool
printf "\nDownloading AppImage Tool\n";
wget $_APPIMAGETOOL_DOWNLOAD_URL -O $_APPIMAGETOOL_FILE;
chmod +x $_APPIMAGETOOL_FILE;
$_APPIMAGETOOL_FILE --appimage-extract;
rm -f $_APPIMAGETOOL_FILE;

# Generate AppImage
printf "\nGenerating AppImage\n";
$_APPIMAGETOOL_EXTRACTED_FOLDER/AppRun $_BINARY_TARBALL_EXTRACTED_FOLDER;
rm -rf $_BINARY_TARBALL_EXTRACTED_FOLDER;
rm -rf $_APPIMAGETOOL_EXTRACTED_FOLDER;
chmod +x $_BUILD_APPIMAGE_FILE; 

# Move AppImage to specified location
printf "\nMoving AppImage to specified location\n";
mv $_BUILD_APPIMAGE_FILE $APPIMAGE_FILE;



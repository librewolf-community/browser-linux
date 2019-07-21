#!/bin/sh
printf "\n\n------------------------------------ APPIMAGE BUILD -----------------------------------------\n";

# Sets up script variables
BINARY_TARBALL=$1
APPIMAGE_CONTENT_FOLDER=$2
APPIMAGE_FILE=$3
_BINARY_TARBALL_EXTRACTED_FOLDER=./librewolf;
_BUILD_APPIMAGE_FILE=./LibreWolf*.AppImage;
_APPIMAGETOOL_DOWNLOAD_URL=https://github.com/AppImage/AppImageKit/releases/latest/download/appimagetool-x86_64.AppImage;
_APPIMAGETOOL_EXTRACTED_FOLDER=./squashfs-root;
_APPIMAGETOOL_FILE=./appimagetool;

# Extracts the binary tarball
printf "\nExtracting librewolf binary tarball\n";
tar -xvf $BINARY_TARBALL;

# Copy appimage resources to main tarball
printf "Copying AppImage resources to binary tarball folder\n";
cp -vrT $APPIMAGE_CONTENT_FOLDER $_BINARY_TARBALL_EXTRACTED_FOLDER;

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
printf "\nMoving AppImage to build_output folder\n";
mv $_BUILD_APPIMAGE_FILE $APPIMAGE_FILE;



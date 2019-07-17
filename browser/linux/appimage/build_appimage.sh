#!/bin/sh

APPIMAGE_CONTENT_FOLDER=$1 #$SCRIPT_FOLDER/resources/appimage;
BINARY_TARBALL=$2
OUTPUT_FOLDER=$3

_LIBREWOLF_EXTRACTED_FOLDER=./librewolf;
_LIBREWOLF_FINAL_APPIMAGE=./LibreWolf*.AppImage;
_APPIMAGETOOL_DOWNLOAD_URL=https://github.com/AppImage/AppImageKit/releases/latest/download/appimagetool-x86_64.AppImage;
_APPIMAGETOOL_FILE=./appimagetool;

printf "\n\n------------------------------------ APPIMAGE BUILD -----------------------------------------\n";

printf "APPIMAGE_RESOURCE_FOLDER: $APPIMAGE_CONTENT_FOLDER\n";

# Copy and generate icons
# printf "\nGenerating AppImage Icons\n";
# cp $ICON_FOLDER/icon.svg $APPIMAGE_CONTENT_FOLDER/librewolf.svg;
# ln -rs $APPIMAGE_CONTENT_FOLDER/librewolf.svg $SCRIPT_FOLDER/resources/appimage/.DirIcon;

# Copy appimage resources to main tarball
printf "Copying AppImage resources to binary tarball folder\n";
cp -vrT $APPIMAGE_CONTENT_FOLDER $_LIBREWOLF_EXTRACTED_FOLDER;

# Downloads appimage tool
printf "\nDownloading AppImage Tool\n";
wget $_APPIMAGETOOL_DOWNLOAD_URL -O $_APPIMAGETOOL_FILE;
chmod +x $_APPIMAGETOOL_FILE;
$_APPIMAGETOOL_FILE --appimage-extract;
rm -f $_APPIMAGETOOL_FILE;

# Generate AppImage
printf "\nGenerating AppImage\n";
./squashfs-root/AppRun $_LIBREWOLF_EXTRACTED_FOLDER;
rm -rf ./squashfs-root;
chmod +x $_LIBREWOLF_FINAL_APPIMAGE; 

# Move AppImage to build_output folder
printf "\nMoving AppImage to build_output folder\n";
mv $_LIBREWOLF_FINAL_APPIMAGE $OUTPUT_FOLDER;

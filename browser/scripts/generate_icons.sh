#!/bin/bash

SRC_DIR=`dirname $0`;

# update these if the location/name of this script, the main icon file or the branding folder changes
ICON_FILE_PATH=$SRC_DIR/../../branding/icon/icon.svg;
BRANDING_FOLDER_PATH=$SRC_DIR/../source_files/browser/branding/librewolf;

# generate icons and moves them to the branding folder
echo Generating icons from $ICON_FILE_PATH and moving to $BRANDING_FOLDER_PATH;

# Linux Icons
inkscape --without-gui --file=$ICON_FILE_PATH --export-png=$BRANDING_FOLDER_PATH/default16.png --export-width=16 --export-height=16;
inkscape --without-gui --file=$ICON_FILE_PATH --export-png=$BRANDING_FOLDER_PATH/default32.png --export-width=32 --export-height=32;
inkscape --without-gui --file=$ICON_FILE_PATH --export-png=$BRANDING_FOLDER_PATH/default48.png --export-width=48 --export-height=48;
inkscape --without-gui --file=$ICON_FILE_PATH --export-png=$BRANDING_FOLDER_PATH/default64.png --export-width=64 --export-height=64;
inkscape --without-gui --file=$ICON_FILE_PATH --export-png=$BRANDING_FOLDER_PATH/default128.png --export-width=128 --export-height=128;

# Windows Icons
inkscape --without-gui --file=$ICON_FILE_PATH --export-png=$BRANDING_FOLDER_PATH/VisualElements_70.png --export-width=70 --export-height=70;
inkscape --without-gui --file=$ICON_FILE_PATH --export-png=$BRANDING_FOLDER_PATH/VisualElements_150.png --export-width=150 --export-height=150;

# Apple Icons

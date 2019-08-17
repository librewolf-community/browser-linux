#!/bin/sh
printf "\n\n------------------------------ FINAL PREBUILD CONFIGURATION ---------------------------------\n";

# Setup Script Variables
SOURCE_CODE_FOLDER=$1;
SOURCE_CODE_CUSTOMIZATION_FOLDER=$2;
_POCKET_SED_STRING="s/'pocket'/#'pocket'/g";
_POCKET_FILE=$SOURCE_CODE_FOLDER/browser/components/moz.build;

# Copy Source Code Changes to Source Code
printf "\nCopying branding and source code changes to firefox source code\n";
cp -r $SOURCE_CODE_CUSTOMIZATION_FOLDER/* $SOURCE_CODE_FOLDER/;

# Disables Pocket
printf "\nDisabling Pocket\n";
sed -i $_POCKET_SED_STRING $_POCKET_FILE;


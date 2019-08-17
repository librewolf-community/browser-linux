#!/bin/sh
printf "\n\n------------------------------ FINAL PREBUILD CONFIGURATION ---------------------------------\n";

# Setup Script Variables
SOURCE_CODE_FOLDER=$1;
_COMMON_REPO='https://gitlab.com/librewolf-community/browser/common.git';
_POCKET_SED_STRING="s/'pocket'/#'pocket'/g";
_POCKET_FILE=$SOURCE_CODE_FOLDER/browser/components/moz.build;

# Copy Source Code Changes to Source Code
printf "\nCopying branding and source code changes to firefox source code\n";
git clone $_COMMON_REPO common;
cp -r common/source_files/* $SOURCE_CODE_FOLDER/;
rm -rf common;

# Disables Pocket
printf "\nDisabling Pocket\n";
sed -i $_POCKET_SED_STRING $_POCKET_FILE;


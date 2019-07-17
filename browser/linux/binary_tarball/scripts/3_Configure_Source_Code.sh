#!/bin/sh

SOURCE_CODE_FOLDER=$1
FOLDER_TO_ADD=$2

printf "\n\n------------------------------ FINAL PREBUILD CONFIGURATION ---------------------------------\n";

# Copies our custom source code changes (mostly branding) to the source code
printf "\nCopying custom files to firefox source code\n";
cp -r $FOLDER_TO_ADD/* $SOURCE_CODE_FOLDER/;

# Disables pocket
printf "\nDisabling Pocket\n";
sed -i "s/'pocket'/#'pocket'/g" $SOURCE_CODE_FOLDER/browser/components/moz.build;


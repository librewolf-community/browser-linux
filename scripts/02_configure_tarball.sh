#!/bin/bash
set -e

printf "\n\n---------------- prepare package for other distros ----------------\n"

# Setup Script Variables

# use $CI_PROJECT_DIR unless not in CI, then assign script path
CI_PROJECT_DIR=${CI_PROJECT_DIR:-$(realpath $(dirname $0)/../)}
OUTPUT_TARBALL=$CI_PROJECT_DIR/LibreWolf.${CARCH}.tar.bz2
SOURCE_CODE_BINARY_TARBALL_LOCATION="$CI_PROJECT_DIR/src/firefox-*/obj*/dist/librewolf*.tar.bz2"
EXTRACTED_TARBALL_FOLDER=$CI_PROJECT_DIR/librewolf_unpacked/librewolf

# Prevents build from breaking in CI/CD environments
export SHELL=/bin/bash

# Moves the packaged tarball to the specified location
printf "\nMoving Binary Tarball to output location\n"
mv $SOURCE_CODE_BINARY_TARBALL_LOCATION $OUTPUT_TARBALL

# Extracts the binary tarball
printf "\nExtracting librewolf binary tarball\n"
mkdir librewolf_unpacked
tar -xf $OUTPUT_TARBALL -C librewolf_unpacked

# Adds the librefox config files to the packaged tarball
printf "\nCopying librewolf settings to extracted binary tarball\n"

cp -r $CI_PROJECT_DIR/src/settings $EXTRACTED_TARBALL_FOLDER/settings
cp $CI_PROJECT_DIR/content/toggle-settings.sh $EXTRACTED_TARBALL_FOLDER/settings
cp $CI_PROJECT_DIR/content/launch_librewolf.sh $EXTRACTED_TARBALL_FOLDER/launch_librewolf.sh

# Repacks the binary tarball
printf "\nRecompressing binary tarball\n"
tar -jvcf $OUTPUT_TARBALL -C $EXTRACTED_TARBALL_FOLDER .

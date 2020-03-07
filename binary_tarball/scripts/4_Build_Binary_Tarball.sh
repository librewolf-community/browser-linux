#!/bin/bash
printf "\n\n--------------------------------------- BUILD -----------------------------------------------\n";

# Setup Script Variables
SOURCE_FOLDER=$1;
OUTPUT_TARBALL=$2;
_SOURCE_CODE_BINARY_TARBALL_LOCATION="./obj*/dist/librewolf*.tar.bz2";

# Prevents build from breaking in CI/CD environments
export SHELL=/bin/bash;

# Changes current folder to the source code folder
cd $SOURCE_FOLDER;

# Runs bootstrapper to install dependencies
printf "\nRunning bootstrapper to install build dependencies (using ./mach script within source code)\n";
./mach bootstrap --application-choice=browser --no-interactive;

# Executes the actual build
printf "\nBuilding LibreWolf\n";
./mach build;

# Packages the build into a binary tarball
printf "\nPackaging LibreWolf\n";
./mach package;

# Moves the packaged tarball to the specified location
printf "\nMoving Binary Tarball to output location\n";
mv $_SOURCE_CODE_BINARY_TARBALL_LOCATION $OUTPUT_TARBALL;

# Deletes the source code
printf "\nDeleting source code\n";
rm -rf $SOURCE_FOLDER;


#!/bin/bash

# PREBUILD ########################################################################################

# Prevents build from breaking in CI/CD environments
export SHELL=/bin/bash;

# Downloads and immediately runs bootstrapper to install dependencies.
wget -nv -O - \
https://hg.mozilla.org/mozilla-central/raw-file/default/python/mozboot/bin/bootstrap.py \
| python - --application-choice=browser --no-interactive;

# adds the new rust install to PATH
. $HOME/.cargo/env;

# Downloads further dependencies
sudo apt install inkscape;

# BUILD ###########################################################################################
# Creates and enters the folder where compiling will take place
mkdir work_dir; 
cd work_dir;

# Clones the firefox source code for compiling
hg clone https://hg.mozilla.org/releases/mozilla-release;

# Generates and extracts our branding to the source code, changing it from firefox to librewolf
../scripts/generate_icons.sh;
cp -r ../source_files/* mozilla-release;

# Bootstraps, builds and packages librewolf
cd mozilla-release;
./mach bootstrap --application-choice=browser --no-interactive;
./mach build;
./mach package;

# POSTBUILD #######################################################################################

# moves the packaged tarball to the main folder
cd ../../;
cp ./work_dir/mozilla-release/obj*/dist/librewolf*.tar.bz2 ./;

# Adds the librefox config files to the packaged tarball
PACKAGE_FILE_NAME="librewolf*.tar.bz2";
tar -xvf ./$PACKAGE_FILE_NAME;
cp -r ../settings/* ./librewolf;
tar -jcvf ./$PACKAGE_FILE_NAME librewolf;
rm -rvf ./librewolf;

# Cleanup #########################################################################################
# todo: remove work dir


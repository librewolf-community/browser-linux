#!/bin/sh
printf "\n\n---------------------------------------- FLATPAK BUILD --------------------------------------------\n";

# Setup Script Variables
BINARY_TARBALL=$1;
FLATPAK_JSON_FILE=$2;
FLATPAK_REPO=$3;
FLATPAK_BUNDLE=$4;
_APT_SOURCE_LIST=/etc/apt/source.list;
_APT_REPO='deb http://ppa.launchpad.net/alexlarsson/flatpak/ubuntu bionic main'
_APT_REPO_KEY=FA577F07;
_APT_PACKAGES_TO_INSTALL="flatpak flatpak-builder";
_FLATHUB_REPO="flathub https://flathub.org/repo/flathub.flatpakrepo";
_FLATHUB_PACKAGES_TO_INSTALL="org.gnome.Platform/x86_64/3.32 org.gnome.Sdk/x86_64/3.32";
_EXTRACTED_BINARY_TARBALL_FOLDER=./librewolf
_FLATPAK_BUILD_SOURCE_FOLDER=./source;
_FLATPAK_BUILD_FOLDER=build-dir;


# Install flatpak
printf "\nInstalling flatpak\n";
echo $_APT_REPO >> $_APT_SOURCE_LIST;
apt update && apt install -y gnupg2 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $_APT_REPO_KEY;
apt update;
apt install -y $_APT_PACKAGES_TO_INSTALL;

# Install build dependencies
printf "\nInstalling flatpak build dependencies\n";
flatpak remote-add --if-not-exists $_FLATHUB_REPO;
flatpak install -y $_FLATHUB_PACKAGES_TO_INSTALL;

# Extracts the binary tarball
printf "\nExtracting librewolf binary tarball\n";
tar -xvf $BINARY_TARBALL;

# Prepare for flatpak build
printf "\nPreparing files for flatpak build\n";
mkdir $_FLATPAK_BUILD_SOURCE_FOLDER && mv -r $_EXTRACTED_BINARY_TARBALL_FOLDER $_FLATPAK_BUILD_SOURCE_FOLDER/librewolf;

# Build Repo and standalone bundle
printf "\nBuilding flatpak repository and bundle\n";
flatpak-builder --repo=$FLATPAK_REPO $_FLATPAK_BUILD_FOLDER $FLATPAK_JSON_FILE;
flatpak build-bundle $FLATPAK_REPO $FLATPAK_BUNDLE io.gitlab.LibreWolf master;

# Clean up flatpak files
printf "\nCleaning up flatpak related files\n";
rm -rf $_FLATPAK_BUILD_FOLDER;
rm -rf $_FLATPAK_BUILD_SOURCE_FOLDER;
rm -rf ./.flatpak-builder;

# Delete the extracted binary tarball folder
printf "\nDeleting extracted binary tarball folder\n";
rm -rf $_EXTRACTED_BINARY_TARBALL_FOLDER;

#!/bin/bash
printf "\n\n---------------------------------------- FLATPAK BUILD --------------------------------------------\n";

# Aborts the script upon any faliure
set -e;

# Setup Script Variables
BINARY_TARBALL=$1;
FLATPAK_REPO=$2;
FLATPAK_BUNDLE=$3;
_SCRIPT_FOLDER=$(realpath $(dirname $0));
_FLATHUB_REPO="flathub https://flathub.org/repo/flathub.flatpakrepo";
_FLATHUB_PACKAGES_TO_INSTALL="org.gnome.Platform/${CARCH}/3.38 org.gnome.Sdk/${CARCH}/3.38 org.freedesktop.Platform//19.08 org.freedesktop.Sdk//19.08";
_EXTRACTED_BINARY_TARBALL_FOLDER=$_SCRIPT_FOLDER/librewolf
_FLATPAK_JSON_FILE=$_SCRIPT_FOLDER/content/io.gitlab.LibreWolf.json;
_FLATPAK_BUILD_SOURCE_FOLDER=$_SCRIPT_FOLDER/source;
_FLATPAK_BUILD_FOLDER=build-dir;


if [[ ! -z "${TARBALL_URL}" ]];then
  apt update && apt install -y wget
  wget "${TARBALL_URL}"
fi

if [[ ! -f "${BINARY_TARBALL}" ]];then
  echo "Tarball not provided via pipeline or download."
  exit 1
fi

# Install build dependencies
printf "\nInstalling flatpak build dependencies\n";

# we're using a pre-prepared flatpak-image witch aarch64
apt update && apt install -y software-properties-common
add-apt-repository -y ppa:alexlarsson/flatpak
apt update && apt install -y flatpak-builder bzip2
flatpak remote-add --if-not-exists $_FLATHUB_REPO;
flatpak install -y flathub $_FLATHUB_PACKAGES_TO_INSTALL;

# Extracts the binary tarball
printf "\nExtracting librewolf binary tarball\n";
mkdir -p $_EXTRACTED_BINARY_TARBALL_FOLDER;
tar -xvf $BINARY_TARBALL -C $_EXTRACTED_BINARY_TARBALL_FOLDER;

# Prepare for flatpak build
printf "\nPreparing files for flatpak build\n";
mkdir -p $_FLATPAK_BUILD_SOURCE_FOLDER;
mv $_EXTRACTED_BINARY_TARBALL_FOLDER $_FLATPAK_BUILD_SOURCE_FOLDER;

# Build Repo
printf "\nBuilding flatpak repository\n";
cp "$_FLATPAK_JSON_FILE" ./;

# add appstream metadata
# TODO: firefox uses files/share/appdata/ in their flatpak, but https://docs.flatpak.org/en/latest/conventions.html says otherwise. which is "more" correct? => using both for now, just in case...
install -Dvm644 "$_FLATPAK_BUILD_SOURCE_FOLDER/librewolf/io.gitlab.LibreWolf.appdata.xml" "$_SCRIPT_FOLDER/source/share/metainfo/io.gitlab.LibreWolf.appdata.xml"
install -Dvm644 "$_FLATPAK_BUILD_SOURCE_FOLDER/librewolf/io.gitlab.LibreWolf.appdata.xml" "$_SCRIPT_FOLDER/source/share/appdata/LibreWolf.appdata.xml"

install -Dvm644 "$_SCRIPT_FOLDER/content/io.gitlab.LibreWolf.desktop" "$_SCRIPT_FOLDER/source/share/applications/LibreWolf.desktop"

install -Dvm644 "$_FLATPAK_BUILD_SOURCE_FOLDER/librewolf/browser/chrome/icons/default/default128.png" "$_SCRIPT_FOLDER/source/share/icons/hicolor/128x128/apps/io.gitlab.LibreWolf.png"

flatpak-builder --disable-rofiles-fuse --repo="$FLATPAK_REPO" "$_FLATPAK_BUILD_FOLDER" io.gitlab.LibreWolf.json;

# Build bundle
printf "\nBuilding flatpak bundle\n";
flatpak build-bundle $FLATPAK_REPO $FLATPAK_BUNDLE io.gitlab.LibreWolf master;

# Clean up flatpak files
printf "\nCleaning up flatpak related files\n";
rm -rf $_FLATPAK_BUILD_FOLDER;
rm -rf $_FLATPAK_BUILD_SOURCE_FOLDER;
# keep it cached
# rm -rf ./.flatpak-builder;

# Delete the extracted binary tarball folder
printf "\nDeleting extracted binary tarball folder\n";
rm -rf $_EXTRACTED_BINARY_TARBALL_FOLDER;

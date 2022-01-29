#!/bin/bash
printf "\n\n--------------------------------- SOURCE CODE DOWNLOAD --------------------------------------\n";

set -e

if [[ -z ${pkgver} || -z ${pkgrel} ]]; then
    echo '$pkgrel and/or $pkgver not provided'
    exit 1
fi
# Setup Script Variables
SOURCE_FOLDER=$1;
_SOURCE_CODE_URL="https://archive.mozilla.org/pub/firefox/releases/$pkgver/source/firefox-$pkgver.source.tar.xz";
_SIG_URL="$_SOURCE_CODE_URL.asc";
_SOURCE_TAR="firefox-${pkgver}.tar.xz"
_SOURCE_SIG="$_SOURCE_TAR.asc"
_GPG_HOMEDIR=$(mktemp -d)

# Downloading and Extracting Firefox Source Code
printf "\nDownloading Firefox Source Code\n";
wget -O $_SOURCE_TAR $_SOURCE_CODE_URL
wget -O $_SOURCE_SIG $_SIG_URL

# Verify signature
gpg --homedir "$_GPG_HOMEDIR" --import KEY
gpgv --keyring "$_GPG_HOMEDIR"/pubring.kbx "$_SOURCE_SIG" "$_SOURCE_TAR"

mkdir -p $SOURCE_FOLDER
tar -x --strip-components=1 -C $SOURCE_FOLDER -f $_SOURCE_TAR

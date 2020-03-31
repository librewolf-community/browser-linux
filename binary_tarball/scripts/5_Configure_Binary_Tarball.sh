#!/bin/bash
printf "\n\n--------------------------------- SETTINGS INTEGRATION --------------------------------------\n";

# Aborts the script upon any faliure
set -e;

# Setup Script Variables
BINARY_TARBALL=$1;
TOGGLE_SETTINGS_SCRIPT=$2;
LAUNCHER_SCRIPT=$3;
CI_PROJECT_DIR=${CI_PROJECT_DIR:-$(realpath $(dirname $0)/../../)}
_SCRIPT_FOLDER=$(realpath $(dirname $0));
_EXTRACTED_TARBALL_FOLDER=$_SCRIPT_FOLDER/librewolf;
_SETTINGS_REPO='https://gitlab.com/librewolf-community/settings.git';

# Extracts the binary tarball
printf "\nExtracting librewolf binary tarball\n";
mkdir -p $_EXTRACTED_TARBALL_FOLDER
tar --strip-components=1 -xf $BINARY_TARBALL -C $_EXTRACTED_TARBALL_FOLDER

# Adds the librefox config files to the packaged tarball
printf "\nCopying librewolf settings to extracted binary tarball\n";

git clone $_SETTINGS_REPO $_EXTRACTED_TARBALL_FOLDER/settings;
# no need to keep that in there:
rm -rf "${_EXTRACTED_TARBALL_FOLDER}/settings/.git";
cp $TOGGLE_SETTINGS_SCRIPT $_EXTRACTED_TARBALL_FOLDER/settings;
cp $LAUNCHER_SCRIPT $_EXTRACTED_TARBALL_FOLDER/launch_librewolf.sh;

# Somewhat crude workaround to use settings per default
# until we've worked out how to use `--install-settings` with links
# in all major packages instead
printf "\nWorkaround: auto-enable Settings\n"
cp -r $_EXTRACTED_TARBALL_FOLDER/settings/* $_EXTRACTED_TARBALL_FOLDER;

# Add distribution.ini
distini="$_EXTRACTED_TARBALL_FOLDER/distribution/distribution.ini"

install -Dvm644 /dev/stdin "$distini" <<END
[Global]
id=io.gitlab.LibreWolf
version=1.0
about=LibreWolf

[Preferences]
app.distributor="LibreWolf Community"
app.distributor.channel=librewolf
app.partner.librewolf=librewolf
END

# Create Appstream metadate file
export DATE=$(date +%Y-%m-%d)
envsubst < ${_SCRIPT_FOLDER}/../content/io.gitlab.LibreWolf.appdata.xml.in > ${_EXTRACTED_TARBALL_FOLDER}/io.gitlab.LibreWolf.appdata.xml

# Repacks the binary tarball
printf "\nRecompressing binary tarball\n";
tar -jvcf $BINARY_TARBALL -C $_EXTRACTED_TARBALL_FOLDER .

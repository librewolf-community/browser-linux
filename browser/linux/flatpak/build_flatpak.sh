
printf "\n\n---------------------------------------- FLATPAK BUILD --------------------------------------------\n";

# Install flatpak
# Installs some needed dependencies
printf "\nInstalling script dependencies\n";
apt update;
apt install -y gnupg2;

echo 'deb http://ppa.launchpad.net/alexlarsson/flatpak/ubuntu bionic main' >>  /etc/apt/source.list;
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FA577F07;
apt update;
apt install -y flatpak flatpak-builder;

# Install build dependencies
printf "\nInstalling flatpak build dependencies\n";
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo;
flatpak install -y org.gnome.Platform/x86_64/3.32 org.gnome.Sdk/x86_64/3.32;

# Prepare for flatpak build
printf "\nPreparing files for flatpak build\n";
mkdir "source";
cp -r ./librewolf ./source/librewolf;
cp $SCRIPT_FOLDER/resources/flatpak/io.gitlab.LibreWolf.json ./io.gitlab.LibreWolf.json;

# Build Repo and standalone bundle
printf "\nBuilding flatpak repository and bundle\n";
flatpak-builder --repo=librewolf-flatpak-repo build-dir io.gitlab.LibreWolf.json;
flatpak build-bundle librewolf-flatpak-repo LibreWolf.flatpak io.gitlab.LibreWolf master;

# move repo and bundle to build output here
printf "\nMoving repository and bundle to build output folder\n";
mv libreWolf-flatpak-repo build_output;
mv LibreWolf.flatpak build_output;

# Clean up flatpak files
printf "\nCleaning up flatpak related files\n";
rm -rf ./build-dir;
rm -rf ./source;
rm -rf ./.flatpak-builder;

# Delete the extracted binary tarball folder
printf "\nDeleting extracted binary tarball folder\n";
rm -rf ./librewolf;

This Repository contains all the required material to build the browser on Linux platforms.

### Important

The following instructions are currently outdated. The build scripts are currently meant to be
run in a CI environment with Docker containers and gitlab-runners. Updated instructions for
local builds or setting up your own appropriate runners will be provided again in the future.

### Requirements
* Ubuntu or Linux Mint (Bionic or later)

### Notes
* As this script installs files during the build, it is recommended to run this script in a VM or installation dedicated to building.
* You will occassionally need to enter your sudo password. Running this script as root has not been tested
* This script has been tested with Linux Mint 19.1
* The flatpak build is not ready yet.

### Instructions
* Run build.sh inside this folder. (*NOTE*: This is currently only semi-functional. A rework of this script is in the making.)
* Packages will be saved in the repository root folder.

## Other builds
* [Gentoo](https://gitlab.com/librewolf-community/browser/gentoo)
* [macOS](https://gitlab.com/librewolf-community/browser/macos)

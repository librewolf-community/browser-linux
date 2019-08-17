#!/bin/sh
printf "\n\n-------------------------------------- DEPENDENCY INSTALLATION ---------------------------------------------\n";

# Setup Script Variables
_DEPENDENCIES="mercurial wget";

# Installs Dependencies
printf "\nInstalling dependencies\n";
apt-get -qq update;
apt-get -qqy install  $_DEPENDENCIES; 

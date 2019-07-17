#!/bin/sh

COMPILE_FOLDER=$1

printf "\n\n--------------------------------- SOURCE CODE DOWNLOAD --------------------------------------\n";
# Clones the firefox source code for compiling
printf "\nCloning Firefox Source Code\n";
hg clone https://hg.mozilla.org/releases/mozilla-release $COMPILE_FOLDER;


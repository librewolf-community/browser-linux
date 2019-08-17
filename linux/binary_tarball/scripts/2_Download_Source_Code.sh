#!/bin/sh
printf "\n\n--------------------------------- SOURCE CODE DOWNLOAD --------------------------------------\n";

# Setup Script Variables
SOURCE_FOLDER=$1;
_SOURCE_CODE_URL="https://hg.mozilla.org/releases/mozilla-release";

# Clone Firefox Source Code
printf "\nCloning Firefox Source Code\n";
hg clone $_SOURCE_CODE_URL $SOURCE_FOLDER;


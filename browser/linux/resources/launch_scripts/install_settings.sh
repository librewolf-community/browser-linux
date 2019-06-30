#!/usr/bin/env bash
# The purpose of this file is to automatically install the librewolf settings into every profile that exists in the
# profiles.ini file.
#
# This script is intended to be called at librewolf startup.
#
# This script should be used from the librewolf source code, otherwise the settings data folder must be specified below
#
# This script does not overwrite the settings files if they exist, so feel free to customize your per profile configurations
#
# For Reference, profiles can be found in: /home/<username>/.librewolf/

LIBREWOLF_FOLDER=$HOME/.librewolf;
PROFILE_FILE=${LIBREWOLF_FOLDER}/profiles.ini;
SCRIPT_FOLDER=$(realpath $(dirname $0));
SETTINGS_DATA_FOLDER=$SCRIPT_FOLDER/settings;

profile_folders=();

# Get profile folders from profiles.ini --------------------------------------------------------------------------------
function get_profile_folders() {
    while IFS= read -r line; do # reads file line by line, saving each line to $line
        if [[ ${line} == "Path="* ]]; then # checks if $line starts with "Path="
            IFS='='; read -ra split_line <<< "$line"; # splits the line on '=' storing values in the $split_line array
            path=${split_line[1]}; # gets the path from the second element of the array
            if [[ ${path} != /* ]]; then
                path=${LIBREWOLF_FOLDER}/${path};
            fi
            profile_folders+=(${path}) # appends the second element of split_line array (the path) to $profile_folders
        fi
    done < ${PROFILE_FILE}
}

# Install script to profile folders -------------------------------------------------------------------------------------
function add_settings_to_folder() {
    get_profile_folders;
    for profile_folder in "${profile_folders[@]}"
    do
        echo "Adding settings to" ${profile_folder}
        cp -rvn ${SETTINGS_DATA_FOLDER} $profile_folder/
       # do whatever on $i
    done
}

add_settings_to_folder;

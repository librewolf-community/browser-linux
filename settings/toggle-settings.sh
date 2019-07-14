#!/bin/bash

SCRIPT_FOLDER=$(realpath $(dirname $0));

# Enable settings ------------------------------------------------------------------------------------------
if [ "$1" = "--enable" ]; then
    mv $SCRIPT_FOLDER/"[DISABLED] local-settings.js"     $SCRIPT_FOLDER/local-settings.js;
    mv $SCRIPT_FOLDER/"[DISABLED] policies.json"         $SCRIPT_FOLDER/policies.json;
    mv $SCRIPT_FOLDER/"[DISABLED] librewolf.cfg"         $SCRIPT_FOLDER/librewolf.cfg;
fi 

# Disable settings ------------------------------------------------------------------------------------------
if [ "$1" = "--disable" ]; then
    mv $SCRIPT_FOLDER/local-settings.js $SCRIPT_FOLDER/"[DISABLED] local-settings.js";
    mv $SCRIPT_FOLDER/policies.json     $SCRIPT_FOLDER/"[DISABLED] policies.json";
    mv $SCRIPT_FOLDER/librewolf.cfg     $SCRIPT_FOLDER/"[DISABLED] librewolf.cfg" ;
fi



#!/usr/bin/env bash

# Exit script with a non-zero exit code if:
# - any command fails (-e | --errexit)
# - any variable is unset (-u | --nounset)
# - a part of a piped sequence fails (-o pipefail)
set -euo pipefail

SCRIPT_FOLDER=$(realpath $(dirname $0));

# Enable settings ------------------------------------------------------------------------------------------
if [[ "${1}" = "--enable" ]]; then
    mv "${SCRIPT_FOLDER}/[DISABLED] local-settings.js"    "${SCRIPT_FOLDER}/local-settings.js";
    mv "${SCRIPT_FOLDER}/[DISABLED] policies.json"        "${SCRIPT_FOLDER}/policies.json";
    mv "${SCRIPT_FOLDER}/[DISABLED] librewolf.cfg"        "${SCRIPT_FOLDER}/librewolf.cfg";
# Disable settings ------------------------------------------------------------------------------------------
elif [[ "${1}" = "--disable" ]]; then
    mv "${SCRIPT_FOLDER}/local-settings.js" "${SCRIPT_FOLDER}/[DISABLED] local-settings.js";
    mv "${SCRIPT_FOLDER}/policies.json"     "${SCRIPT_FOLDER}/[DISABLED] policies.json";
    mv "${SCRIPT_FOLDER}/librewolf.cfg"     "${SCRIPT_FOLDER}/[DISABLED] librewolf.cfg";
fi

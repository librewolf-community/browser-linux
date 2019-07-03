#!/bin/bash
# This script will move the settings back to the storage folder, disabling it

mv ../defaults/pref/local-settings.js ./defaults/pref/local-settings.js;
mv ../distribution/policies.json ./distribution/policies.json;
mv ../librewolf.cfg ./librewolf.cfg;


#!/bin/sh

printf "\n\n-------------------------------------- DEPENDENCY INSTALLATION ---------------------------------------------\n";
printf "\nInstalling dependencies\n";
apt update && apt install -y python python3 wget;
wget https://hg.mozilla.org/mozilla-central/raw-file/default/python/mozboot/bin/bootstrap.py;
python ./bootstrap.py --application-choice=browser --no-interactive || true
rm -f ./bootstrap.py;

# adds the new rust install to PATH
# printf "\nAdding new rust install to PATH\n";
#. $HOME/.cargo/env;

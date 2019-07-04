![Logo](../branding/logo/Logo.svg.png)

# LibreWolf: Browse With Freedom
[![Website Badge](https://img.shields.io/badge/Website-librewolf.gitlab.io-blue.svg)](https://LibreWolf.gitlab.io)
[![Gitter Badge](https://badges.gitter.im/librewolf-community/librewolf.svg)](https://gitter.im/librewolf-community/librewolf)
[![Releases Badge](https://img.shields.io/badge/Releases-green.svg)](https://gitlab.com/librewolf-community/librewolf/releases)
[![Status Badge](https://img.shields.io/badge/Maintained-Yes-green.svg)](https://gitlab.com/librewolf-community/librewolf/commits/master)
[![Pipelines Badge](https://gitlab.com/librewolf-community/librewolf/badges/master/pipeline.svg)](https://gitlab.com/librewolf-community/librewolf/pipelines)
[![License Badge](https://img.shields.io/badge/License-Mozilla--MPL2-blue.svg)](https://www.mozilla.org/en-US/MPL/2.0/)

This project is an independent fork of Firefox, with the primary goals of privacy security and user freedom. It is the community run successor to [LibreFox](https://github.com/intika/Librefox)

LibreWolf uses more than 500 privacy/security/performance settings, patches, LibreWolf-Addons (optional) and is designed to minimize data collection and telemetry as much as possible (updater, crashreporter and Firefox's integrated addons that don't respect privacy are removed).

**LibreWolf is NOT associated with Mozilla or its products.**

## Features

- Latest Version of Firefox: LibreWolf is compiled directly from the latest build of Firefox Nightly. As a result, you will have the most bleeding edge of features, technologies and security updates. Stable builds are also planned in the future.
- Completely Independent Build: LibreWolf uses a completely independent build from Firefox and has its own settings, profile folder and installation path. As a result, it can be installed alongside Firefox or any other browser.
- Extensions firewall: limit internet access for extensions ([firewall-test-feature](#extensions-firewall-))
- IJWY (I Just Want You To Shut Up): embedded server links and other calling home functions are removed ([zero unauthorized connection](#ijwy-i-just-want-you-to-shut-up) by default).
- User settings updates: gHacks/pyllyukko base is kept up to date.
- Settings protection: important settings are enforced/locked within `librewolf.cfg` and `policies.json`, those settings cannot be changed by addons/updates/LibreWolf itself or unwanted/accidental manipulation; To change those settings you can easily do it by editing `librewolf.cfg` and `policies.json`.
- LibreWolf-addons: set of optional LibreWolf extensions
- Statistics disabled: telemetry and similar functions are disabled
- Tested settings: settings are performance aware
- ESR and Tor version (LibreWolf TBB Beta)
- Tor LibreWolf-addons: adapted LibreWolf extensions for TBB
- Multi-platform (Windows/Linux/Mac/and soon Android)
- Dark theme (classic and advanced)
- Recommended and *code reviewed* addons list
- Community-Driven
- And much more...

## Download and Installation

### Linux

#### Manual Compilation 

- Build instruction will be updated soon

#### AppImage

LibreWolf is available in an AppImage Format. Check out the [releases page](https://gitlab.com/librewolf-community/librewolf/-/releases) for downloads.

#### Binary Tarball

LibreWolf is available as a binary tarball. Check out the [releases page](https://gitlab.com/librewolf-community/librewolf/-/releases) for downloads.


#### Arch

LibreWolf is available on the AUR in both [source code](https://aur.archlinux.org/packages/librewolf/) and [binary](https://aur.archlinux.org/packages/librewolf-bin) format.


### Windows

- Build instruction will be updated soon

### Mac

- Build instruction will be updated soon

## Roadmap

See https://gitlab.com/librewolf-community/librewolf/issues

## About

**License:** [Mozilla Public License 2.0](https://gitlab.com/librewolf-community/librewolf/blob/master/LICENSE)

**Inspired from:** [ungoogled-chromium](https://github.com/Eloston/ungoogled-chromium)

**Based on:** [Librefox](https://github.com/intika/Librefox), whose development seems to have halted.

**Acknowledgement**, special thanks to:

- @intika for putting Librefox together
- The Mozilla team for their amazing work on Firefox
- The gHacks-User team for allowing the usage of their work
- All the stargazers (users that are encouraging this project by starring it)
- Icon was created with images by [OpenClipart-Vectors](https://pixabay.com/users/OpenClipart-Vectors-30363/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=157677) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=157677)
- Icons made by <a href="https://www.flaticon.com/authors/vaadin" title="Vaadin">Vaadin</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a>



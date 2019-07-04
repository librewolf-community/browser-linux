<p align="center">
    <a href="https://gitlab.com/librewolf-community/librewolf/"><img width="727" src="../branding/logo/Logo.svg.png"></a>
</p>

# LibreWolf: Browse With Freedom

<p align="center">
    <a href="https://gitter.im/librewolf-community/librewolf?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge" target="_blank"><img src="https://badges.gitter.im/librewolf-community/librewolf.svg"></a>
    <a href="https://gitlab.com/librewolf-community/librewolf/releases" target="_blank"><img src="https://img.shields.io/badge/Download-%20LibreWolf-green.svg"> </a>
    <a href="https://gitlab.com/librewolf-community/librewolf/releases"><img src="https://img.shields.io/badge/Version-0.0.1-green.svg"></a>
    <a href="https://gitlab.com/librewolf-community/librewolf/commits/master"><img src="https://img.shields.io/badge/Maintained-Yes-green.svg"></a>
    <a href="https://gitlab.com/librewolf-community/librewolf/commits/master"><img alt="pipeline status" src="https://gitlab.com/librewolf-community/librewolf/badges/master/pipeline.svg" /></a>
    <a href="https://www.mozilla.org/en-US/MPL/2.0/" target="_blank"><img src="https://img.shields.io/badge/License-Mozilla--MPL2-blue.svg"></a>
</p>

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

---

## Index

- [Extensions Firewall](#extensions-firewall)
    - [Description](#description)
    - [The Settings](#the-settings)
    - [Blocking A Domain](#blocking-a-domain)
    - [Blocking The Network](#blocking-the-network)
    - [More Infos](#more-infos)
- [IJWY (I Just Want You To Shut Up)](#ijwy-i-just-want-you-to-shut-up)
- [Edit Locked Settings](#edit-locked-settings)
- [Browser Tests](#browser-tests)
    - [Security/Fingerprint](#security/fingerprint)
    - [Performances](#performances)
    - [DNS/VPN/Proxy Leak](#dnsvpnproxy-leak)
- [About](#about)
- [LibreWolf Roadmap](#librewolf-roadmap)
    - [Objectives for future versions of LibreWolf (this-may-change)](#objectives-for-future-versions-of-librewolf-this-may-change)
    - [Todo for future versions of LibreWolf (this-may-change)](#todo-for-future-versions-of-librewolf-this-may-change)
- [Cookies Settings](#cookies-settings)
- [Tracking Protection](#tracking-protection)
- [Comparing Changes And Updates](#comparing-changes-and-updates)
- [Documentation](#documentation)
- [LibreWolf Dark Theme](#librewolf-dark-theme)
- [Tuning LibreWolf](#tuning-librewolf)
    - [Restart Button](#restart-button)
    - [Alternative Dark Theme](#alternative-dark-theme)
    - [Linux Fix Text Colors](#linux-fix-text-colors)
    - [LibreWolf Addons For ESR And Tor](#librewolf-addons-for-esr-and-tor)
- [Tor Compatibility](#tor-compatibility)




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

## LibreWolf Roadmap

See https://gitlab.com/librewolf-community/librewolf/issues


## Tuning LibreWolf

### Restart Button

One simple solution is to bookmark `about:restartrequired` or `about:profiles`. When restart is needed open that page and click "normal restart". You can even go further and add the bookmarks links to your icons bar and rename the link to an empty text (you will then have a direct icon to `about:profiles` and a 2 clicks restart).

![capture](https://user-images.githubusercontent.com/6892180/48963055-bd914000-ef82-11e8-8ea4-a58e56f5c4a4.png)
...



### Linux Fix Text Colors

On Linux when using a dark desktop theme LibreWolf could display white text over white background or black text on black input on some sites or addons, this is fixed in LibreWolf with `lockPref("ui.use_standins_for_native_colors", true);`.

If `ui.use_standins_for_native_colors` is not enough to fix everything you can fix this issue with an other additional solution by using the following values in `about:config` (you need to have Adwaita theme installed) [more details](https://github.com/DmitriK/darkContrast#text-contrast-for-dark-themes) (Note that this is not needed with the default LibreWolf settings as it is already fixed)

```
widget.content.allow-gtk-dark-theme;false
widget.chrome.allow-gtk-dark-theme;false
widget.content.gtk-theme-override;Adwaita:light
```

### LibreWolf Addons For ESR And Tor

- [LibreWolf HTTP Watcher ESR - Tor MoD](https://addons.mozilla.org/en-US/firefox/addon/LibreWolf-http-watcher-tor-mod/): Change the url bar color on http and onion sites (to green/red)
- [LibreWolf NoHTTP - Tor MoD](https://addons.mozilla.org/en-US/firefox/addon/nohttp-LibreWolf-mod-for-tor/): Block http traffic and/or redirect it to https (Excellent replacement for the unrecommended https-everywhere)

## Tor Compatibility

We do not recommend connecting over Tor on LibreWolf classic version (because of the missing LibreWolf-Tor-Addons, they are only included in the tor version for obvious reasons), use instead LibreWolf-Tor version if your threat model calls for it, or for accessing hidden services (Thus said tor settings have been enabled since v2 on all LibreWolf versions for user toriffying/proxifying their entire connection).

Currently LibreWolf-TBB is in beta test, Tor compatibility may change.




## Documentation

`librewolf.cfg`: Locking and defaulting LibreWolf settings for security, privacy and performance.

`Policies.json`: Policies for enterprise environments (the settings available with `policies.json` are limited right now because this is a new feature of Firefox).

`Bench diff`: Impact on the performance of LibreWolf, it can be a gain or a loss of performance +100/5000 stand for 2% gained performance and -1500/5000 stand for -30% performance loss.

`lockPref`: Locked preference can not be changed by extensions or updates, they can only be changed in `librewolf.cfg`.

`Defaulting VS Enforcing`: Defaulted settings can be changed by the user or an extension if permitted within the browser while enforced settings are locked and can not be changed within the browser, enforced settings can be changed in `librewolf.cfg`.

`About:config`: http://kb.mozillazine.org/About:config_entries.


## Settings Index

`librewolf.cfg`:

| Section | Bench Diff |
|---------|------------|
| User settings | +0 / 5000 |
| Defaulting Settings | +0 / 5000 |
|||
| Controversial | +0 / 5000 |
| Firefox Fingerprint | +0 / 5000 |
| Locale/Time | +0 / 5000 |
| Ghacks-user Selection | +100 / 5000 |
| Extensions Manager | +0 / 5000 |
| IJWY To Shut Up | +0 / 5000 |
| Microsoft Windows | +0 / 5000 |
| Firefox ESR60.x | +0 / 5000 |
|
| Security 1/3 | +0 / 5000 |
| Security 2/3 | +0 / 5000 |
| Security 3/3 (Cipher) | +0 / 5000 |
|||
| Performance 1/5 | +650 / 5000 |
| Performance 2/5 | -800 / 5000 |
| Performance 3/5 | -1720 / 5000 |
| Performance 4/5 | -200 / 5000 |
| Performance 5/5 | -50 / 5000 |
|||
| General Settings 1/3 | +100 / 5000 |
| General Settings 2/3 | +0 / 5000 |
| General Settings 3/3 | -40 / 5000 |
|||
| Disabled - ON/OFF | +0 / 5000 |
| Disabled - Deprecated Active | +0 / 5000 |
| Disabled - Deprecated Inactive | +0 / 5000 |

`local-settings.js`:

| Section | Bench Diff |
|---------|------------|
| General settings | ++ / 5000 |

## IJWY (I Just Want You To Shut Up)

This is a set of settings that aim to remove all the server links embedded in Firefox and other calling home functions in the purpose of blocking un-needed connections. The objective is zero unauthorized connection (ping/telemetry/Mozilla/Google...).

## Edit Locked Settings

Just edit `librewolf.cfg`, save and restart LibreWolf.


## Cookies Settings

Using different web services without cookies is impossible and cookie settings in a browser are very important when it come to privacy, in LibreWolf the settings are locked to avoid unwanted changes in such an important setting, but they can be easily changed in `librewolf.cfg` under `User Settings: Cookies settings`.

## Tracking Protection

Firefox now integrates a tracking protection feature (based on disconnect.me) it's a small content blocking list, the listing can not be edited, this feature is disabled in LibreWolf. It's recommended to use uBlock Origin instead. This feature is disabled:

- Until it evolves and integrates at least list editing.
- Because double filtering (this + ublock) is not suitable for performance.

You can however easily enable this feature in `librewolf.cfg` under `User Settings: Track Protection` (just comment active lines with `//` or remove the entire section).

## Comparing Changes And Updates

If you want to compare changes over updates or if you already have a `user.js`/`librewolf.cfg`/`policies.json`. consider using [Compare-UserJS](https://github.com/claustromaniac/Compare-UserJS), it's an amazing tool to compare user.js files and output the diffs in detailed breakdown, developed by gHack's very own resident cat, [claustromaniac](https://github.com/claustromaniac) :cat:

Usage: If not on windows install [PowerShell](https://github.com/PowerShell/PowerShell) then (for example) `pwsh Compare-UserJS.ps1 librewolf.cfg user.js` (Warning that PowerShell connects to Microsoft sometimes).



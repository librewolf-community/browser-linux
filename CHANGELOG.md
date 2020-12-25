# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

This project follows the official Firefox releases, but also uses
[Arch Linux Package Versioning](https://wiki.archlinux.org/index.php/Arch_package_guidelines#Package_versioning) to mark individual releases in between versions.

## [84.0-1] - 2020-12-25

### Changed

- New upstream release 84.0

## [83.0-1] - 2020-11-21

### Changed

- New upstream release 83.0
- New upstream release of included uBlock Origin (1.31.0)

## [82.0.3-1] - 2020-11-10

### Changed

- New upstream release 82.0.3

## [82.0.2-1] - 2020-10-29

### Changed

- New upstream release 82.0.2
- New upstream release of included uBlock Origin (1.30.6)

## [81.0.2-1] - 2020-10-18

### Changed

- New upstream release 81.0.2
- New upstream release of included uBlock Origin (1.30.4)

## [81.0-2] - 2020-10-02

### Changed

- New upstream release 81.0
- New upstream release of included uBlock Origin (1.30.0)

## [80.0.1-1] - 2020-09-06

### Changed

- New upstream release 80.0.1

## [80.0-1] - 2020-08-27

### Changed

- New upstream release 80.0
- New upstream release of included uBlock Origin (1.29.2)

### Fixed

- Fixed too broad Flatpak access permissions / sandboxing (#122 and #123), thanks to @TheMainOne!
- Unlocked an important setting required to easily enable WebRTC (macOS/#8)
- Closing the last tab now closes the browser again (#121)

## [79.0-1] - 2020-07-30

### Changed

- New upstream release 79.0

## [78.0.2-1] - 2020-07-10

### Changed

- New upstream release 78.0.2
- New upstream release of included uBlock Origin (1.28.0)

## [78.0.1-1] - 2020-07-02

### Changed

- New upstream release 78.0.1

## [78.0-1] - Unreleased/Skipped

### Changed

- New upstream release 78.0
- Various changes to approach fixing settings#21

## [77.0.1-2] - 2020-06-08

### Fixed

- Fix somewhat broken urlbar (switch to proper megabar-removal code)
- Use correctly updated uBlock origin URL

## [77.0.1-1] - 2020-06-06

### Changed

- New upstream release 77.0.1

### Fixed

- Disable "Megabar" functionality (#23)

## [76.0.1-1] - 2020-05-08

### Changed

- New upstream release 76.0.1

## [76.0-2] - Unreleased/Skipped

### Fixed

- Typos in `librewolf.cfg` that prevented it from being cleanly loaded.

## [76.0-1] - Unreleased/Skipped

### Added

- Remove Internal Plugin Certificates from Mozilla

### Changed

- New upstream release 76.0
- DoH disabled by default

### Fixed

- Some default addons from Mozilla are now removed (#59)
- Improvements to search engines and DDG Lite added (settings#18)
- Don't disable the Intersection Observer API (settings#20)
- Configure manual update URL (settings#1)
- Set fallback UA to resistFingerprinting's default (settings#10)
- Temporarily fix Firefox's address bar (settings#23)
- Update to ghacks-user.js 69 (settings#21)
- Fix Qwant's name (settings#25)

## [75.0-1] - 2020-04-08

### Changed

- New upstream release 75.0

## [74.0.1-1] - 2020-04-04

### Changed

- New upstream release 74.0.1

## [74.0-5] - 2020-04-01

### Changed

- WebRTC related settings unlocked (but still disabled) in `librewolf.cfg`

## [74.0-4] - 2020-03-31

### Added

- AppImage and Flatpak improvements (metadata, conventions etc.)
- (Mostly) working Flatpak release
- **Untested**: AppImage and Flatpak releases for `aarch64` are now also built on Ubuntu 16.04

### Known Issues

- AppImage and Flatpak releases cannot be built as PGO/profiled builds at the moment
- AppStream metadata is not completely valid (missing screenshots)
- Build scripts are not tested outside of a dockerized environment

## [74.0-3] - 2020-03-31

### Added

- WebRTC enabled for `aarch64` builds (`librewolf.cfg` still blocks it by default, intentionally)

### Fixed

- Installation of uBlock
- Removal and addition of search engines via `policies.json`
- Building the intermediary tarball on Ubuntu 16.04 (Xenial) to ensure AppImage and Flatpak compatibility

### Known Issues

- Appimage and Flatpak settings loading still needs to be tested
- Appimage and Flatpak still don't work on older distributions
- LibreWolf built on Ubuntu 16.04 cannot be a profiled/PGO build at the time.

## [74.0-2] - 2020-03-10

### Fixed

- Wrong commenting format in `librewolf.cfg` breaking LibreWolf settings

### Known Issues

- Appimage and FlatPak releases must be considered broken

## [74.0-1] - 2020-03-10

### Added

- Initial release following stable upstream Firefox releases
- [WIP] Appimage and FlatPak Releases

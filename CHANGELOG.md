# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

This project follows the official Firefox releases, but also uses
[Arch Linux Package Versioning](https://wiki.archlinux.org/index.php/Arch_package_guidelines#Package_versioning) to mark individual releases in between versions.

## [75.0-2] - Unreleased

### Added

- DoH disabled by default
- Remove Internal Plugin Certificates from Mozilla

### Fixed

- Some default addons from Mozilla are now removed (#59)

## [75.0-1] - 2020-04-08

### Added

- New upstream release 75.0

## [74.0.1-1] - 2020-04-04

### Added

- New upstream release 74.0.1

## [74.0-5] - 2020-04-01

### Added

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

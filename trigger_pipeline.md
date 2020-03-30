# Pipeline

## Triggering

The pipeline can currently only triggered manually. The version and variants to be build need
to be specified via variables:

* **pkgver** is the upstream Firefox release version
* **pkgrel** is the "Arch-style" package version[^1]
* **TARBALL** should a tarball be built (on Ubuntu 16.04 Xenial at the time of writing)
* **ARCH** should an Arch package be built
* **FLATPAK** should a Flatpak be built from a Tarball
* **APPIMAGE** should an AppImage be built from a Tarball
* **AARCH64** build for `aarch64`
* **X86_64** build for `x86_64`
* **TARBALL_URL** provide a tarball download URL for Flatpak or AppImage builds if the tarball is not built in the same pipeline run

Builds can be combined, so a full run for `x86_64` and `aarch64` including Arch releases, tarball build and Appimage and FlatPak releases is possible.

Variables are either unset, or have to be set (to `true`).

### Browser

Pipelines can be manually triggered from https://gitlab.com/librewolf-community/browser/linux/pipelines/new

### Commandline

Triggering from the commandline is possible via curl, but a valid Gitlab token needs to be provided.

The following is an example that only builds the tarball and the Flatpak and AppImage for `x86_64`:

```bash
curl --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
--header "Content-Type: application/json" \
--data '{ "ref": "master", "variables": [ {"key": "TARBALL", "value": "true"}, {"key": "FLATPAK", "value": "true"}, {"key": "APPIMAGE", "value": "true"}, {"key": "pkgver", "value": "74.0"}, {"key": "pkgrel", "value": "3"}, {"key": "X86_64", "value": "true"} ] }' \
"https://gitlab.com/api/v4/projects/12829184/pipeline"
```

[^1]: *The release number. This is usually a positive integer number that allows to differentiate
between consecutive builds of the same version of a package. As fixes and additional features are
added to the PKGBUILD that influence the resulting package, the pkgrel should be incremented by 1.
When a new version of the software is released, this value must be reset to 1.*
https://wiki.archlinux.org/index.php/PKGBUILD#pkgrel

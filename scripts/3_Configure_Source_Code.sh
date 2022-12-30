#!/bin/bash
printf "\n\n------------------------------ FINAL PREBUILD CONFIGURATION ---------------------------------\n";

set -e

# Setup Script Variables
srcdir=$1;
CI_PROJECT_DIR=${CI_PROJECT_DIR:-$(realpath $(dirname $0)/../)}
_SOURCE_REPO='https://gitlab.com/librewolf-community/browser/source.git';
_PKGVER_TAG="v${pkgver}-${pkgrel}"
_SOURCE_TAG=${SOURCE_TAG:-${_PKGVER_TAG}}
_SOURCE_REPO_DIR="${CI_PROJECT_DIR}"/source
_PATCHES_DIR="${_SOURCE_REPO_DIR}"/patches
_MOZBUILD=$srcdir/../mozbuild

mkdir -p ${_MOZBUILD}

# Copy Source Code Changes to Source Code
printf "\nCopying branding and source code changes to firefox source code\n";
git clone $_SOURCE_REPO ${_SOURCE_REPO_DIR}
cd ${_SOURCE_REPO_DIR}
git checkout ${_SOURCE_TAG}
cd ..
cp -r ${_SOURCE_REPO_DIR}/themes/browser $srcdir/;

cd $srcdir

cat >${CI_PROJECT_DIR}/mozconfig <<END
ac_add_options --enable-application=browser
mk_add_options MOZ_OBJDIR=${srcdir}/firefox-${pkgver}/obj

# to build on ubuntu and pick up clang
ac_add_options NODEJS=/usr/lib/nodejs-mozilla/bin/node

# This supposedly speeds up compilation (We test through dogfooding anyway)
ac_add_options --disable-tests
ac_add_options --disable-debug

ac_add_options --prefix=/usr
ac_add_options --enable-release
ac_add_options --enable-hardening
ac_add_options --enable-rust-simd

# attempt to address flatpak dbus issues
ac_add_options --enable-dbus

# Branding
ac_add_options --enable-update-channel=release
ac_add_options --with-app-name=librewolf
# ac_add_options --with-app-basename=LibreWolf

# switch to env vars like in librewolf source repo
# this is in browser/branding/librewolf/configure.sh as well
# so it _should_ already be applied, buuuuut just in case?

export MOZ_APP_NAME=librewolf
export MOZ_APP_BASENAME=LibreWolf
export MOZ_APP_PROFILE=librewolf
export MOZ_APP_VENDOR=LibreWolf
export MOZ_APP_DISPLAYNAME=LibreWolf

ac_add_options --with-branding=browser/branding/librewolf
# ac_add_options --with-distribution-id=io.gitlab.librewolf-community
ac_add_options --with-unsigned-addon-scopes=app,system
ac_add_options --allow-addon-sideload
export MOZ_REQUIRE_SIGNING=

# System libraries
# ac_add_options --with-system-nspr
# ac_add_options --with-system-nss

# Features
ac_add_options --enable-alsa
ac_add_options --enable-jack
ac_add_options --disable-crashreporter
ac_add_options --disable-updater
ac_add_options --disable-tests

# obsoleted?
# TODO: use source/assets/moczonfig in the future
mk_add_options MOZ_CRASHREPORTER=0
mk_add_options MOZ_DATA_REPORTING=0
mk_add_options MOZ_SERVICES_HEALTHREPORT=0
mk_add_options MOZ_TELEMETRY_REPORTING=0

# options for ci / weaker build systems
# mk_add_options MOZ_MAKE_FLAGS="-j4"
# ac_add_options --enable-linker=gold

# required for 95.0 for now, it seems
ac_add_options --without-wasm-sandboxed-libraries

# experimental JXL support
ac_add_options --enable-jxl
END

# allow setting limited resource usage via ENV / CI:

if [[ ! -z ${CORES_TO_USE} ]]; then
  echo "mk_add_options MOZ_MAKE_FLAGS=\"-j${CORES_TO_USE}\"" >> ${CI_PROJECT_DIR}/mozconfig
fi

if [[ $CARCH == 'aarch64' ]]; then
    cat >>${CI_PROJECT_DIR}/mozconfig <<END
# taken from manjaro build:
ac_add_options --enable-optimize="-g0 -O2"

export CC='clang-13'
export CXX='clang++-13'
export AR=llvm-ar-13
export NM=llvm-nm-13
export RANLIB=llvm-ranlib-13
END

  export MOZ_DEBUG_FLAGS=" "
  export CFLAGS+=" -g0"
  export CXXFLAGS+=" -g0"
  export RUSTFLAGS="-Cdebuginfo=0"

  export LDFLAGS+=" -Wl,--no-keep-memory -Wl"

else
    cat >>${CI_PROJECT_DIR}/mozconfig <<END
# ubuntu seems to recommend this
ac_add_options --disable-elf-hack

export CC='clang-13'
export CXX='clang++-13'
export AR=llvm-ar-13
export NM=llvm-nm-13
export RANLIB=llvm-ranlib-13

# probably not needed, enabled by default?
ac_add_options --enable-optimize

# unavailable option when (on ubuntu at least(?)) building on aarch64
ac_add_options NASM=/usr/lib/nasm-mozilla/bin/nasm
END

fi

# hopefully the magic sauce that makes things build on 18.04 and later on work "everywhere":
patch -Np1 -i "${CI_PROJECT_DIR}/deb_patches/armhf-reduce-linker-memory-use.patch"
patch -Np1 -i "${CI_PROJECT_DIR}/deb_patches/reduce-rust-debuginfo.patch"
patch -Np1 -i "${CI_PROJECT_DIR}/deb_patches/use-system-icupkg.patch"

# might make the build just a tiny bit cleaner, not really required though
patch -Np1 -i "${CI_PROJECT_DIR}/deb_patches/fix-wayland-build.patch"

# allow enabling JPEG XL in non-nightly browser
patch -Np1 -i ${_PATCHES_DIR}/allow-JXL-in-non-nightly-browser.patch

# Remove some pre-installed addons that might be questionable
patch -Np1 -i ${_PATCHES_DIR}/remove_addons.patch

# Debian patch to enable global menubar
# if [[ ! -z "${GLOBAL_MENUBAR}" ]];then
  # patch -Np1 -i ${_PATCHES_DIR}/unity-menubar.patch
# fi

# experimentally re-included
patch -Np1 -i ${_PATCHES_DIR}/unity-menubar.patch
patch -Np1 -i ${_PATCHES_DIR}/mozilla-kde_after_unity.patch

# Disabling Pocket
printf "\nDisabling Pocket\n";
patch -Np1 -i "${_PATCHES_DIR}/sed-patches/disable-pocket.patch"

# More patches
patch -Np1 -i "${_PATCHES_DIR}/context-menu.patch"

patch -Np1 -i "${_PATCHES_DIR}/urlbarprovider-interventions.patch"

# allow SearchEngines option in non-ESR builds
patch -Np1 -i "${_PATCHES_DIR}/sed-patches/allow-searchengines-non-esr.patch"

# fix broken(?)/unintended handling of autoconf file loading in flatpak/snap environments
patch -Np1 -i "${_PATCHES_DIR}/flatpak_autoconf.patch"

# remove search extensions (experimental)
# patch -Np1 -i "${_PATCHES_DIR}/search-config.patch"
cp "${_SOURCE_REPO_DIR}/assets/search-config.json" services/settings/dumps/main/search-config.json

# stop some undesired requests (https://gitlab.com/librewolf-community/browser/common/-/issues/10)
patch -Np1 -i "${_PATCHES_DIR}/sed-patches/stop-undesired-requests.patch"

# change some hardcoded directory strings that could lead to unnecessarily
# created directories
patch -Np1 -i ${_PATCHES_DIR}/mozilla_dirs.patch

# somewhat experimental patch to fix bus/dbus/remoting names to io.gitlab.librewolf
# should not break things, buuuuuuuuuut we'll see.
patch -Np1 -i ${_PATCHES_DIR}/dbus_name.patch

# allow uBlockOrigin to run in private mode by default, without user intervention.
patch -Np1 -i ${_PATCHES_DIR}/allow-ubo-private-mode.patch

# add custom uBO assets (on first launch only)
patch -Np1 -i ${_PATCHES_DIR}/custom-ubo-assets-bootstrap-location.patch

#
patch -Np1 -i ${_PATCHES_DIR}/faster-package-multi-locale.patch

# ui patches

# remove references to firefox from the settings UI, change text in some of the links,
# explain that we force en-US and suggest enabling history near the session restore checkbox.
patch -Np1 -i ${_PATCHES_DIR}/ui-patches/pref-naming.patch

#
patch -Np1 -i ${_PATCHES_DIR}/ui-patches/handlers.patch

#
patch -Np1 -i ${_PATCHES_DIR}/ui-patches/remap-links.patch

#
patch -Np1 -i ${_PATCHES_DIR}/ui-patches/hide-default-browser.patch

# Add LibreWolf logo to Debugging Page
patch -Np1 -i ${_PATCHES_DIR}/ui-patches/lw-logo-devtools.patch

#
patch -Np1 -i ${_PATCHES_DIR}/ui-patches/privacy-preferences.patch

# remove firefox references in the urlbar, when suggesting opened tabs.
patch -Np1 -i ${_PATCHES_DIR}/ui-patches/remove-branding-urlbar.patch

# remove cfr UI elements, as they are disabled and locked already.
patch -Np1 -i ${_PATCHES_DIR}/ui-patches/remove-cfrprefs.patch

# do not display your browser is being managed by your organization in the settings.
patch -Np1 -i ${_PATCHES_DIR}/ui-patches/remove-organization-policy-banner.patch

# hide "snippets" section from the home page settings, as it was already locked.
patch -Np1 -i ${_PATCHES_DIR}/ui-patches/remove-snippets-from-home.patch

# add patch to hide website appearance settings
patch -Np1 -i ${_PATCHES_DIR}/ui-patches/website-appearance-ui-rfp.patch

# pref pane
patch -Np1 -i ${_PATCHES_DIR}/librewolf-pref-pane.patch

# firefox view
patch -Np1 -i ${_PATCHES_DIR}/ui-patches/firefox-view.patch

# new prefs (view, ubo)
patch -Np1 -i ${_PATCHES_DIR}/librewolf-prefs.patch

# fix telemetry removal, see https://gitlab.com/librewolf-community/browser/linux/-/merge_requests/17, for example
patch -Np1 -i ${_PATCHES_DIR}/disable-data-reporting-at-compile-time.patch

# allows hiding the password manager (from the lw pref pane) / via a pref
patch -Np1 -i ${_PATCHES_DIR}/hide-passwordmgr.patch

rm -rf source

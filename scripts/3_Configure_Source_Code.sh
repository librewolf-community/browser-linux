#!/bin/bash
printf "\n\n------------------------------ FINAL PREBUILD CONFIGURATION ---------------------------------\n";

set -e

# Setup Script Variables
srcdir=$1;
CI_PROJECT_DIR=${CI_PROJECT_DIR:-$(realpath $(dirname $0)/../)}
_COMMON_REPO='https://gitlab.com/librewolf-community/browser/common.git';
_MOZBUILD=$srcdir/../mozbuild

mkdir -p ${_MOZBUILD}

# Copy Source Code Changes to Source Code
printf "\nCopying branding and source code changes to firefox source code\n";
git clone $_COMMON_REPO common;
cp -r common/source_files/* $srcdir/;
rm -rf common;

cd $srcdir

cat >${CI_PROJECT_DIR}/mozconfig <<END
ac_add_options --enable-application=browser
mk_add_options MOZ_OBJDIR=${srcdir}/firefox-${pkgver}/obj

# to build on ubuntu and pick up clang
ac_add_options NODEJS=/usr/lib/nodejs-mozilla/bin/node
ac_add_options NASM=/usr/lib/nasm-mozilla/bin/nasm

# This supposedly speeds up compilation (We test through dogfooding anyway)
ac_add_options --disable-tests
ac_add_options --disable-debug

ac_add_options --prefix=/usr
ac_add_options --enable-release
ac_add_options --enable-hardening
ac_add_options --enable-rust-simd

# Branding
ac_add_options --enable-update-channel=release
ac_add_options --with-app-name=librewolf
ac_add_options --with-app-basename=LibreWolf
ac_add_options --with-branding=browser/branding/librewolf
ac_add_options --with-distribution-id=io.gitlab.librewolf-community
ac_add_options --with-unsigned-addon-scopes=app,system
ac_add_options --allow-addon-sideload
export MOZ_REQUIRE_SIGNING=0

# System libraries
# ac_add_options --with-system-nspr
# ac_add_options --with-system-nss

# Features
ac_add_options --enable-alsa
ac_add_options --enable-jack
ac_add_options --disable-crashreporter
ac_add_options --disable-updater
ac_add_options --disable-tests

# Disables crash reporting, telemetry and other data gathering tools
mk_add_options MOZ_CRASHREPORTER=0
mk_add_options MOZ_DATA_REPORTING=0
mk_add_options MOZ_SERVICES_HEALTHREPORT=0
mk_add_options MOZ_TELEMETRY_REPORTING=0

# options for ci / weaker build systems
# mk_add_options MOZ_MAKE_FLAGS="-j4"
# ac_add_options --enable-linker=gold
END

if [[ $CARCH == 'aarch64' ]]; then
    cat >>${CI_PROJECT_DIR}/mozconfig <<END
# taken from manjaro build:
ac_add_options --enable-optimize="-g0 -O2"

# from ALARM
# should only fail on armv7x
# ac_add_options --disable-webrtc

export CC='clang-8'
export CXX='clang++-8'
export AR=llvm-ar-8
export NM=llvm-nm-8
export RANLIB=llvm-ranlib-8
END

  export MOZ_DEBUG_FLAGS=" "
  export CFLAGS+=" -g0"
  export CXXFLAGS+=" -g0"
  export RUSTFLAGS="-Cdebuginfo=0"

  export LDFLAGS+=" -Wl,--no-keep-memory -Wl"
  patch -p1 -i ${CI_PROJECT_DIR}/arm.patch
  wget https://raw.githubusercontent.com/archlinuxarm/PKGBUILDs/master/extra/firefox/build-arm-libopus.patch -O ${CI_PROJECT_DIR}/build-arm-libopus.patch
  patch -p1 -i ${CI_PROJECT_DIR}/build-arm-libopus.patch

else
    cat >>${CI_PROJECT_DIR}/mozconfig <<END
# ubuntu seems to recommend this
ac_add_options --disable-elf-hack

export CC='clang-11'
export CXX='clang++-11'
export AR=llvm-ar-11
export NM=llvm-nm-11
export RANLIB=llvm-ranlib-11

# probably not needed, enabled by default?
ac_add_options --enable-optimize
END

fi

# hopefully the magic sauce that makes things build on 16.04 and later on work "everywhere":
patch -p1 -i "${CI_PROJECT_DIR}/deb_patches/lower-python3-requirement.patch"
patch -p1 -i "${CI_PROJECT_DIR}/deb_patches/armhf-reduce-linker-memory-use.patch"
patch -p1 -i "${CI_PROJECT_DIR}/deb_patches/build-with-libstdc++-7.patch"
patch -p1 -i "${CI_PROJECT_DIR}/deb_patches/fix-armhf-webrtc-build.patch"
patch -p1 -i "${CI_PROJECT_DIR}/deb_patches/webrtc-fix-compiler-flags-for-armhf.patch"
patch -p1 -i "${CI_PROJECT_DIR}/deb_patches/reduce-rust-debuginfo.patch"
patch -p1 -i "${CI_PROJECT_DIR}/deb_patches/relax-cargo-dep.patch"
patch -p1 -i "${CI_PROJECT_DIR}/deb_patches/use-system-icupkg.patch"
patch -p1 -i "${CI_PROJECT_DIR}/deb_patches/python3-remove-variable-annotations.patch"
patch -p1 -i "${CI_PROJECT_DIR}/deb_patches/python3-remove-fstrings.patch"
patch -p1 -i "${CI_PROJECT_DIR}/deb_patches/python3-remove-pep487.patch"
patch -p1 -i "${CI_PROJECT_DIR}/deb_patches/silence-gtk-style-assertions.patch"
patch -p1 -i "${CI_PROJECT_DIR}/deb_patches/sandbox-update-arm-syscall-numbers.patch"

# Remove some pre-installed addons that might be questionable
patch -p1 -i ${CI_PROJECT_DIR}/remove_addons.patch

# Disable (some) megabar functionality
# Adapted from https://github.com/WesleyBranton/userChrome.css-Customizations
patch -p1 -i ${CI_PROJECT_DIR}/megabar.patch

# Debian patch to enable global menubar
if [[ ! -z "${GLOBAL_MENUBAR}" ]];then
  patch -p1 -i ${CI_PROJECT_DIR}/unity-menubar.patch
fi

# Disabling Pocket
printf "\nDisabling Pocket\n";
sed -i "s/'pocket'/#'pocket'/g" browser/components/moz.build
# this one only to remove an annoying error message:
sed -i 's#SaveToPocket.init();#// SaveToPocket.init();#g' browser/components/BrowserGlue.jsm

# Remove Internal Plugin Certificates
_cert_sed='s#if (aCert.organizationalUnit == "Mozilla [[:alpha:]]\+") {\n'
_cert_sed+='[[:blank:]]\+return AddonManager\.SIGNEDSTATE_[[:upper:]]\+;\n'
_cert_sed+='[[:blank:]]\+}#'
_cert_sed+='// NOTE: removed#g'
sed -z "$_cert_sed" -i toolkit/mozapps/extensions/internal/XPIInstall.jsm

# allow SearchEngines option in non-ESR builds
sed -i 's#"enterprise_only": true,#"enterprise_only": false,#g' browser/components/enterprisepolicies/schemas/policies-schema.json

# stop some undesired requests (https://gitlab.com/librewolf-community/browser/common/-/issues/10)
_settings_services_sed='s#firefox.settings.services.mozilla.com#f.s.s.m.c.qjz9zk#g'
sed "$_settings_services_sed" -i browser/components/newtab/data/content/activity-stream.bundle.js
sed "$_settings_services_sed" -i modules/libpref/init/all.js
sed "$_settings_services_sed" -i services/settings/Utils.jsm
sed "$_settings_services_sed" -i toolkit/components/search/SearchUtils.jsm

#!/bin/bash
printf "\n\n------------------------------ FINAL PREBUILD CONFIGURATION ---------------------------------\n";

# Setup Script Variables
srcdir=$1;
CI_PROJECT_DIR=${CI_PROJECT_DIR:-$(realpath $(dirname $0)/../../)}
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

# to build on ubuntu and pick up clang
ac_add_options --with-libclang-path="/usr/lib/${CARCH}-linux-gnu/libclang-cpp.so.9"
ac_add_options --with-clang-path="/usr/bin/clang-9"

# This supposedly speeds up compilation (We test through dogfooding anyway)
ac_add_options --disable-tests
ac_add_options --disable-debug

# might cause issues for appimage/flatpak, so keep it unset
# ac_add_options --prefix=/usr
ac_add_options --enable-release
ac_add_options --enable-hardening
ac_add_options --enable-rust-simd

export CC='clang-9'
export CXX='clang++-9'
export AR=llvm-ar-9
export NM=llvm-nm-9
export RANLIB=llvm-ranlib-9

# Branding
ac_add_options --enable-update-channel=release
ac_add_options --with-app-name=${pkgname}
ac_add_options --with-app-basename=${_pkgname}
ac_add_options --with-branding=browser/branding/${pkgname}
ac_add_options --with-distribution-id=io.gitlab.${pkgname}
ac_add_options --with-unsigned-addon-scopes=app,system
ac_add_options --allow-addon-sideload
export MOZ_REQUIRE_SIGNING=0

# System libraries
ac_add_options --with-system-nspr
ac_add_options --with-system-nss

# Features
ac_add_options --enable-alsa
ac_add_options --enable-jack
ac_add_options --enable-startup-notification
ac_add_options --disable-crashreporter
ac_add_options --disable-gconf
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
export MOZ_DEBUG_FLAGS=" "
export CFLAGS+=" -g0"
export CXXFLAGS+=" -g0"
export RUSTFLAGS="-Cdebuginfo=0"

# from ALARM
ac_add_options --disable-webrtc

END

  LDFLAGS+=" -Wl,--no-keep-memory -Wl,--reduce-memory-overheads"
  patch -p1 -i ${$CI_PROJECT_DIR}/arm.patch
  wget https://raw.githubusercontent.com/archlinuxarm/PKGBUILDs/master/extra/firefox/build-arm-libopus.patch -O ${$CI_PROJECT_DIR}/build-arm-libopus.patch
  patch -p1 -i ${$CI_PROJECT_DIR}/build-arm-libopus.patch

fi

# Disabling Pocket
printf "\nDisabling Pocket\n";
sed -i "s/'pocket'/#'pocket'/g" browser/components/moz.build
# this one only to remove an annoying error message:
sed -i 's#SaveToPocket.init();#// SaveToPocket.init();#g' browser/components/BrowserGlue.jsm

# allow SearchEngines option in non-ESR builds
sed -i 's#"enterprise_only": true,#"enterprise_only": false,#g' browser/components/enterprisepolicies/schemas/policies-schema.json

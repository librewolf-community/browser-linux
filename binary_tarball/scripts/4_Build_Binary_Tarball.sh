#!/bin/bash
printf "\n\n--------------------------------------- BUILD -----------------------------------------------\n";

set -e

# Setup Script Variables
srcdir=$1;
OUTPUT_TARBALL=$2;
CI_PROJECT_DIR=${CI_PROJECT_DIR:-$(realpath $(dirname $0)/../../)}
_SOURCE_CODE_BINARY_TARBALL_LOCATION="${srcdir}/firefox-${pkgver}/obj/dist/librewolf*.tar.bz2";
_MOZBUILD=$srcdir/../mozbuild
export DEB_BUILD_HARDENING=1
export DEB_BUILD_HARDENING_STACKPROTECTOR=1
export DEB_BUILD_HARDENING_FORTIFY=1
export DEB_BUILD_HARDENING_FORMAT=1
export DEB_BUILD_HARDENING_PIE=1
# export PATH=/usr/lib/nasm-mozilla/bin:$PATH

# we do change / unset some of them later, but setting them as set by Arch
# might make it easier to maintain changes in build scripts on both sides

if [[ $CARCH == 'aarch64' ]]; then
  export CPPFLAGS="-D_FORTIFY_SOURCE=2"
  export CFLAGS="-march=armv8-a -O2 -pipe -fstack-protector-strong -fno-plt"
  export CXXFLAGS="-march=armv8-a -O2 -pipe -fstack-protector-strong -fno-plt"
  export LDFLAGS="-Wl,-O1,--sort-common,--as-needed,-z,relro,-z,now"
else
  export CPPFLAGS="-D_FORTIFY_SOURCE=2"
  export CFLAGS="-march=x86-64 -mtune=generic -O2 -pipe -fno-plt"
  export CXXFLAGS="-march=x86-64 -mtune=generic -O2 -pipe -fno-plt"
  export LDFLAGS="-Wl,-O1,--sort-common,--as-needed,-z,relro,-z,now"
fi

export MOZ_NOSPAM=1
export MOZBUILD_STATE_PATH="${_MOZBUILD}"
export MACH_USE_SYSTEM_PYTHON=1

if [[ $CARCH == 'aarch64' ]]; then
  export MOZ_DEBUG_FLAGS=" "
  export CFLAGS+=" -g0"
  export CXXFLAGS+=" -g0"
  export RUSTFLAGS="-Cdebuginfo=0"
  export LDFLAGS+=" -Wl,--no-keep-memory"
fi

# LTO needs more open files
ulimit -n 4096

# Prevents build from breaking in CI/CD environments
export SHELL=/bin/bash;

# Changes current folder to the source code folder
cd $srcdir;

# Runs bootstrapper to install dependencies
# printf "\nRunning bootstrapper to install build dependencies (using ./mach script within source code)\n";
# ./mach bootstrap --application-choice=browser --no-interactive

# ./mach configure

rm -f mozconfig

# add cargo binary to path
# source /root/.cargo/env

# install cbindgen
cargo install --version 0.16.0 cbindgen

if [[ $CARCH == 'aarch64' ]]; then

cat >.mozconfig ${CI_PROJECT_DIR}/mozconfig - <<END
# seems to break on arm
# ac_add_options --enable-linker=gold
END

else

cat >.mozconfig ${CI_PROJECT_DIR}/mozconfig - <<END
# seems to mess with the libstdc++-static patch
# ac_add_options --enable-linker=gold
END

fi

./mach build

echo "Building symbol archive..."
./mach buildsymbols

# End "build()" equivalent.

# Packages the build into a binary tarball
printf "\nPackaging LibreWolf\n";
./mach package;

# Moves the packaged tarball to the specified location
printf "\nMoving Binary Tarball to output location\n";
mv $_SOURCE_CODE_BINARY_TARBALL_LOCATION $OUTPUT_TARBALL;

# Deletes the source code
printf "\nDeleting source code\n";
rm -rf $srcdir;

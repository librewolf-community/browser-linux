#!/bin/bash
printf "\n\n--------------------------------------- BUILD -----------------------------------------------\n";

# Setup Script Variables
srcdir=$1;
OUTPUT_TARBALL=$2;
CI_PROJECT_DIR=${CI_PROJECT_DIR:-$(realpath $(dirname $0)/../../)}
_SOURCE_CODE_BINARY_TARBALL_LOCATION="./obj*/dist/librewolf*.tar.bz2";
_MOZBUILD=$srcdir/../mozbuild
export PATH=/usr/lib/nasm-mozilla/bin:$PATH

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

if [[ $CARCH == 'aarch64' ]]; then
  LDFLAGS+=" -Wl,--no-keep-memory -Wl,--reduce-memory-overheads"
fi

# LTO needs more open files
ulimit -n 4096

# Prevents build from breaking in CI/CD environments
export SHELL=/bin/bash;

# Changes current folder to the source code folder
cd $srcdir;

# Runs bootstrapper to install dependencies
printf "\nRunning bootstrapper to install build dependencies (using ./mach script within source code)\n";
./mach bootstrap --application-choice=browser --no-interactive

# add cargo binary to path
source /root/.cargo/env

# install cbindgen
cargo install cbindgen

rm -f mozconfig

# Do 3-tier PGO
echo "Building instrumented browser..."

# if [[ $CARCH == 'aarch64' ]]; then
#
# cat >.mozconfig ${CI_PROJECT_DIR}/mozconfig - <<END
# ac_add_options --enable-profile-generate
# END
#
# else
#
# cat >.mozconfig ${CI_PROJECT_DIR}/mozconfig - <<END
# # -fno-plt with cross-LTO causes obscure LLVM errors
# # LLVM ERROR: Function Import: link error
# # CFLAGS="${CFLAGS/-fno-plt/}"
# # CXXFLAGS="${CXXFLAGS/-fno-plt/}"
#
# ac_add_options --enable-profile-generate
# END

# fi

# Executes the actual build
# printf "\nBuilding LibreWolf\n";
# ./mach build;

# echo "Profiling instrumented browser..."
# ./mach package
# LLVM_PROFDATA=llvm-profdata \
  # JARLOG_FILE="$PWD/jarlog" \
  # xvfb-run -s "-screen 0 1920x1080x24 -nolisten local" \
  # ./mach python build/pgo/profileserver.py
#
# if [[ ! -s merged.profdata ]]; then
  # echo "No profile data produced."
  # exit 1
# fi
#
# if [[ ! -s jarlog ]]; then
  # echo "No jar log produced."
  # exit 1
# fi
#
# echo "Removing instrumented browser..."
# ./mach clobber
#
# echo "Building optimized browser..."

if [[ $CARCH == 'aarch64' ]]; then

cat >.mozconfig ${CI_PROJECT_DIR}/mozconfig - <<END
ac_add_options --enable-lto
ac_add_options --enable-profile-use
ac_add_options --with-pgo-profile-path=${PWD@Q}/merged.profdata
ac_add_options --with-pgo-jarlog=${PWD@Q}/jarlog
# seems to break on arm
# ac_add_options --enable-linker=gold
END

else

cat >.mozconfig ${CI_PROJECT_DIR}/mozconfig - <<END
# ac_add_options --enable-lto
# ac_add_options --enable-profile-use
# ac_add_options --with-pgo-profile-path=${PWD@Q}/merged.profdata
# ac_add_options --with-pgo-jarlog=${PWD@Q}/jarlog
ac_add_options --enable-linker=gold
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


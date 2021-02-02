#!/bin/sh
# File: prep-librewolf-dpkg.sh
# Location: https://gitlab.com/bgstack15/librewolf-linux.git
# Latest supported version: librewolf-84.0.2-2
# Author: bgstack15
# SPDX-License-Identifier: CC-BY-SA-4.0
# Startdate: 2020-11-29
# Title: Build Dpkg for LibreWolf
# Purpose: Prepare initial assets for running "dpkg-buildpackage -b -us -uc" for LibreWolf by adapting Debian Firefox assets
# History:
# Usage:
#    Can send these final assets up to Open Build Service
# References:
#    Script numbers from https://gitlab.com/librewolf-community/browser/linux/-/tree/master/binary_tarball/scripts
# Improve:
#    Make this idempotent. Right now it is very much not.
# Dependencies:
#    wget, git, tar, awk, sed

#####################################
# Load settings

# basically, dot-source the conf file.
test -z "${librewolf_dpkg_conf}" && export librewolf_dpkg_conf="$( find "$( dirname "${0}" )" -maxdepth 2 -name "$( basename "${0%%.sh}.conf" )" -print 2>/dev/null | head -n1 )"
test ! -r "${librewolf_dpkg_conf}" && { echo "Unable to load config file, which should be named the same as this script but with a .conf ending. Aborted." 1>&2 ; exit 1 ; }
. "${librewolf_dpkg_conf}"

#####################################
# Download initial components

# Download upstream Debian assets, which includes
#   1. orig tarball, which in Debian is not always the pristine contents from upstream source
#   2. debian/ directory which defines how to build a package for Debian
#   3. Debian source package control file
mkdir -p "${work_dir}" ; cd "${work_dir}"
test -z "${SKIP_DOWNLOAD}" && {
   wget --content-disposition http://deb.debian.org/debian/pool/main/f/firefox/firefox_"${firefox_version}".orig.tar.xz # -O librewolf_"${firefox_version}".orig.tar.xz
   wget --content-disposition http://deb.debian.org/debian/pool/main/f/firefox/firefox_"${debian_firefox_version}".debian.tar.xz # -O librewolf_"${debian_firefox_version}".debian.tar.xz
   wget --content-disposition http://deb.debian.org/debian/pool/main/f/firefox/firefox_"${debian_firefox_version}".dsc # -O librewolf_"${debian_firefox_version}".dsc
}

# extract these contents to where they belong
mkdir -p "${source_dir}"
test -z "${SKIP_EXTRACT}" && {
   echo "Extracting files from orig and debian tarballs. This might take a while." 1>&2
   tar -C "${source_dir}" -Jx --strip-components=1 -f firefox_"${firefox_version}".orig.tar.xz
   tar -C "$( dirname "${debian_dir}" )" -Jxf firefox_"${debian_firefox_version}".debian.tar.xz
   # dsc file is a text file and needs no extraction
}

# Download git sources
test -z "${SKIP_GIT}" && (
   # yes, use a sub-shell because of this cd. pushd is a bash builtin, but we are using sh and not bash.
   cd "${git_source_dir}"
   git clone "${librewolf_common_url}" common
   git clone "${librewolf_settings_url}" settings
   git clone "${librewolf_linux_url}" linux
)

#####################################
# Script 1 tasks

# update debian/control file
# update fields and add libjack-dev
sed -i -r "${debian_dir}"/control \
   -e '/^[[:alpha:]]+: firefox/s/firefox/librewolf/' \
   -e '/^Package:.*-l10/,$d' \
   -e '/^Maintainer:/{s/Maintainer:/XSBC-Original-Maintainer:/;iMaintainer: B. Stack <bgstack15@gmail.com>' -e '}' \
   -e '/^Uploaders:/d' \
   -e '/libasound2-dev/s/libasound2-dev,/libasound2-dev, libjack-dev,/;' \
   -e '/^Vcs-/d' \
   -e '/Breaks:.*xul-ext-torbutton/d' \
   -e '/Description:/,+8{/Description:/,/^\s*$/d}'
cat <<'EOF' >> "${debian_dir}"/control
Description: LibreWolf variant of Mozilla Firefox web browser
 LibreWolf is a build of Firefox that seeks to protect user privacy,
 security, and freedom.
EOF

#####################################
# Script 2 tasks

# none. Dependencies are handled by the build environment by interpreting the dsc file.

#####################################
# Script 3 tasks

# overlay the orig tarball contents with LibreWolf contents
# LibreWolf branding
cp -pr "${git_source_dir}"/common/source_files/browser/branding "${source_dir}"/browser/
# update mozconfig with needed info
sed -i -e '/with-app-name=/d' "${debian_dir}"/browser.mozconfig.in
cat <<EOF >> "${debian_dir}"/browser.mozconfig.in

# Start of LibreWolf effects
ac_add_options --disable-tests
ac_add_options --disable-debug

ac_add_options --prefix=/usr
ac_add_options --enable-release
ac_add_options --enable-hardening
ac_add_options --enable-rust-simd

# Branding ac_add_options --enable-update-channel=release 
ac_add_options --with-app-name=librewolf
ac_add_options --with-app-basename=LibreWolf
ac_add_options --with-branding=browser/branding/librewolf
ac_add_options --with-distribution-id=io.gitlab.librewolf
ac_add_options --with-unsigned-addon-scopes=app,system
ac_add_options --allow-addon-sideload
export MOZ_REQUIRE_SIGNING=0

# Features
ac_add_options --enable-jack
ac_add_options --disable-crashreporter

# Disables crash reporting, telemetry and other data gathering tools
mk_add_options MOZ_CRASHREPORTER=0
mk_add_options MOZ_DATA_REPORTING=0
mk_add_options MOZ_SERVICES_HEALTHREPORT=0
mk_add_options MOZ_TELEMETRY_REPORTING=0

ac_add_options --disable-elf-hack

# LibreWolf binary release uses clang-11 but Debian builds Firefox with gcc so this is irrelevant.
#export CC='clang-11'
#export CXX='clang++-11'
#export AR=llvm-ar-11
#export NM=llvm-nm-11
#export RANLIB=llvm-ranlib-11

ac_add_options --enable-optimize
EOF

# add patches to debian/patches
mkdir -p "${debian_dir}"/patches/librewolf
cp -pr "${git_source_dir}"/linux/megabar.patch "${git_source_dir}"/linux/remove_addons.patch \
   "${git_source_dir}"/linux/deb_patches/*.patch \
   "${debian_dir}"/patches/librewolf/
cat <<EOF >> "${debian_dir}"/patches/series
librewolf/lower-python3-requirement.patch -p1
librewolf/armhf-reduce-linker-memory-use.patch -p1
#librewolf/build-with-libstdc++-7.patch -p1
librewolf/fix-armhf-webrtc-build.patch -p1
librewolf/webrtc-fix-compiler-flags-for-armhf.patch -p1
librewolf/python3-remove-variable-annotations.patch -p1
librewolf/python3-remove-fstrings.patch -p1
librewolf/python3-remove-pep487.patch -p1
librewolf/silence-gtk-style-assertions.patch -p1
librewolf/sandbox-update-arm-syscall-numbers.patch -p1
librewolf/remove_addons.patch -p1
librewolf/megabar.patch -p1
EOF
# observe that build-with-libstdc++-7 is disabled for this dpkg. Debian builds Firefox with gcc, not clang.
# fix some fuzz in remove_addons.patch. The space is important!
sed -i -r -e 's/libs /l10n /;' "${debian_dir}"/patches/librewolf/remove_addons.patch

# additional main LibreWolf activities
# disable pocket in source
sed -i "/'pocket'/d" "${source_dir}"/browser/components/moz.build
sed -i "/SaveToPocket\.init/d" "${source_dir}"/browser/components/BrowserGlue.jsm
# Remove internal plugin certificates
sed -i -r -e '/organizationalUnit.{0,5}=.{0,5}Mozilla/{N;N;N;d}' "${source_dir}"/toolkit/mozapps/extensions/internal/XPIInstall.jsm
# allow SearchEngines option in non-ESR builds
sed -i -r -e '/enterprise_only/s#true#false#g;' "${source_dir}"/browser/components/enterprisepolicies/schemas/policies-schema.json

#####################################
# Script 4 tasks

sed -i -r -e '2{
   iexport DEB_BUILD_HARDENING=1
   ;iexport DEB_BUILD_HARDENING_STACKPROTECTOR=1
   ;iexport DEB_BUILD_HARDENING_FORTIFY=1
   ;iexport DEB_BUILD_HARDENING_FORMAT=1
   ;iexport DEB_BUILD_HARDENING_PIE=1
   ;iexport CPP
}
/^EXPORTS/{
   iCPPFLAGS += -D_FORTIFY_SOURCE=2
   ;iCFLAGS += -march=x86-64 -mtune=generic -O2 -pipe -fno-plt
   ;iCXXFLAGS += -march=x86-64 -mtune=generic -O2 -pipe -fno-plt
   ;iLDFLAGS += -Wl,-O1,--sort-common,--as-needed,-z,relro,-z,now
}
2{
   iexport MOZ_NOSPAM=1
   iexport MACH_USE_SYSTEM_PYTHON=1
}
' "${debian_dir}"/rules

#####################################
# Additional steps for dpkg implementation

# fix the binary name that gets installed in /usr/bin, and disable crash reporter by changing what variable name it looks for that will enable it
sed -i -e '/%if browser/,+2s/firefox/librewolf/' \
   -e '/%if CRASH_REPORTER/s/CRASH_REPORTER/CRASH_REPORTER_ENABLED/' \
   "${debian_dir}"/browser.install.in

# instruct dpkg to include the librewolf settings
rm -rf "${debian_dir}"/librewolf_settings
cp -pr "${git_source_dir}"/settings "${debian_dir}"/librewolf_settings
rm -rf "${debian_dir}"/librewolf_settings/.git*
cat <<EOF >> "${debian_dir}"/browser.install.in
debian/librewolf_settings/librewolf.cfg usr/lib/@browser@
debian/librewolf_settings/defaults usr/lib/@browser@
debian/librewolf_settings/distribution usr/lib/@browser@
EOF

# add changelog contents for LibreWolf
new_changelog="$( mktemp )"
{
   cat <<EOF
librewolf (${debian_firefox_version}) unstable; urgency=low

  * Fork to librewolf release

 -- B. Stack <bgstack15@gmail.com>  $( date "+%a, %d %b %+4Y %T %z" )

EOF
   cat "${debian_dir}"/changelog
} > "${new_changelog}"
cat "${new_changelog}" > "${debian_dir}"/changelog

rm -f "${new_changelog:-NOTHINGTODEL}"

#####################################
# Build new assets 
# dpkg-buildpackage needs the orig tarball, debian tarball, and dsc file.

echo "Building new tarballs. This might take a while." 1>&2

# orig tarball
cd "${work_dir}"
tar -Jc -f librewolf_"${firefox_version}".orig.tar.xz -C "$( dirname "${source_dir}" )" librewolf_"${firefox_version}"

# debian tarball
tar -Jc -f librewolf_"${debian_firefox_version}".debian.tar.xz -C "$( dirname  "${debian_dir}" )" debian

# dsc file, which needs to be modified
cd "${work_dir}"
sed -r \
   -e '/^(Files|Checksums-.{0,8}):/,$d' \
   -e '1,/^Format:/{/^Format:/!{d}}' \
   -e 's/^([[:alpha:]]+:).* firefox(-l10n[^\s]*)*/\1 librewolf/' \
   -e '/firefox-l10n/d' \
   -e '/^Maintainer:/{s/Maintainer:/XSBC-Original-Maintainer:/;iMaintainer: B. Stack <bgstack15@gmail.com>' -e '}' \
   -e '/^Uploaders:/d' \
   -e '/libasound2-dev/s/libasound2-dev,/libasound2-dev, libjack-dev,/;' \
   -e '/^Vcs-/d' \
   -e '/^ firefox/s/firefox/librewolf/g' \
   firefox_"${debian_firefox_version}".dsc > librewolf_"${debian_firefox_version}".dsc
{
   echo "Files:"
   for word in librewolf*z ;
   do
      printf "%s %s\n" "$( stat -c '%s' "${word}" )" "$( md5sum "${word}" )" 
   done | awk '{print " "$2,$1,$3}'
} >> librewolf_"${debian_firefox_version}".dsc

# And now you have in the ${work_dir} location three files.
# librewolf_80.3.orig.tar.xz librewolf_80.3-1.debian.tar.xz librewolf_80.3-1.dsc

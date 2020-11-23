#!/bin/bash

pacman --noconfirm -Syu --needed base-devel
# this is a very ugly fix for recent makepkg-5.1-chmod-shenanigans, which mess up the build process in docker
sed -E -i 's/^chmod a-s \"\$BUILDDIR\"$/# chmod a-s \"\$BUILDDIR\"/' `which makepkg`
echo 'nobody ALL=(ALL) NOPASSWD: /usr/bin/pacman' >> /etc/sudoers
mkdir -p /home/nobody && chown -R nobody /home/nobody
usermod -d /home/nobody nobody
# we need to un-expire the account, otherwise PAM will complain
usermod -e '' nobody
chown -R nobody .
# temporary workaround for rust / packed_simd build issue:
pacman --noconfirm -U https://archive.archlinux.org/packages/r/rust/rust-1%3A1.47.0-4-x86_64.pkg.tar.zst
# makepkg will not run as root
sudo -u nobody -E -H makepkg --noconfirm --nosign --syncdeps --cleanbuild

#/bin/bash

die "DOESN'T WORK, use kbfs -d <dirs> instead"

sudo dd if=/dev/zero of=/tmp/disk.img bs=1M count=23075
sudo losetup /dev/loop1 /tmp/disk.img && sudo cryptsetup luksFormat /dev/loop1 && sudo cryptsetup luksOpen /dev/loop1 mybackupdisk && sudo genisoimage -R -J -joliet-long -graft-points -V backup -o /dev/mapper/mybackupdisk /var/lib/myfrdcsa/codebases/minor
sudo cryptsetup luksClose /dev/mapper/mybackupdisk && sudo losetup -d /dev/loop1
# sudo xorriso -as cdrecord -v dev=/dev/sr0 /tmp/disk.img

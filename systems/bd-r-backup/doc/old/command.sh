#!/bin/sh

die "this is outdated, see the KBFS::Pack::Packing for an up to date version\n";

imgfile=/s3/kbfs/backup/FRDCSA-20140902-1-OF-3.udf
volname="FRDCSA 20140902 1 OF 3"

sudo truncate --size=25GB $imgfile

imgloop=`sudo losetup -f`

sudo losetup "$imgloop" "$imgfile"

sudo cryptsetup luksFormat --cipher aes-xts-plain64 "$imgloop"

# enter the password in here

sudo cryptsetup luksOpen "$imgloop" mybluray

sudo mkudffs --vid="$volname" /dev/mapper/mybluray

sudo mount /dev/mapper/mybluray /mnt/udf

# sudo rsync -avzL /tmp/BD-R/var/ /mnt/udf/
# run the command which copies the files over, substituting ln -s with cp -ar etc and /tmp/BD-R with /mnt/udf/

sudo umount /mnt/udf

sudo cryptsetup luksClose /dev/mapper/mybluray

sudo losetup -d "$imgloop"

sudo growisofs -dvd-compat -Z /dev/sr0="$imgfile"

# growisofs -dvd-compat-Z /dev/dvd=/s3/kbfs/backup/FRDCSA-20140902-1-OF-3.udf

# have to make this file smaller

# 23985389568/25000000000 (95.9%) @3.6x, remaining 1:08 RBU 100.0% UBU  64.0%
# 24039653376/25000000000 (96.2%) @3.6x, remaining 1:04 RBU 100.0% UBU  61.8%
# 24093327360/25000000000 (96.4%) @3.6x, remaining 1:01 RBU  99.9% UBU  64.0%
# 24144347136/25000000000 (96.6%) @3.4x, remaining 0:57 RBU 100.0% UBU  53.2%
# 24198152192/25000000000 (96.8%) @3.6x, remaining 0:53 RBU  99.9% UBU  38.2%
# :-[ WRITE@LBA=b47400h failed with SK=5h/END OF USER AREA ENCOUNTERED ON THIS TRACK]: Input/output error
# :-( write failed: Input/output error
# /dev/sr0: flushing cache
# /dev/sr0: closing track
# /dev/sr0: closing session
# :-[ CLOSE SESSION failed with SK=5h/INVALID FIELD IN CDB]: Input/output error
# /dev/sr0: reloading tray
# andrewdo@ai:/s3/kbfs/backup$ sudo eject -t

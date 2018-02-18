#!/bin/sh

# now that there is a second harddrive to rsync to, it becomes easier to back things up.

# rsync -av /var/lib/myfrdcsa /mnt/hdc2/var/lib
# > /var/log/kbfs.log >> /var/log/kbfs.log

sudo rsync -av /var/lib/myfrdcsa justin.frdcsa.org:/root/frdcsa
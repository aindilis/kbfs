(completed
 (we have to fix the system to reduce the size of the disks that
  are given to it to fit within our media.  command.sh shows
  where it stopped this last run.  Calculate to make a good
  amount clean and safe.  Make sure to account for the file
  system.  Remember 24000000KB ***barely*** fit on a 25GB, which
  didn't fit on the disk))

(dvd+rw-mediainfo /dev/sr0)

(completed
 (see command.sh error log:
 https://bugs.launchpad.net/ubuntu/+source/dvd+rw-tools/+bug/1113679))

(completed
 (so we have to fix the system so that it generates the disk
  images using the instructions in command.sh, and using the
  following replacement in the output for the KBFS code.
  ((replace 'ln -s ' with 'cp -ar ')
   (replace /tmp/BD-R and /tmp/BD-R-1 etc with /mnt/udf)
   (separate into different images for each setup)
   (verify file size is okay before finishing copying)
   )))

(completed
 (we should not use our default password on the luks, we should
  generate a new one))

(completed (We should include restoration instructions on the blurays.))

(we should make it semi automatic and part of the KBFS system)

(we should backup a lot of things, and focus more energy on
 getting the dirs correct in the first place)

(noted elsewhere
 (we should get another blu-ray drive))

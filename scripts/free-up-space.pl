#!/usr/bin/perl -w

# knowing the importance of various files, we can delete them

# first determine the size data of all the files on the drive

# then also, computer their importance.

# then select with the user which files to delete

# just look at the disk to see what is taking up the most space

# first construct an ls -alR

# then analyze for top space hogging directories and files

# make a report of what should be used up

# sudo find / -exec du -sk {} \; | sort -rn | head -50

system "sudo find / -exec du -sk {} \\; > result.txt";

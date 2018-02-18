To recover the data from this backup, you have to locate the other
disks as well.  This is because each disk has a portion of the total
files.  Sometimes directories and descendent directories will be split
across disks.

You can use the following command to piece the files back together,
where you replace <VOLUME-NAME> with the volume's mount dir name, and
<DIR-TO-BE-RECONSTITUTED> with the name of one of the directories that
was initially backed up to the disk.  So for instance, when I had run
'./kbfs -d /var/lib/myfrdcsas', then <DIR-TO-BE-RECONSTITUTED> would
be /var/lib/myfrdcsas.

Please note that it will make a mess of an existing directory there,
it is best to do it when the <DIR-TO-BE-RECONSTITUTED> doesn't exist
on the target machine.  Also, the trailing '/' after the two
<DIR-TO-BE-RECONSTITUTED> items are critical due to rsync's behavior,
which would otherwise make a mess of things.

rsync -av --progress /media/<VOLUME-NAME/<DIR-TO-BE-RECONSTITUTED>/ <DIR-TO-BE-RECONSTITUTED>/


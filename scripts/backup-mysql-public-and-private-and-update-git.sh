#!/bin/bash

/var/lib/myfrdcsa/codebases/internal/kbfs/scripts/backup-mysql-databases.pl

# /var/lib/myfrdcsa/codebases/internal/kbfs/data/mysql-backups
# mv mysql-private-backup/.git/ 20151209134114/
# mv mysql-private-backup/ /tmp
# mv 20151209134114/ mysql-private-backup
# cd mysql-private-backup/
# # git add .
# # git commit .
# mv .git/ ..
# git init .
# git add .
# git commit .
# git remote  add origin   /gitroot/mysql-private-backup
# mv /gitroot/mysql-private-backup.git/  /gitroot/mysql-private-backup.git-old/ 
# cd ..

# export ROOTDIR="/gitroot/"
# export REPO="mysql-private-backup"

# cd "$ROOTDIR$REPO"
# mv .git .. && mkdir /tmp/$REPO && mv * /tmp/$REPO
# mv ../.git .
# mv .git/* .
# rmdir .git

# git config --bool core.bare true
# cd ..; mv $REPO $REPO.git

# cd /var/lib/myfrdcsa/codebases/internal/kbfs/data/mysql-backups
# git clone /gitroot/mysql-private-backup

# cd /var/lib/myfrdcsa/codebases/internal/kbfs/data/mysql-backups
# mv .git /tmp




# cd /var/lib/myfrdcsa/codebases/internal/kbfs/scripts
# ./backup-mysql-databases.pl --public

# cd /var/lib/myfrdcsa/codebases/internal/kbfs/data
# rm mysql-backup
# ln -s mysql-backups/20150918140649 mysql-backup




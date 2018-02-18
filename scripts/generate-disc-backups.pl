#!/usr/bin/perl -w

# # backup all essential infrastructure

# # backup minor, releases, .myconfig, .myconfig-private, 

# # figure out how to divide things




# # FRDCSA BACKUPS

# # ---

# # 20140902
# /var/lib/myfrdcsas

# # ---

# # 20140904
# /var/lib/myfrdcsa/codebases/data
# /var/lib/myfrdcsa/codebases/minor-data

# # ---

# # sandbox_and_external 20140905
# /var/lib/myfrdcsa/sandbox/
# /var/lib/myfrdcsa/codebases/external

# # ---

# # /var/lib/myfrdcsa/datasets/

# # ---

# ??? /s3/repositories/ ???
# ??? /s3/repos/ ???

# # ---

# # PRIVATE BACKUPS

# /var/lib/myfrdcsa/codebases/work
# /s3/secure-document-backup
# ???  parts of /media/andrewdo/backup/need-to-replicate  ???
# ??? Music ???

# # OTHER BACKUPS

# /gitroot/computing-workshop

# frdcsa-misc

# # myfrdcsa-1.1

# # mysql-backup: this should be covered by the data backup, double
# # check

# picform
# posibot.git
# posi-log-bot
# releases
# SPSE
# unilang-irc-bot work



# (export services.frdcsa.org debian repo to bd-r)

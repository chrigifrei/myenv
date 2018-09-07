#!/bin/bash
# Fri May 27 15:26:58 CEST 2016
# Backup rotation
#
# cronjob (should run daily):
# 15 1 * * * /usr/local/bin/backup-rotation.sh

LOG_FILE="/var/log/messages"
DB_BACKUP_PREFIX="backup-db-"
DATA_BACKUP_PREFIX="backup-"

DAILY_RETENTION=7	# keep 7 daily backups
WEEKLY_RETENTION=5	# keep 5 weekly backups
MONTHLY_RETENTION=12	# keep 12 monthly backups

# backup folders
BACKUP_DIR="/var/opt/backup"
DAILY_BACKUP_DIR="$BACKUP_DIR/0-daily"
WEEKLY_BACKUP_DIR="$BACKUP_DIR/1-weekly"
MONTHLY_BACKUP_DIR="$BACKUP_DIR/2-monthly"

# backup folder
SRC_DIR=$BACKUP_DIR

# get the latest backup archives 
# not older than 1 day
db_archive=$(find $SRC_DIR/ -maxdepth 1 -name "$DB_BACKUP_PREFIX*" -type f -mtime -1)
data_archive=$(find $SRC_DIR/ -maxdepth 1 -name "$DATA_BACKUP_PREFIX*" -type f -mtime -1)


# checks
# fail if destination folders are not present
for d in $BACKUP_DIR $DAILY_BACKUP_DIR $WEEKLY_BACKUP_DIR $MONTHLY_BACKUP_DIR; do
	[[ ! -d $d ]] && logger -f $LOG_FILE -t $0 "[ERROR] destination backup dir $d does not exist. exiting." && exit 1
done

# fail if backup archives are not present or older than 1 day
[[ ! -f $db_archive ]] && logger -f $LOG_FILE -t $0 "[ERROR] backup archive $db_archive not available at $SRC_DIR. exiting." && exit 1

[[ ! -f $data_archive ]] && logger -f $LOG_FILE -t $0 "[ERROR] backup archive $data_archive not available at $SRC_DIR. exiting." && exit 1

# script runs daily
# first day of month? AND saturday?
if [ $(date +"%d") -eq 1 ] && [ $(date +"%u") -eq 6 ]; then
	destinations="$DAILY_BACKUP_DIR $WEEKLY_BACKUP_DIR $MONTHLY_BACKUP_DIR"
# first day of month?
elif [ $(date +"%d") -eq 1 ] ; then
	destinations="$DAILY_BACKUP_DIR $MONTHLY_BACKUP_DIR"
# saturday?
elif [ $(date +"%u") -eq 6 ] ; then
	destinations="$DAILY_BACKUP_DIR $WEEKLY_BACKUP_DIR"
else
	destinations="$DAILY_BACKUP_DIR"
fi

# Move the files
for d in $destinations; do
	cp -p $db_archive $d/
	cp -p $data_archive $d/
done
rm -f $db_archive
rm -f $data_archive

# clean up
for backup_files in $DB_BACKUP_PREFIX $DATA_BACKUP_PREFIX; do
	# daily
	i=1; 
	for f in $( ls -t $DAILY_BACKUP_DIR/ | grep $backup_files ); do 
		[[ $i -le $DAILY_RETENTION ]] && i=$(($i + 1)) && continue; 
		rm -f $DAILY_BACKUP_DIR/$f; 
	done
	# weekly
	i=1; 
	for f in $( ls -t $WEEKLY_BACKUP_DIR/ | grep $backup_files ); do 
		[[ $i -le $WEEKLY_RETENTION ]] && i=$(($i + 1)) && continue; 
		rm -f $WEEKLY_BACKUP_DIR/$f; 
	done
	# monthly
	i=1; 
	for f in $( ls -t $MONTHLY_BACKUP_DIR/ | grep $backup_files ); do 
		[[ $i -le $MONTHLY_RETENTION ]] && i=$(($i + 1)) && continue; 
		rm -f $MONTHLY_BACKUP_DIR/$f; 
	done
done

exit 0

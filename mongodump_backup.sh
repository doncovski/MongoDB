#!/bin/bash
SHARD_BACKUP="Y"
MONGOS_HOST="hostname"
MONGOS_PORT="27020"
MONGOUSER="user"
MONGOPASS="password"

BACKUP_DIR="/backup/mongo/cluster"
NOW=$(date +%F_%H-%M-%S)
LOG_DIR=$BACKUP_DIR/logs
LOG_FILE=$LOG_DIR/Backup-$NOW.log
RETENTION_DAYS=15
MONGODUMP=/usr/local/mongodb/bin/mongodump
#set -x
errorstat="0"

write_errorlog_exit () {
 # echo to the standard output and to the logfile
 LOGENTRY="$USER@$HOSTNAME $(date +'%F %T'): $@"
 echo $LOGENTRY >> $LOG_FILE
 exit 1
}

# Check if directories have been created and initialize
if [ ! -d "$LOG_DIR" ]; then
 mkdir -p "$LOG_DIR";
 if [ "$?" != "0" ]; then
   write_errorlog_exit "backup directory not exists"
 fi
fi


if [ "$SHARD_BACKUP" == "Y" ]; then
 $MONGODUMP --host $MONGOS_HOST --port $MONGOS_PORT --username $MONGOUSER --password $MONGOPASS --out $BACKUP_DIR/$NOW.dump
else
 $MONGODUMP --username $MONGOUSER --password $MONGOPASS --out $BACKUP_DIR/$NOW.dump
fi


if [ "$?" != "0" ]; then
 write_errorlog_exit "mongodump process failed"
fi


#$GZIP $BACKUP_DIR/$NOW.dump
/bin/tar --remove-files -zcvf $BACKUP_DIR/$NOW.dump.tar.gz $BACKUP_DIR/$NOW.dump

if [ "$?" != "0" ]; then
 write_errorlog_exit "gzip process failed"
fi

echo "Backup success" > $LOG_DAILIES

find $BACKUP_DIR/ -mtime +$RETENTION_DAYS -delete


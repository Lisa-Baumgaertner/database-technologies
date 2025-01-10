#!/bin/bash

# Parameter aus dem Aufruf des Skripts
PG_USER=$1
PG_PASSWORD=$2
PG_HOST=$3
PG_PORT=$4
PG_DB=$5
BACKUP_DIR=$6
DATE=$(date +"%Y%m%d_%H%M%S")

# Logisches Backup mit pg_dump
LOGICAL_BACKUP_FILE="$BACKUP_DIR/${PG_DB}_logical_backup_$DATE.sql"
PGPASSWORD=$PG_PASSWORD pg_dump -U $PG_USER -h $PG_HOST -p $PG_PORT $PG_DB > $LOGICAL_BACKUP_FILE
echo "Logisches Backup erstellt: $LOGICAL_BACKUP_FILE"

# Physisches Backup mit pg_basebackup
PHYSICAL_BACKUP_DIR="$BACKUP_DIR/physical_backup_$DATE"
PGPASSWORD=$PG_PASSWORD pg_basebackup -U $PG_USER -h $PG_HOST -p $PG_PORT -D $PHYSICAL_BACKUP_DIR -F tar -X fetch
echo "Physisches Backup erstellt: $PHYSICAL_BACKUP_DIR"

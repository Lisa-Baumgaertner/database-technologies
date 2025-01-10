#!/bin/bash

# Parameter aus dem Aufruf des Skripts
MONGO_URI=$1
MONGO_DB=$2
BACKUP_DIR=$3
DATE=$(date +"%Y%m%d_%H%M%S")

# Logisches Backup mit mongodump
LOGICAL_BACKUP_DIR="$BACKUP_DIR/mongodump_$DATE"
mongodump --uri="$MONGO_URI" --db="$MONGO_DB" --out="$LOGICAL_BACKUP_DIR"
echo "MongoDB logisches Backup erstellt: $LOGICAL_BACKUP_DIR"

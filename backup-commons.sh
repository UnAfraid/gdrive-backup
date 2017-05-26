#!/bin/bash
DIR=$(dirname "${BASH_SOURCE[0]}")
TODAY=$(date +"%Y-%m-%d")

# Color constants.
SETCOLOR_GREEN="\\033[1;32m"
SETCOLOR_RED="\\033[1;31m"
SETCOLOR_YELLOW="\\033[1;33m"
SETCOLOR_CYAN="\\033[1;36m"
SETCOLOR_DEBUG="\\033[0;95m"
SETCOLOR_DEFAULT="\\033[0;39m"

print_log() {
    echo -ne $1
    echo -ne $2
    echo -e $SETCOLOR_DEFAULT
}

# Verify if env file exists
BACKUP_ENV="$DIR/conf/backup.env"
BACKUP_CONF="$DIR/conf/backup-conf.sh"
if [ ! -f $BACKUP_ENV ]; then
	print_log $SETCOLOR_RED "Missing $BACKUP_ENV!"
	exit 1
fi

# Verify if conf file exists
if [ ! -f $BACKUP_CONF ]; then
	print_log $SETCOLOR_RED "Missing $BACKUP_CONF!"
	exit 1
fi

# Include files
source $BACKUP_ENV
source $BACKUP_CONF
if [ ! -x $BACKUP_CONF ]; then
	chmod +x $BACKUP_CONF
fi

# Execute files
. $BACKUP_CONF

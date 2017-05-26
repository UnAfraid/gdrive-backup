#!/bin/bash
DIR=$(dirname "${BASH_SOURCE[0]}")
BACKUP_COMMONS="$DIR/backup-commons.sh"

# Verify if env file exists
if [ ! -f $BACKUP_COMMONS ]; then
	echo "Missing $BACKUP_COMMONS !"
	exit 1
fi

if [ ! -x $BACKUP_COMMONS ]; then
	chmod +x $BACKUP_COMMONS
fi

source $BACKUP_COMMONS
. $BACKUP_COMMONS

# Backup each database into its own file
if [ $MYSQL_INDIVIDUAL_BACKUP_ENABLED ]; then
	# Create folders
	if [ ! -d $BACKUP_DATABASE_DIR ]; then 
		mkdir -p $BACKUP_DATABASE_DIR
		drive push -no-prompt $BACKUP_DATABASE_DIR
	fi
	
	print_log $SETCOLOR_CYAN "Backuping individual databases.."

	# Backup databases
	DB_TODAY="$BACKUP_DATABASE_DIR/$TODAY"
	if [ ! -d $DB_TODAY ]; then
		mkdir $DB_TODAY;
		print_log $SETCOLOR_YELLOW "Creating folder ${DB_TODAY}"
	fi
	
	print_log $SETCOLOR_CYAN "Backuping individual databases.."
	for db in $(mysql -NB -e "SHOW DATABASES" -p$MYSQL_PASSWORD); do
		if [[ ! "${MYSQL_DATABASE_EXCLUSIONS[@]}" =~ "${db}" ]]; then
			print_log $SETCOLOR_GREEN "Backuping db ${db} .."
			mysqldump --opt -u root -p$MYSQL_PASSWORD $db | zip -q -9 > "$DB_TODAY/$db-$(date +'%T').sql.zip"
		fi
	done
fi

# Backup all databases into single file
if [ $MYSQL_ALL_DATABASES_BACKUP_ENABLED ]; then
	# Create folders
	if [ ! -d $BACKUP_DATABASE_DIR ]; then 
		mkdir -p $BACKUP_DATABASE_DIR
		drive push -no-prompt $BACKUP_DATABASE_DIR
	fi
	
	print_log $SETCOLOR_CYAN "Backuping all databases.."
	mysqldump --opt -u root -p$MYSQL_PASSWORD --all-databases | zip -q -9 > "$DB_TODAY/all-databases-$(date +"%T").sql.zip"
fi

# Push all to google drive
print_log $SETCOLOR_GREEN "Pushing all changes to google drive.."
drive push -no-prompt $DB_TODAY
print_log $SETCOLOR_GREEN "Done!"


#print_log $SETCOLOR_GREEN "Cleaning up.."
#[ ! -z $DB_TODAY ] && [ -d $DB_TODAY ] && rm -rf $DB_TODAY
#print_log $SETCOLOR_GREEN "Done!"
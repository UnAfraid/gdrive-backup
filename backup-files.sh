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

if [ ! ${#FILE_INCLUSIONS[@]} -eq 0 ]; then
	# Create folders
	if [ ! -d $BACKUP_DIR ]; then
		mkdir -p $BACKUP_DIR
		drive push -no-prompt $BACKUP_DIR
	fi
	
	# Copy individual files
	FILES_TODAY="$BACKUP_DIR/files"
	for file in "${FILE_INCLUSIONS[@]}"; do
		path=$(dirname $file)
		mkdir -p "$FILES_TODAY/$path";
		cp $file "${FILES_TODAY}${file}"
		
		print_log $SETCOLOR_GREEN "Backuping file ${file} .."
	done
	
	print_log $SETCOLOR_GREEN "Pushing additional files to google drive.."
	drive push -no-prompt $FILES_TODAY
fi


if [ ! ${#DIRECTORIES_TODAY[@]} -eq 0 ]; then
	# Create folders
	if [ ! -d $BACKUP_DIR ]; then
		mkdir -p $BACKUP_DIR
		drive push -no-prompt $BACKUP_DIR
	fi
	
	DIRECTORIES_TODAY="$BACKUP_DIR/directories"
	# Copy individual files
	for dir in "${FOLDER_INCLUSIONS[@]}"; do
		path=$(filename $dir)
		print_log $SETCOLOR_GREEN "Backuping directory ${dir} .."
		mkdir -p "$DIRECTORIES_TODAY/$path";
		zip -q -9 -r "$DIRECTORIES_TODAY/$path.zip" $dir -x "*.git*"
		
	done

	print_log $SETCOLOR_GREEN "Pushing additional directories to google drive .."
	drive push -no-prompt $DIRECTORIES_TODAY
fi

if $BACKUP_HOME_DIR_ENABLED; then
	# Create folders
	if [ ! -d $BACKUP_HOME_DIR ]; then
		mkdir -p $BACKUP_HOME_DIR
		drive push -no-prompt $BACKUP_HOME_DIR
	fi

	# Backup all home directories
	HOME_TODAY="$BACKUP_HOME_DIR/$TODAY"
	if [ ! -d $HOME_TODAY ]; then
		mkdir $HOME_TODAY
		print_log $SETCOLOR_YELLOW "Creating folder ${HOME_TODAY}"
	fi

	print_log $SETCOLOR_CYAN "Backuping home directories.."
	for dir in /home/*; do
		home=$(filename $dir)
		print_log $SETCOLOR_GREEN "Backuping directory ${home} .."

		zip -q -9 -r "$HOME_TODAY/$home.zip" $dir -x "*.git*"
	done

	# Push all to google drive
	print_log $SETCOLOR_GREEN "Pushing all changes to google drive.."
	drive push -no-prompt $HOME_TODAY
	print_log $SETCOLOR_GREEN "Done!"
fi

#print_log $SETCOLOR_GREEN "Cleaning up.."
#[ ! -z $FILES_TODAY ] && [ -d $FILES_TODAY ] && rm -rf $FILES_TODAY
#[ ! -z $DIRECTORIES_TODAY ] && [ -d $DIRECTORIES_TODAY ] && rm -rf $DIRECTORIES_TODAY
#[ ! -z $HOME_TODAY ] && [ -d $HOME_TODAY ] && rm -rf $HOME_TODAY
#print_log $SETCOLOR_GREEN "Done!"

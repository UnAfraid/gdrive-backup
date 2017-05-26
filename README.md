# gdrive-backup

Simple scripts that allows backup of essential files to Google Drive cloud

## Dependencies:
- https://github.com/odeke-em/drive
- wcstools package (filename / dirname commands)
- git package

## Installing:
- root@localhost:~# wget -O /usr/local/bin/drive https://github.com/odeke-em/drive/releases/download/v0.3.9/drive_linux
- root@localhost:~# drive init google_drive
- root@localhost:~# drive pull google_drive
- root@localhost:~# mkdir google_drive/Backups/$(uname -n)
- root@localhost:~# drive push google_drive/ -no-prompt
- root@localhost:~# git clone https://github.com/UnAfraid/gdrive-backup
- root@localhost:~# cp gdrive-backup/conf/backup.env.example conf/gdrive-backup/backup.env
- root@localhost:~# cp gdrive-backup/conf/backup-conf.sh.example gdrive-backup/conf/backup-conf.sh
- root@localhost:~# nano gdrive-backup/conf/backup.env # `Edit MYSQL_PASSWORD value`
- root@localhost:~# nano gdrive-backup/conf/backup-conf.sh # `Edit additional files or directories to backup`
- root@localhost:~# ./gdrive-backup/backup-files.sh # `Backup all files/directories and home directories`
- root@localhost:~# ./gdrive-backup/backup-db.sh # `Backup all databases`

## Throbleshuting:
- In case you see this:
```
Resolving...
Everything is up-to-date.
```
It means you don't have the parent folder at your remote google drive, in order to resolve it just use `drive push /root/google_drive/Backups`

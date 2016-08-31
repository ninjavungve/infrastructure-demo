#!/bin/bash
set -f

VOLUMES="postgres gitlab mail web web_logs minecraft"
REMOTE="sftp://xxx@xxx.your-backup.de"
export GNUPGHOME="/root/.gnupg"
export GNUPGKEY="xxx"
export PASSPHRASE=""

log() {
	echo "`date` - $*"
}

cleanup() {
	grep -q "/mnt/backup_snapshot" /proc/mounts && umount /mnt/backup_snapshot
	test -d /mnt/backup_snapshot && rmdir /mnt/backup_snapshot
	test -e /dev/vg0/backup_snapshot && lvm lvremove --force /dev/vg0/backup_snapshot
}

finalize() {
	log "Cleaning up..."
	cleanup
	log "Bye bye."
	exit
}
trap finalize TERM INT

log "Backing up volumes $VOLUMES"
cleanup

for v in $VOLUMES; do
	echo ""
	log "Creating LVM snapshot of volume $v..."
	lvm lvcreate --size 512M --snapshot --name backup_snapshot /dev/vg0/$v
	log "Checking snapshot volume..."
	fsck -p /dev/vg0/backup_snapshot >/dev/null
	log "Backing up snapshot volume..."
	dir="/mnt/backup_snapshot"
	mkdir -p $dir
	mount /dev/vg0/backup_snapshot $dir
	duplicity incremental --asynchronous-upload \
		--encrypt-key $GNUPGKEY --sign-key $GNUPGKEY \
		--full-if-older-than 7D --exclude-other-filesystems \
		$dir $REMOTE/backup_$v
	log "Cleaning up..."
	cleanup
done

log "Removing old backups..."
for v in $VOLUMES; do
	duplicity cleanup -v1 --force $REMOTE/backup_$v
	duplicity remove-older-than 2M -v1 --force $REMOTE/backup_$v
done

finalize

#!/usr/bin/env ash

ls -A /etc/ssh
if [ ! "$(ls -A /etc/ssh)" ]; then
	mv /sshd_config.backup /etc/ssh/sshd_config
	ls /etc/ssh
	ssh-keygen -A
fi

echo "Running $@"
exec "$@"
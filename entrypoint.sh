#!/usr/bin/env bash

ls -A /etc/ssh
if [ ! "$(ls -A /etc/ssh)" ]; then
	mv /sshd_config.backup /etc/ssh/sshd_config
	ls /etc/ssh
	ssh-keygen -A
fi

# Fix permissions, if writable
if [ -w ~/.ssh ]; then
    chown root:root ~/.ssh && chmod 700 ~/.ssh/
fi
if [ -w ~/.ssh/authorized_keys ]; then
    chown root:root ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
fi

# https://github.com/panubo/docker-sshd/blob/master/entry.sh
# Add users if SSH_USERS=user:uid:gid:pwd set
if [ -n "${SSH_USERS}" ]; then
    USERS=$(echo $SSH_USERS | tr "," "\n")
    for U in $USERS; do
        IFS=':' read -ra UA <<< "$U"
        _NAME=${UA[0]}
        _UID=${UA[1]}
        _GID=${UA[2]}
        _PWD=${UA[3]}

        echo ">> Adding user ${_NAME} with uid: ${_UID}, gid: ${_GID}."
        getent group ${_NAME} >/dev/null 2>&1 || addgroup -g ${_GID} ${_NAME}
        getent passwd ${_NAME} >/dev/null 2>&1 || adduser -D -u ${_UID} -G ${_NAME} -s '' ${_NAME}
        if [ "${_PWD}" != "" ]; then
        	echo -e "${_PWD}\n${_PWD}" | passwd ${_NAME} >> /dev/null
        else
        	passwd -u ${_NAME} || true
        fi
    done
else
    # Warn if no authorized_keys
    if [ ! -e ~/.ssh/authorized_keys ]; then
      echo "WARNING: No SSH authorized_keys found!"
    fi
fi

echo "Running $@"
exec "$@"
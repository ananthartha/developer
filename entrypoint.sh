#!/bin/bash

PUID=${PUID:-911}
PGID=${PGID:-911}

mkdir -p \
  /config/{.ssh,ssh_host_keys,logs/openssh}

mkdir -p /run/sshd

[ $(getent group developer) ] || groupadd -g $PGID -o developer

if [[ ! $(id -u $USER_NAME &>/dev/null) ]]; then
  # Crete User
  useradd -m -u $PUID -g $PGID -o -s /bin/bash $USER_NAME 
  # Create Home Dir
  mkdir -p /home/$USER_NAME/.ssh

  [[ -n "$PUBLIC_KEY" ]] && \
      [[ ! $(grep "$PUBLIC_KEY" /home/$USER_NAME/.ssh/authorized_keys) ]] && \
      echo "$PUBLIC_KEY" >> /home/$USER_NAME/.ssh/authorized_keys && \
      chown -R $USER_NAME:developer /home/$USER_NAME/ && \
      echo "Public key from env variable added"
fi

/usr/sbin/sshd -D -e -p 22

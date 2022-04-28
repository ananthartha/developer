#!/bin/bash

PGID=${PGID:-911}
PUID=${INIT_PUID:-911}

mkdir -p \
  /config/{.ssh,ssh_host_keys,logs/openssh}

mkdir -p /run/sshd

[ $(getent group developer) ] || groupadd -g $PGID -o developer

for i in "${!foo[@]}"; do 
  printf "%s\t%s\n" "$i" "${foo[$i]}"
done

USERS=($USER_NAMES)
KEYS=($PUBLICK_EYS)

for index in "${!USERS[@]}"; do
  username=USERS[$index]
  publickey=KEYS[$index]

  if [[ ! $(id -u $username &>/dev/null) ]]; then
    # Crete User
    useradd -m -u $PUID -g $PGID -o -s /bin/bash $username 
    # Create Home Dir
    mkdir -p /home/$username/.ssh

    [[ -n "$publickey" ]] && \
        [[ ! $(grep "$publickey" /home/$username/.ssh/authorized_keys) ]] && \
        echo "$publickey" >> /home/$username/.ssh/authorized_keys && \
        chown -R $username:developer /home/$username/ && \
        echo "Public key from env variable added"
  fi
  PUID=$PUID+1
done

/usr/sbin/sshd -D -e -p 22
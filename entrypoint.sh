#!/bin/bash

# Hoembrew setup
if [[ ! -d "home/linuxbrew/.linuxbrew" ]]; then
  su linuxbrew -c 'USER=linuxbrew /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
  su linuxbrew -c 'brew install brew tap nats-io/nats-tools'
  su linuxbrew -c 'brew install grpc grpcurl'
  su linuxbrew -c 'brew install nats-io/nats-tools/nats'
  chmod 744 -R /home/linuxbrew/.linuxbrew
fi
# Hoembrew setup

PGID=${PGID:-911}
PUID=${INIT_PUID:-911}

mkdir -p \
  /config/{.ssh,ssh_host_keys,logs/openssh}

mkdir -p /run/sshd

[ $(getent group developer) ] || groupadd -g $PGID -o developer

USERS=($USER_NAMES)
KEYS=($PUBLICK_EYS)

for index in "${!USERS[@]}"; do
  username=${USERS[$index]}
  publickey=${KEYS[$index]}

  if [[ ! $(id -u $username &>/dev/null) ]]; then
    # Crete User
    useradd -m -u $PUID -g $PGID -o -s /bin/bash $username 
    printf "%s\t added\n" "$username"
    # Create Home Dir
    mkdir -p /home/$username/.ssh

    [[ -n "$publickey" ]] && \
        [[ ! $(grep "$publickey" /home/$username/.ssh/authorized_keys) ]] && \
        echo "$publickey" >> /home/$username/.ssh/authorized_keys && \
        chown -R $username:developer /home/$username/ && \
        printf "Public key addedd for %s\n" "$username"
  fi
  PUID=$(expr $PUID + 1)
done

/usr/sbin/sshd -D -e -p 22
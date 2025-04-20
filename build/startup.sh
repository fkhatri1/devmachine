#!/bin/sh

# Load env vars
set -a
. /root/secrets.env
set +a

# Setup SSH server
mkdir -p /var/run/sshd
sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
mkdir -p /root/.ssh
cp /root/projects/devmachine/dev_machine_key_pair.pub /root/.ssh/authorized_keys
chmod 700 /root/.ssh
chmod 600 /root/.ssh/authorized_keys

# Start SSH server
/usr/sbin/sshd

# Start SSH agent and save environment variables for later shells
eval $(ssh-agent -s)
ssh-add /root/projects/devmachine/build/dev_machine_key_pair

# Save agent socket path for future shells
echo "export SSH_AUTH_SOCK=$SSH_AUTH_SOCK" >> /root/.ssh-agent-exports
echo "export SSH_AGENT_PID=$SSH_AGENT_PID" >> /root/.ssh-agent-exports

# Setup Git
git config --global user.email "faysalkhatri@gmail.com"
git config --global user.name "Faysal Khatri"

# Start a shell to keep container running
tail -f /dev/null

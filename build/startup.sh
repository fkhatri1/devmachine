#!/bin/sh

# Set env vars
set -a
. /root/secrets.env
set +a

# Setup SSH server
mkdir /var/run/sshd
# Set SSH to listen on port 22 
sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config
# Disable password authentication and use keys only
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
# Add public key
mkdir -p /root/.ssh
cp /root/projects/devmachine/dev_machine_key_pair.pub /root/.ssh/authorized_keys
# Start SSH server
/usr/sbin/sshd -D &

# Setup Git
# SECRETS
git config --global user.email "faysalkhatri@gmail.com"
git config --global user.name "Faysal Khatri"
eval $(ssh-agent)
ssh-add /root/projects/devmachine/build/dev_machine_key_pair
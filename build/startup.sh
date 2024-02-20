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

# Start JupyterLab
nohup jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root  1>>~/jupyter.log 2>>~/jupyter.log &
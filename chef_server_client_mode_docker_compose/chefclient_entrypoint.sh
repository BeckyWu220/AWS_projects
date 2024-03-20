#!/bin/bash
echo "Executing entrypoint.sh"

echo "Copy public key in order be connected from Chef Station."
mkdir -p ~/home/.ssh
cat $PUB_KEY >> /home/sshuser/.ssh/authorized_keys

# Allow sshuser to connect without password when using SSH keys.
echo "sshuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
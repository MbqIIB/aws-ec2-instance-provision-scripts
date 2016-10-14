#!/bin/bash

echo "Creating Swap File.."
dd if=/dev/zero of=/mnt/.swapfile bs=1M count=1024
chown root:root /mnt/.swapfile
chmod 600 /mnt/.swapfile

echo "Mounting & Enabling Swap Memory.."
mkswap /mnt/.swapfile
swapon /mnt/.swapfile
sh -c 'echo "/mnt/.swapfile swap swap defaults 0 0" >> /etc/fstab'
swapon -a

#!/bin/bash

cd ~

mkdir -p ~/.ssh

#cp -r /mnt/S3.Buckets/Global.GEM.Apps/SSH.Config.Files/.ssh ~/.ssh
aws s3 cp s3://global.gem.apps/SSH.Config.Files/.ssh ~/.ssh --recursive

chmod 775 ~/.ssh
chmod 600 ~/.ssh/*

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config

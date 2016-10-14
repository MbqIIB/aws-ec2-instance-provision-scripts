#!/bin/bash

mkdir -p /mnt/S3.Buckets/Global.GEM.Apps
chmod -R 777 /mnt/S3.Buckets/Global.GEM.Apps

echo 's3fs#global.gem.apps /mnt/S3.Buckets/Global.GEM.Apps fuse _netdev,nonempty,allow_other,passwd_file=/aws.services/.aws/.ec2admin.credentials,uid=1002,gid=1001 0 0' >> /etc/fstab
mount -a

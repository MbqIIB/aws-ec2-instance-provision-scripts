#!/bin/bash

#GET Project's Name and EcoSystem
PRJGROUP=$(cat /aws.services/.ec2Instance| grep EcoSystem | awk '{print $2}')
PRJUSER=$(cat /aws.services/.ec2Instance| grep WebApplication | awk '{print $2}')

#ERROR Handing Function
die() {
    echo "FATAL ERROR: $* (status $?)" 1>&2
    echo "Aborting Deployment.." 1>&2
    exit 1
}

echo $PRJGROUP
echo $PRJUSER

mkdir -p /mnt/S3.Buckets/$PRJGROUP.$PRJUSER || die "Failed to prepare mounting point folder"
chmod -R 777 /mnt/S3.Buckets/$PRJGROUP.$PRJUSER || die "Failed to apply the correct permissions on the mounting point"

echo "s3fs#$PRJGROUP.$PRJUSER /mnt/S3.Buckets/$PRJGROUP.$PRJUSER fuse _netdev,nonempty,allow_other,passwd_file=/aws.services/.aws/.$PRJGROUP.$PRJUSER.credentials,uid=1002,gid=1001 0 0" >> /etc/fstab
cat /etc/fstab
mount -a || die "Failed to Mount Project S3.Bucket.."

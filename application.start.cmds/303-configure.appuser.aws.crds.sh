#!/bin/bash

#GET Project's Name and EcoSystem
PRJGROUP=$(cat /aws.services/.ec2Instance| grep EcoSystem | awk '{print $2}')
PRJUSER=$(cat /aws.services/.ec2Instance| grep WebApplication | awk '{print $2}')

echo $PRJGROUP
echo $PRJUSER

#yes|cp /mnt/S3.Buckets/Global.GEM.Apps/.aws/$PRJGROUP.$PRJUSER.credentials /aws.services/.aws/.$PRJGROUP.$PRJUSER.credentials
aws s3 cp s3://global.gem.apps/.aws/$PRJGROUP.$PRJUSER.credentials /aws.services/.aws/.$PRJGROUP.$PRJUSER.credentials
chmod 600 /aws.services/.aws/.$PRJGROUP.$PRJUSER.credentials

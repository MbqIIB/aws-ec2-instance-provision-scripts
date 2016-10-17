#!/bin/bash

#GET Project's Name and EcoSystem
PRJGROUP=$(cat /aws.services/.ec2Instance| grep EcoSystem | awk '{print $2}')
PRJUSER=$(cat /aws.services/.ec2Instance| grep WebApplication | awk '{print $2}')
APPENV=$(cat /aws.services/.ec2Instance| grep Environment | awk '{print $2}')
APPINTERFACE=$(cat /aws.services/.ec2Instance| grep Interface | awk '{print $2}')

#ERROR Handing Function
die() {
    echo "FATAL ERROR: $* (status $?)" 1>&2
    echo "Aborting Deployment.." 1>&2
    exit 1
}

echo $PRJGROUP
echo $PRJUSER

cd /home/$PRJUSER/
export SYMFONY_ENV=prod

cd /var/www/$PRJGROUP.$PRJUSER/Initial.Deployment/

#yes|cp /mnt/S3.Buckets/$PRJGROUP.$PRJUSER/WebApp.Config.Files/$APPENV.env/parameters.yml /var/www/$PRJGROUP.$PRJUSER/Initial.Deployment/app/config/parameters.yml
aws s3 cp s3://$PRJGROUP.$PRJUSER/WebApp.Config.Files/$APPENV.env/parameters.yml /var/www/$PRJGROUP.$PRJUSER/Initial.Deployment/app/config/parameters.yml

chmod 600 /var/www/$PRJGROUP.$PRJUSER/Initial.Deployment/app/config/parameters.yml

composer -v install --no-dev --optimize-autoloader

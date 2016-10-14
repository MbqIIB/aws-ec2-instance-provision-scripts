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

cd ~

ln -s /var/www ~/www

ln -s /var/www/$PRJGROUP.$PRJUSER/Initial.Deployment/ /var/www/$PRJGROUP.$PRJUSER/live
ln -s /var/www/$PRJGROUP.$PRJUSER/live/ ~/live

mkdir -p ~/all.logs/

ln -s /var/www/$PRJGROUP.$PRJUSER.vhost.logs/nginx.access.logs ~/all.logs/nginx.access.logs
ln -s /var/www/$PRJGROUP.$PRJUSER.vhost.logs/nginx.errors.logs ~/all.logs/nginx.errors.logs
ln -s /var/www/$PRJGROUP.$PRJUSER.vhost.logs/phpfpm.errors.logs ~/all.logs/phpfpm.errors.logs
ln -s /var/www/$PRJGROUP.$PRJUSER.vhost.logs/phpfpm.slowreqs.logs  ~/all.logs/phpfpm.slowreqs.logs
ln -s /var/www/$PRJGROUP.$PRJUSER/live/app/logs/prod.log ~/all.logs/webapp.production.logs

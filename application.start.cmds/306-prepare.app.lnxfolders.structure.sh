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

rm -rf /var/www/*

mkdir -p /var/www/$PRJGROUP.$PRJUSER
mkdir -p /var/www/$PRJGROUP.$PRJUSER/tmp
mkdir -p /var/www/$PRJGROUP.$PRJUSER/Initial.Deployment/

mkdir -p /var/www/$PRJGROUP.$PRJUSER.vhost.confs
mkdir -p /var/www/$PRJGROUP.$PRJUSER.vhost.logs

touch /var/www/$PRJGROUP.$PRJUSER.vhost.logs/nginx.access.logs
touch /var/www/$PRJGROUP.$PRJUSER.vhost.logs/nginx.errors.logs
touch /var/www/$PRJGROUP.$PRJUSER.vhost.logs/phpfpm.errors.logs
touch /var/www/$PRJGROUP.$PRJUSER.vhost.logs/phpfpm.slowreqs.logs

chown -R $PRJUSER:$PRJGROUP /var/www/*

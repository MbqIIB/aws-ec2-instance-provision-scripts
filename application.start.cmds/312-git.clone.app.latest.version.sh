#!/bin/bash

#GET Project's Name and EcoSystem
APPGROUP=$(cat /aws.services/.ec2Instance| grep EcoSystem | awk '{print $2}')
APPUSER=$(cat /aws.services/.ec2Instance| grep WebApplication | awk '{print $2}')
APPENV=$(cat /aws.services/.ec2Instance| grep Environment | awk '{print $2}')

#ERROR Handing Function
die() {
    echo "FATAL ERROR: $* (status $?)" 1>&2
    echo "Aborting Deployment.." 1>&2
    exit 1
}

echo $APPGROUP
echo $APPUSER
echo $APPENV

if [ "$APPENV" = "prod" ];
    then
    repoBranch="master"
fi
if [ "$APPENV" = "beta" ];
    then
    repoBranch="beta"
fi
if [ "$APPENV" = "stg" ];
    then
    repoBranch="staging"
fi

cd ~

git clone -b $repoBranch git@github.com:bridgemanart/$APPGROUP.$APPUSER.git /var/www/$APPGROUP.$APPUSER/Initial.Deployment/

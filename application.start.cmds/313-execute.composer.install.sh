#!/bin/bash

#GET Project's Name and EcoSystem
appEco=$(cat /aws.services/.ec2Instance     | grep EcoSystem        | awk '{print $2}')
appName=$(cat /aws.services/.ec2Instance    | grep WebApplication   | awk '{print $2}')
appEnv=$(cat /aws.services/.ec2Instance     | grep Environment      | awk '{print $2}')
appIFace=$(cat /aws.services/.ec2Instance   | grep Interface        | awk '{print $2}')

#ERROR Handing Function
die() {
    echo "FATAL ERROR: $* (status $?)" 1>&2
    echo "Aborting Deployment.." 1>&2
    exit 1
}


cd /home/$appName/
export SYMFONY_ENV=prod

cd /var/www/$appEco.$appName/Initial.Deployment/

aws s3 cp s3://$appEnv-$appEco-$appName/app-symfony_parameters_yml /var/www/$appEco.$appName/Initial.Deployment/app/config/parameters.yml
chmod 600 /var/www/$appEco.$appName/Initial.Deployment/app/config/parameters.yml

composer -v install --no-dev --optimize-autoloader

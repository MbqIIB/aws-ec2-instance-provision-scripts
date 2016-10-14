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

Instanceuid=$(date +%Y%m%d%H%M%S%N)

echo "Updating Instance's Hostname.."

rm -f /etc/hostname
touch /etc/hostname
echo "$Instanceuid.$PRJUSER.$PRJGROUP.srvs" >> /etc/hostname
echo "HOSTNAME=$Instanceuid.$PRJUSER.$PRJGROUP.srvs" >> /etc/sysconfig/network
echo "preserve_hostname: true" >> /etc/cloud/cloud.cfg
hostname $Instanceuid.$PRJUSER.$PRJGROUP.srvs

cat <<EOT >> /etc/profile.d/prompt.sh
if [ "$PS1" ]; then
   PS1="\\u@$PRJUSER.$PRJGROUP.srvs \\W]\\$"
fi
EOT


echo "Updating Instance's Hosts.."

rm -f /etc/hosts
touch /etc/hosts
echo "127.0.0.1   $Instanceuid.$PRJUSER.$PRJGROUP.srvs $Instanceuid.$PRJUSER.$PRJGROUP.srvs.localdomain localhost localhost.localdomain localhost4 localhost4.localdomain4" >> /etc/hosts
echo "::1	localhost localhost.localdomain localhost6 localhost6.localdomain6" >> /etc/hosts

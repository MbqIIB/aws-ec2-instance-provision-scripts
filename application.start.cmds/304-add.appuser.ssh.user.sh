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

groupadd centos
groupadd $PRJGROUP || die "Unable to create UserGroup: $PRJGROUP"
useradd -g $PRJGROUP $PRJGROUP || die "Unable to create and add User: $PRJGROUP TO UserGroup: $PRJGROUP"
useradd -g $PRJGROUP $PRJUSER || die "Unable to create and add User: $PRJUSER TO UserGroup: $PRJGROUP"

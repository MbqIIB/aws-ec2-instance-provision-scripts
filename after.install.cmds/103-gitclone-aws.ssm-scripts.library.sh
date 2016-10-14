#!/bin/bash

die() {
    echo "FATAL ERROR: $* (status $?)" 1>&2
    echo "Aborting Deployment.." 1>&2
    exit 1
}

echo "Cloning bridgemanart/AWS.EC2-SSM.Scripts.git Repo"
cd /aws.services/ssm
rm -rf AWS.EC2-SSM.Scripts/
git clone git@github.com:bridgemanart/AWS.EC2-SSM.Scripts.git || die "Unable to Clone bridgemanart/AWS.EC2-SSM.Scripts.git"
chmod -R 755 AWS.EC2-SSM.Scripts/

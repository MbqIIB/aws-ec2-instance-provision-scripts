#!/bin/bash

#GET Instance's Information
EC2_INSTANCE_ID=$(cat /aws.services/.ec2Instance | grep instanceID | awk '{print $2}')

#GET Application's Information
APPGROUP=$(cat /aws.services/.ec2Instance | grep EcoSystem | awk '{print $2}')
APPUSER=$(cat /aws.services/.ec2Instance | grep WebApplication | awk '{print $2}')
APPENV=$(cat /aws.services/.ec2Instance | grep Environment | awk '{print $2}')
APPELB=$(cat /aws.services/.ec2Instance | grep connectToELB | awk '{print $2}')
APPPUBNET=$(cat /aws.services/.ec2Instance | grep hasPublicNetwork | awk '{print $2}')

#ERROR Handing Function
die() {
    echo "FATAL ERROR: $* (status $?)" 1>&2
    echo "Aborting Deployment.." 1>&2
    exit 1
}

echo "Instance ID: $EC2_INSTANCE_ID"
echo "EcoSystem: $APPGROUP"
echo "WebApplication: $APPUSER"
echo "Environment: $APPENV"
echo "App has Public Network?: $APPPUBNET"

cd ~

if [ "$APPELB" = "yes" ];
	then
	if [ "$APPPUBNET" = "yes" ];
		then
		aws elb register-instances-with-load-balancer --load-balancer-name ec2-elb-$APPENV-$APPGROUP-$APPUSER --instances $EC2_INSTANCE_ID || die "FAILED to Register Instance to EXTERNAL ELB"
		aws elb register-instances-with-load-balancer --load-balancer-name ec2-ielb-$APPENV-$APPGROUP-$APPUSER --instances $EC2_INSTANCE_ID || die "FAILED to Register Instance to INTERNAL ELB"
		else
  		aws elb register-instances-with-load-balancer --load-balancer-name ec2-ielb-$APPENV-$APPGROUP-$APPUSER --instances $EC2_INSTANCE_ID || die "FAILED to Register Instance to INTERNAL ELB"
	fi
	else
	echo "EC2 Instance does NOT need to register to any Elastic Load Balancer.."
	exit 0
fi

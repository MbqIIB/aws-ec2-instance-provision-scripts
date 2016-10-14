#!/bin/bash

#GET Project's Name and EcoSystem
APPGROUP=$(cat /aws.services/.ec2Instance| grep EcoSystem | awk '{print $2}')
APPUSER=$(cat /aws.services/.ec2Instance| grep WebApplication | awk '{print $2}')
APPINTERFACE=$(cat /aws.services/.ec2Instance| grep Interface | awk '{print $2}')

#ERROR Handing Function
die() {
    echo "FATAL ERROR: $* (status $?)" 1>&2
    echo "Aborting Deployment.." 1>&2
    exit 1
}

echo $APPGROUP
echo $APPUSER
echo $APPINTERFACE

echo "Based on Instance's EcoSystem & WebApplication Tags Values, START the Application's Services"
sh /aws.services/codedeploy/AWS.CodeDeploy.Scripts/application.start.cmds/397-start.all.app.services/$APPGROUP.$APPUSER.services.sh

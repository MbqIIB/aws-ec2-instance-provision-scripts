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

cd ~/live/
mkdir -p var/logs

echo "Check IF GQM-QC:CMD:Transmitter Bundle in enabled in the WebApplication.."
if composer info | grep gqm-client-transmitter > /dev/null
  then
        echo "GQM-QC:CMD:Transmitter Bundle IS ENABLED" >&2
	bash /aws.services/codedeploy/AWS.CodeDeploy.Scripts/application.start.cmds/control.gqm-qc-daemons/start.gqmqc.d-tx.sh
  else
        echo "GQM-QC:CMD:Transmitter Bundle IS NOT ENABLED" >&2
fi

if [ "$APPINTERFACE" = "cli" ];
  then
	echo "Check IF GQM-QC:CMD:Receiver&Executor Bundle in enabled in the WebApplication.."
	if composer info | grep gqm-client-executor > /dev/null
	  then
	        echo "GQM-QC:CMD:Receiver&Executor Bundle IS ENABLED" >&2
		bash /aws.services/codedeploy/AWS.CodeDeploy.Scripts/application.start.cmds/control.gqm-qc-daemons/start.gqmqc.d-rxe.sh
	  else
	        echo "GQM-QC:CMD:Receiver&Executor Bundle IS NOT ENABLED" >&2
	fi
fi

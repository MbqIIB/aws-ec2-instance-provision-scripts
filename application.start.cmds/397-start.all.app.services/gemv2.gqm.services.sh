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

echo "Based on Instance's Interface Tag Value enable (or not) the GQM Daemons.."
if [ "$APPINTERFACE" = "cli" ];
	then
			cd ~
			echo "Instance will be using it's CLI Interface, so GQM Daemons WILL be enabled.."
			cd ~/live/
			echo "Starting GQM:CMD:Importer.."
			php bin/console --env=prod gqm:redis:listener 2>> var/logs/gemv2.gqm-cmd-importer.errors.logs >> var/logs/gemv2.gqm-cmd-importer.output.logs &
			echo "Starting GQM:CMD:Processor.."
			php bin/console --env=prod gqm:spawner:processor 2>> var/logs/gemv2.gqm-cmd-processor.errors.logs >> var/logs/gemv2.gqm-cmd-processor.output.logs &
fi

if [ "$APPINTERFACE" = "http" ];
	then
			cd ~
			echo "Instance will be using only the HTTP Interface, so GQM Daemons WILL NOT be enabled.."
fi

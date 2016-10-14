#!/bin/bash
# ------------------------------------------------------------------
# [Georgios Fisaris]    start.gqm-qc.d:cmd:rx-executor
# ------------------------------------------------------------------

VERSION=0.1.0
SUBJECT=aws.ec2.ssm-startGQM-QC_CMD_RxExecutor

# --- Predefined Values -------------------------------------------

daemonName="GQM-QC:Command:RxExecutor"
daemonCode="gqm-qc.d:cmd:rxe"
deamonParameters="-w 2"
daemonSTOPFile=".stop.gqmqc-rxe.service"

# --- Locks -------------------------------------------------------
#LOCK_FILE=/tmp/$SUBJECT.lock
#if [ -f "$LOCK_FILE" ]; then
#   echo "Script is already running"
#   exit
#fi
#
#trap "rm -f $LOCK_FILE" EXIT
#touch $LOCK_FILE

# --- Global Functions --------------------------------------------

checkDaemon () {
  local optDaemonCode="$1"

  echo "Checking Daemon [ $optDaemonCode ] STATUS.." >&2

	if ps ax | grep -v grep | grep $optDaemonCode > /dev/null
	  then
	        echo "Daemon [ $optDaemonCode ] STATUS: Running .." >&2
		echo "1"
	
	  else
	        echo "Daemon [ $optDaemonCode ] STATUS: NOT Running .." >&2
		echo "0"
	fi
}

# --- Body --------------------------------------------------------

appGroup=$(cat /aws.services/.ec2Instance| grep EcoSystem | awk '{print $2}')
appUser=$(cat /aws.services/.ec2Instance| grep WebApplication | awk '{print $2}')

echo "EcoSystem: "$appGroup
echo "WebApplication: "$appUser

workingDir=$(echo "/var/www/"$appUser.$appGroup".app/live/")
echo "WebApplication Working DIR: "$workingDir

consoleDir=$(echo $workingDir"bin/console")
echo "WebApplication Console DIR: "$consoleDir

if [ -f "$consoleDir" ];
  then
        consoleFile="bin/console"
  else
        consoleFile="app/console"
fi
echo "WebApplication Console FILE: "$consoleFile

daemonStatus=$(checkDaemon "$daemonCode")

if [ "$daemonStatus" -eq 1 ];
  then
	echo "Daemon [ $daemonName ] is already running.."
	echo "Nothing else to do.. Bye!!"
	exit 0
fi

#alarmStatusCPUCredits=$(bash /aws.services/ssm/AWS.EC2-SSM.Scripts/scripts.lib/cli/checkAlarmStatus.sh)

#	if [ "$alarmStatusCPUCredits" = "ALARM" ];
#	  then
#		echo "EC2-Instance is low on CPU Credits"
#		echo "Daemon [ $daemonName ] will NOT be enabled."
#		echo "Check Cloudwatch for more information.."
#		exit 0
#	fi

echo "Starting [ $daemonName ] Daemon.."

	if [ ! -f "$workingDir$daemonSTOPFile" ];
	  then
		echo "Stop Daemon File for [ $daemonName ] IS NOT present.."
	  else
		echo "Stop Daemon File for [ $daemonName ] IS present.."
		echo "Removing stopDeamonFile.."
		runuser -l $appUser -c "rm -rf $workingDir$daemonSTOPFile"
	fi

cd $workingDir
php $consoleFile --env=prod $daemonCode $deamonParameters 2>> var/logs/gemv2.gqmcrxe.errors.logs >> var/logs/gemv2.gqmcrxe.output.logs &

	while [ "$daemonStatus" -ne 1 ];
	  do
		echo "Checking Daemon [ $daemonName ] Status.."		
		echo "Daemon [ $daemonName ] Status: NOT Running.."
		echo "Checking Daemon [ $daemonName ] Status again in 5 seconds.."
		sleep 5
		daemonStatus=$(checkDaemon "$daemonCode")
	done

echo "Daemon [ $daemonName ] Status: Running"
exit 0

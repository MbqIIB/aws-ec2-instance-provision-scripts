#!/bin/bash
# ------------------------------------------------------------------
# [Georgios Fisaris]    start.gqm-qc.d:cmd:rx-executor
# ------------------------------------------------------------------

VERSION=0.1.0
SUBJECT=aws.ec2.ssm-startGQM-QC_CMD_RxExecutor

# --- Predefined Values -------------------------------------------

daemonName="GQM-QC:Command:RxExecutor"
daemonCode="gqm-qc.d:cmd:rxe"
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

workingDir=$(echo "/var/www/"$appGroup.$appUser"/live/")
echo "WebApplication Working DIR: "$workingDir

consoleFile=$(echo $workingDir"bin/console")
	if [ ! -f "$consoleFile" ];
	  then
		consoleFile=$(echo $workingDir"app/console")
	fi
echo "WebApplication Console FILE: "$consoleFile

daemonStatus=$(checkDaemon "$daemonCode")

if [ $daemonStatus -eq 0 ];
  then
        echo "Daemon [ $daemonName ] is NOT running.."
        echo "Nothing else to do.. Bye!!"
        exit 0
fi

echo "Stoping [ $daemonName ] Daemon.."
echo "Touching stopDaemonFile .."
runuser -l $appUser -c "touch $workingDir$daemonSTOPFile"
echo "Check IF stopDaemonFile has been created.."

	if [ ! -f "$workingDir$daemonSTOPFile" ];
	  then
		while [ ! -f "$workingDir$daemonSTOPFile" ];
		  do
			echo "Stop Daemon File for [ $daemonName ] IS NOT present.."
			echo "Re-trying to touch StopDaemonFile in 5 seconds.."
			sleep 5
			echo "Trying to touch stopDaemonFile again .."
			runuser -l $appUser -c "touch $workingDir$daemonSTOPFile"
		done
	  else
		echo "Stop Daemon File for [ $daemonName ] IS present.."
	fi

echo "Checking Daemon [ $daemonName ] Status.."

	while [ "$daemonStatus" -ne 0 ];
	  do
		echo "Daemon [ $daemonName ] Status: Running.."
		echo "Checking Daemon [ $daemonName ] Status again in 5 seconds.."
		sleep 5
		daemonStatus=$(checkDaemon "$daemonCode")
	done

echo "Daemon [ $daemonName ] Status: Stoped"
exit 0

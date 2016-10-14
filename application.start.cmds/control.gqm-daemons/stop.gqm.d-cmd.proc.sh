#!/bin/bash
# ------------------------------------------------------------------
# [Georgios Fisaris]    stop.gqm.d:cmd:processor
# ------------------------------------------------------------------

VERSION=0.1.0
SUBJECT=aws.ec2.ssm-stopGQM_CMD_PROC

# --- Locks -------------------------------------------------------
#LOCK_FILE=/tmp/$SUBJECT.lock
#if [ -f "$LOCK_FILE" ]; then
#   echo "Script is already running"
#   exit
#fi

#trap "rm -f $LOCK_FILE" EXIT
#touch $LOCK_FILE

# --- Global Functions --------------------------------------------

checkDaemon () {
  local optDaemonCode="$1"

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

appUser=$(cat /aws.services/.ec2Instance| grep WebApplication | awk '{print $2}')
appGroup=$(cat /aws.services/.ec2Instance| grep EcoSystem | awk '{print $2}')
echo "Application: "$appUser
echo "EcoSystem: "$appGroup

workingDir=$(echo "/var/www/"$appGroup.$appUser"/live/")
echo "Working DIR: "$workingDir

consoleDir=$(echo $workingDir"bin/console")
echo "Console DIR: "$consoleDir

        if [ -f "$consoleDir" ]
          then
                consoleFile="bin/console"
          else
                consoleFile="app/console"
        fi
        echo "Console FILE: "$consoleFile

daemonName="GQM:Command:Processor"
daemonCode="gqm.d:cmd:processor"
daemonSTOPFile=".stop.gqm-cmdprc.service"

daemonStatus=$(checkDaemon "$daemonCode")

if [ $daemonStatus -eq 0 ];
  then
        echo "Daemon [ $daemonName ] is NOT running.."
        echo "Nothing else to do.. Bye!!"
        exit 0
fi

if [ ! -f "$workingDir$daemonSTOPFile" ]
  then
	echo "Stop Daemon File for [ $daemonName ] DOES NOT exist!"
	echo "Touching stopServiceFile .."
	touch $workingDir$daemonSTOPFile
	while [ $daemonStatus -eq 1 ];
	  do
		echo "Daemon [ $daemonName ] Status: Running.."
		echo "Checking again in 5 seconds.."
		sleep 5
		daemonStatus=$(checkDaemon "$daemonCode")
	done
	echo "Daemon [ $daemonName ] Status: Stopped."
  else
	echo "Stop Daemon File for [ $daemonName ] ALREADY exist."
	while [ $daemonStatus -eq 1 ];
          do
                echo "Daemon [ $daemonName ] Status: Running.."
                echo "Checking again in 5 seconds.."
                sleep 5
                daemonStatus=$(checkDaemon "$daemonCode")
        done
        echo "Daemon [ $daemonName ] Status: Stopped."
fi

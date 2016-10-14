#!/bin/bash

echo "Stopping and Disabling All Pre-Existing Services.."

echo "Stop & Disable NGinx Web Server (nginx).."
service=nginx.service

systemctl stop $service
systemctl disable $service

echo "Checking if $service has been  successfully disabled.."
if (( $(ps -ef | grep -v grep | grep $service | wc -l) > 0 ))
	then
		echo "ERROR! $service is still running! Aborting Deployment.."
        	exit 1
	else
		echo "Success! $service is NOT running! Continuing Deployment.."
fi

echo "Stop & Disable Apache Web Server (httpd).."
service=httpd.service

systemctl stop $service
systemctl disable $service

echo "Checking if $service has been  successfully disabled.."
if (( $(ps -ef | grep -v grep | grep $service | wc -l) > 0 ))
	then
		echo "ERROR! $service is still running! Aborting Deployment.."
        	exit 1
	else
		echo "Success! $service is NOT running! Continuing Deployment.."
fi

echo "Stop & Disable PHP-FPM Service (php-fpm).."
service=php-fpm.service

systemctl stop $service
systemctl disable $service

echo "Checking if $service has been  successfully disabled.."
if (( $(ps -ef | grep -v grep | grep $service | wc -l) > 0 ))
	then
		echo "ERROR! $service is still running! Aborting Deployment.."
        	exit 1
	else
		echo "Success! $service is NOT running! Continuing Deployment.."
fi

echo "Stop & Disable mySQL Service (mysql/mysqld/mariadb).."
service=mysql.service

systemctl stop $service
systemctl disable $service

echo "Checking if $service has been  successfully disabled.."
if (( $(ps -ef | grep -v grep | grep $service | wc -l) > 0 ))
	then
		echo "ERROR! $service is still running! Aborting Deployment.."
        	exit 1
	else
		echo "Success! $service is NOT running! Continuing Deployment.."
fi

service=mysqld.service

systemctl stop $service
systemctl disable $service

echo "Checking if $service has been  successfully disabled.."
if (( $(ps -ef | grep -v grep | grep $service | wc -l) > 0 ))
	then
		echo "ERROR! $service is still running! Aborting Deployment.."
        	exit 1		
	else
		echo "Success! $service is NOT running! Continuing Deployment.."
fi

service=mariadb.service

systemctl stop $service
systemctl disable $service

echo "Checking if $service has been  successfully disabled.."
if (( $(ps -ef | grep -v grep | grep $service | wc -l) > 0 ))
	then
		echo "ERROR! $service is still running! Aborting Deployment.."
        	exit 1		
	else
		echo "Success! $service is NOT running! Continuing Deployment.."
fi

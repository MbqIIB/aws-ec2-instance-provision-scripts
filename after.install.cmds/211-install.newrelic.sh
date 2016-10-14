#!/bin/bash

rpm -Uvh http://yum.newrelic.com/pub/newrelic/el5/x86_64/newrelic-repo-5-3.noarch.rpm
yum install -y newrelic-php5

export NR_INSTALL_SILENT=yes
export NR_INSTALL_PATH=/bin:/usr/bin
export NR_INSTALL_PHPLIST=/bin:/usr/bin
export NR_INSTALL_ARCH=x64
export NR_INSTALL_KEY=f86058fc597e6e09b820cf40d6a130b72b2c47c4
export NR_INSTALL_DAEMONPATH=/usr/bin/newrelic-daemon

newrelic-install install

cp /etc/newrelic/newrelic.cfg.template /etc/newrelic/newrelic.cfg
sed -i 's/#port=\"\/tmp\/.newrelic.sock\"/port=11111/g' /etc/newrelic/newrelic.cfg
sed -i 's/#auditlog=\/var\/log\/newrelic\/audit.log/auditlog=\/var\/log\/newrelic\/audit.log/g' /etc/newrelic/newrelic.cfg 
sed -i 's/;newrelic.daemon.port = \"\/tmp\/.newrelic.sock\"/newrelic.daemon.port = 11111/g' /etc/php.d/newrelic.ini 
sed -i 's/;newrelic.daemon.auditlog = \"\/var\/log\/newrelic\/audit.log\"/newrelic.daemon.auditlog = \"\/var\/log\/newrelic\/audit.log\"/g' /etc/php.d/newrelic.ini 



rpm -Uvh https://download.newrelic.com/pub/newrelic/el5/x86_64/newrelic-repo-5-3.noarch.rpm
yum install -y newrelic-sysmond
nrsysmond-config --set license_key=f86058fc597e6e09b820cf40d6a130b72b2c47c4

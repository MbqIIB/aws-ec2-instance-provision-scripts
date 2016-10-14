#!/bin/bash

echo "Removing Pre-Installed mySQL Packages.."
yum -y remove mysql mysql-community-client mysql-community-common  mysql-community-libs

echo "Installing MariaDB Server/Client.."
cat <<EOT >> /etc/yum.repos.d/MariaDB.repo
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.1/centos7-amd64
gpgcheck=0
enabled=1
priority=1
EOT
yum -y install MariaDB-server MariaDB-client

echo "Installing additional basic software packages.. "
yum -y groupinstall 'Development Tools'

echo "Updating all existing packages on the system.."
yum -y update

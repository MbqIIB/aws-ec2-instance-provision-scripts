#!/bin/bash

echo "Enabling EPEL Repositories.."
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -Uvh https://centos7.iuscommunity.org/ius-release.rpm

yum -y install yum-priorities
sed -i "7i priority=10" /etc/yum.repos.d/epel.repo

echo "Updating all existing packages on the system.."
yum -y update

echo "Installing additional basic software packages.. "
yum -y groupinstall 'Development Tools'

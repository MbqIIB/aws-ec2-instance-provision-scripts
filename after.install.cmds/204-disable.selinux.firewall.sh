#!/bin/bash

echo "Disabling SELinux.."

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
setenforce 0

echo "Stopping & Disabling Firewall (firewalld.service).."
systemctl stop firewalld.service
systemctl disable firewalld.service
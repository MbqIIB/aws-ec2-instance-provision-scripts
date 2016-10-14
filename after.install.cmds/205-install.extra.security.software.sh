#!/bin/bash

echo "Installing Fail2Ban.."
yum -y install fail2ban
systemctl enable fail2ban.service
systemctl start fail2ban.service

echo "Installing RootKit Hunter.."
yum -y install rkhunter

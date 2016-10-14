#!/bin/bash

echo "Installing NFS Server/Client.."
yum install -y nfs-utils

cat <<EOT >> /usr/lib/systemd/system/nfs-idmap.service
[Install]
WantedBy=multi-user.target
EOT

cat <<EOT >> /usr/lib/systemd/system/nfs-lock.service
[Install]
WantedBy=nfs.target
EOT

systemctl enable rpcbind
systemctl enable nfs-server
systemctl enable nfs-lock
systemctl enable nfs-idmap
systemctl enable rpc-statd.service
systemctl enable nfs-idmapd.service
systemctl start rpcbind
systemctl start nfs-server
systemctl start nfs-lock
systemctl start nfs-idmap

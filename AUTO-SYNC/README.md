HAProxy Configuration Auto-Synchronization Using rsync and inotify
Overview
This document explains how to automatically synchronize HAProxy configuration files between two HAProxy servers.
The goal is to edit the configuration on only one server (primary) and have the changes automatically validated, synchronized, and applied on the secondary server without manual intervention.
This solution uses:
SSH for secure communication
rsync for file synchronization
inotify to detect configuration changes
HAProxy validation (haproxy -c) to prevent invalid configurations
Graceful reload to avoid downtime

STEP 1: Install required packages (on haproxy1)
yum install -y rsync inotify-tools

STEP 2: SSH password-less login (on haproxy1)
ssh-keygen
ssh-copy-id root@***

STEP 3: Create the auto-sync script
Create file:
vi /usr/local/bin/haproxy-auto-sync.sh

STEP 4: Make script executable
chmod +x /usr/local/bin/haproxy-auto-sync.sh

STEP 5: Auto-run script when config changes (inotify)
Create watcher script:
vi /usr/local/bin/haproxy-watch.sh
chmod +x /usr/local/bin/haproxy-watch.sh

STEP 7: Run watcher as a systemd service
Create service:
vi /etc/systemd/system/haproxy-sync.service

systemctl daemon-reload
systemctl enable haproxy-sync
systemctl start haproxy-sync
systemctl status haproxy-sync
tail -f /var/log/haproxy-sync.log


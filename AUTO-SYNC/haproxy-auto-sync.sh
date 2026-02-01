#!/bin/bash

REMOTE_SERVER="192.168.1.11"
HAPROXY_CFG="/etc/haproxy/haproxy.cfg"
HAPROXY_DIR="/etc/haproxy/"
LOG_FILE="/var/log/haproxy-sync.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}

haproxy -c -f $HAPROXY_CFG
if [ $? -ne 0 ]; then
    log "ERROR: Local HAProxy config validation failed"
    exit 1
fi
log "Local HAProxy config validation successful"

rsync -az --delete $HAPROXY_DIR root@$REMOTE_SERVER:$HAPROXY_DIR
if [ $? -ne 0 ]; then
    log "ERROR: rsync failed"
    exit 1
fi
log "Config synced to remote server"

ssh root@$REMOTE_SERVER "
haproxy -c -f $HAPROXY_CFG &&
systemctl reload haproxy
"

if [ $? -ne 0 ]; then
    log "ERROR: Remote validation or reload failed"
    exit 1
fi
log "Remote HAProxy reloaded successfully"

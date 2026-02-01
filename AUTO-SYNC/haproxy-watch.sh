#!/bin/bash

WATCH_FILE="/etc/haproxy/haproxy.cfg"
SYNC_SCRIPT="/usr/local/bin/haproxy-auto-sync.sh"
inotifywait -m -e close_write $WATCH_FILE | while read file; do
    $SYNC_SCRIPT
done

#!/bin/bash

now=$(date --utc --iso-8601='seconds')

echo "[$now] Couldn't reach peer node." >> /var/log/split-brain.log
echo "[$now] Checking peer node availability..." >> /var/log/split-brain.log

# Insert URL for healthcheck of peer node.
status=$(curl -m 3 -Lso /dev/null -w %{http_code} <peer node address>)

# Think that 2xx or 3xx is healthy.
if [[ $status =~ ^(2|3)..$ ]]; then
    echo "[$now] Peer node is alive." >> /var/log/split-brain.log
    echo "[$now] Killing myself..." >> /var/log/split-brain.log
else
    echo "[$now] Peer node is dead." >> /var/log/split-brain.log
    echo "[$now] Keep myself alive." >> /var/log/split-brain.log
fi

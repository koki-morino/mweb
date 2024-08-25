#!/bin/bash

now=$(date --utc --iso-8601='seconds')

echo "[$now] Split-brain detected." >> /var/log/split-brain.log

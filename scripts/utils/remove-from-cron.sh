#!/usr/bin/env bash

# @arg: Cronjob to remove from the crontab,
#       specifically a pattern match to search and delete
crontab -l | grep -v $1 | crontab -

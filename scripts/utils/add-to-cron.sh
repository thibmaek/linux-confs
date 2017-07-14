#!/usr/bin/env bash

# @arg: Cronjob to add to the crontab
(crontab -l 2>/dev/null; echo "$1") | crontab -

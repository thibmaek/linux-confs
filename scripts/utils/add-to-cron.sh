#!/usr/bin/env bash

# ▲ Adds a new cronjob to the user's crontab.

# @arg: Cronjob to add to the crontab
(crontab -l 2>/dev/null; echo "$1") | crontab -

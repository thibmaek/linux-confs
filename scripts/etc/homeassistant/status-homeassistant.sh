#!/usr/bin/env bash

# $1 can be used to pass a param like `-l` to systemctl
sudo systemctl status home-assistant@homeassistant.service "$1"

#! /usr/bin/env bash
HASS_CONFIG_PATH=/home/homeassistant/.homeassistant/

/srv/homeassistant/bin/hass -c $HASS_CONFIG_PATH --script check_config

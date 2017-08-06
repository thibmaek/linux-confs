# shellcheck disable=SC2148,SC1091

# Do not execute this script directly, since it will quit after changing user
# Instead; copy & paste from this script as a reference

sudo systemctl stop home-assistant@homeassistant.service

sudo su -s /bin/bash homeassistant
source /srv/homeassistant/bin/activate
pip3 install --upgrade homeassistant
deactivate

exit

sudo systemctl start home-assistant@homeassistant.service

#!/usr/bin/env bash

# ▲ Builds and install the Datadog agent from source.

# @private: The repository url to fetch the datadog-agent source from
_DATADOG_SRC_URL=https://raw.githubusercontent.com/DataDog/dd-agent/master/packaging/datadog-agent/source/setup_agent.sh

# Required for apt, cp and systemd
if [[ "$EUID" -ne 0 ]]; then
  echo "[WARN]: Please run this script as root"
  exit
fi

if [[ -z $1 ]]; then
  echo "[ERROR]: No API key found!"
  echo "Retry and provide an API key to continue installation:"
  echo "e.g: ./build-install-datadog-agent-src.sh hd53hjkdzk383nndh366hdnj1mnhda55"
  exit
fi

# Install required sysstat for providing system statistics
apt install sysstat

# Download and pipe the datadog install script
DD_API_KEY=$1 sh -c "$(curl -L $_DATADOG_SRC_URL)"

# Copy the systemd unit to the systemd folder
cp ../../etc/systemd/system/datadog-agent.service /etc/systemd/system/
systemctl daemon-reload && systemctl enable datadog-agent
systemctl start datadog-agent

#!/usr/bin/env bash
set -e

#  TODO: url
# ▲ Installs the Datadog agent: https://...

# Check if sudo
if [[ "$EUID" -ne 0 ]]; then
  echo ""
  echo "[WARN]: Please run this script as root"
  echo "  Required permissions: [apt, sh, cp, systemd]"
  echo ""
  exit
fi

function build_from_source() {
  echo "Installing sysstat to collect system metrics"
  apt install sysstat

  echo "Installing datadog-agent from official shell script"
  DD_API_KEY="$1" sh -c \
    "$(curl -L https://raw.githubusercontent.com/DataDog/dd-agent/master/packaging/datadog-agent/source/setup_agent.sh)"
}

function start_service() {
  sed -e "s/<user>/$USER/" template.service > datadog-agent.service && \
    cp datadog-agent.service /etc/systemd/system/
    systemctl daemon-reload && \
    systemctl enable datadog-agent && \
    systemctl start datadog-agent
}

function main() {
  if [ -z "$1" ]; then
    echo "[ERROR]: No API key found!"
    echo "Retry and provide an API key to continue installation:"
    echo "e.g: ./install.sh hd53hjkdzk383nndh366hdnj1mnhda55"
    exit 1
  fi

  apt update

  build_from_source "$@" && \
    start_service && \
    echo "" && \
    echo "Datadog agent was successfully installed and automatically started."
}

"${@:-main}"

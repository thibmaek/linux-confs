#! /usr/bin/env bash

# ▲ Installs Docker CE for 64-bit Linux Ubuntu/Debian

# @protected: Docker GPG key
_DOCKER_GPG_KEY="9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88"

# @public: Repository architecture to add. Defaults to 64-bit
ARCH=amd64

if [[ "$EUID" -ne 0 ]]; then
  echo "[WARN]: Please run this script as root"
  exit
fi

# @arg: Different architecture to set. Checks for armhf
if [[ $1 = 'armhf' ]]; then
  ARCH=armhf
fi

# Install linux-image-extra packages for aufs storage driver access
apt update && apt install "linux-image-extra-$(uname -r)" linux-image-extra-virtual

# If not installed, install safe transport packages for apt
apt install apt-transport-https ca-certificates curl software-properties-common

# Add the Docker GPG key & verify the key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88 | grep -q "$_DOCKER_GPG_KEY" && echo "Docker GPG key verified"

# Add the Docker stable repository and update apt repository list
add-apt-repository \
   "deb [arch=$ARCH] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable" && apt update

# Finally, install Docker CE from its repository
apt install docker-ce

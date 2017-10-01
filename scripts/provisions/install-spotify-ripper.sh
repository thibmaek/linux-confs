#!/usr/bin/env bash

# ▲ Installs the (mirrored) spotify-ripper-morgaroth module
#   from pip and installs some basic encoders

# @private: Current dir for changing directory
_CURRDIR=$PWD

# @private: Home folder for reading settings for spotify-ripper
_SR_HOME="$HOME/.spotify-ripper"

# @public: Architecture build to download for libspotify
ARCHBUILD=libspotify-12.1.51-Linux-x86_64

# Exit early if not sudo
if [[ "$EUID" -ne 0 ]]; then
  echo "[WARN]: Please run this script as root"
  exit 1
fi

# -k <spotify_appkey.key>: Developer keyfile for authenticating with libspotify
KEYFILE=
while getopts "h?k:" opt; do
  case $opt in
    k) KEYFILE=$OPTARG
      ;;
    h)
      echo "Syntax: ./install-spotify-ripper.sh <armhf>" >&2
      exit 1
      ;;
  esac
done

# @arg: Different architecture to set. Checks for armhf
if [[ $1 = 'armhf' ]]; then
  ARCHBUILD=libspotify-12.1.103-Linux-armv6-bcm2708hardfp
fi

# Install lame (mp3 encoder), build-essential (make) and libffi-dev (dev headers)
apt install lame build-essential libffi-dev

# Download the build of libspotify
wget "https://developer.spotify.com/download/libspotify/$ARCHBUILD-release.tar.gz"
tar xvf "$ARCHBUILD-release.tar.gz"
cd "$ARCHBUILD-release" || exit

# Build libspotify to /usr/local
make install prefix=/usr/local && cd "$_CURRDIR" || exit

# Download, build and install spotify-ripper from pip
pip install spotify-ripper-morgaroth

# If there is a keyfile given, set it up
if [[ -z $KEYFILE && $KEYFILE != '' ]]; then
  cp $KEYFILE $_SR_HOME
else
  echo "Download an application key file spotify_appkey.key from https://devaccount.spotify.com/my-account/keys/ (requires a Spotify Premium Account) and move the file to the ~/.spotify-ripper directory (or use the -k | --key option)."
  exit 1
fi

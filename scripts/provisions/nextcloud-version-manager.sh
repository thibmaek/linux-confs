#!/usr/bin/env bash
# -v <version>: Specific version to upgrade/downgrade. Default: latest
# -p: Keep the temp working directory @ $_TMP_DIR.

_NCROOT=/var/www/nextcloud
_TMPDIR=$HOME/.nextcloud
VERSION=latest
URL=https://download.nextcloud.com/server/releases/$VERSION.zip
PERSIST=false

if [[ ! -d $_NCROOT ]]; then
  echo "Current nextcloud installation not found at $_NCROOT! Exiting…"
  exit 1;
fi

occ="$_NCROOT/occ" && echo "occ binary is now: $occ"
_SAFEPATH=$HOME/nextcloud-$(occ config:system:get version)

while getopts "h?:v:p:" opt; do
  case $opt in
    v) VERSION=nextcloud-$OPTARG ;;
    p) PERSIST=true ;;
    h|?)
      echo "Syntax: ./nextcloud-version-manager.sh [-v <version>] [-p]" >&2
      exit 1
      ;;
  esac
done

# Create a temp directory to move files around and download
if [[ ! -d $_TMPDIR ]]; then
  mkdir -p "$_TMPDIR"
fi;

# Download the latest/given version
wget -P "$_TMPDIR" "$URL"

# Unzip/untar the download
if find "$_TMPDIR" -type f -name '*.zip'; then
  find "$_TMPDIR" -type f -name '*.zip' -print0 | xargs --null /usr/bin/unzip -d "$_TMPDIR/"
else
  find "$_TMPDIR" -type f -name '*.bz2' -print0 | xargs --null /bin/tar xjf
fi

# Put the current installation in maintenance mode
# and stop apache2 from running
sudo -u www-data php $occ maintenance:mode --onn
sudo systemctl stop apache2

# Move the current installation somewhere safe
sudo mv "$_NCROOT" "$_SAFEPATH"

# Copy new version directory to webroot and copy old config back
sudo rsync -Aax "$_TMPDIR/nextcloud" /var/www/
sudo rsync -Aax "$_SAFEPATH/config" "$_NCROOT"

# Own the directory to apache user again & restart apache service
sudo chown -R www-data:www-data "$_NCROOT"
sudo systemctl start apache2

# Start the upgrade process and exit maintenance mode once finished
$occ upgrade && $occ maintenance:mode --off

if [[ $PERSIST != true ]]; then
  rm -rf "$_TMPDIR"
fi

# Make sure we don't export occ to the path any longer
unset occ;
echo "Unset occ binary, is now value: $(occ)"

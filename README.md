# 🐧 Linux Confs — Collective repository for Linux OSes

This repository is aimed at collecting some handy/useful/lengthy/hard scripts and configurations for Linux OSes.
It's the first thing I clone to every new Raspberry Pi or Linux box and then it's basically just a pick & mix of scripts and configurations to install. No install.sh or installation method, only manual cp allowed 🙌🏻

These script are grafted on Debian Stretch but might also work for Ubuntu.

## What's in the box

Lots of stuff!

- ~Nearly~ cross platform dotfiles for a bash env
- A copy of the `/etc` folder with:
  - A default nginx reverse proxy conf
  - Systemd services for mongod, datadog, glances, certbot…
- Scripts of various natures:
  - Provisions for LetsEncrypt, Dynamic DNS, Nginx + OpenSSL, Node for armhf archs…
  - Utilities for the shell like adding an alias, adding/removing a cronjob
  - Loose onetime scripts to generate OpenSSL certs locally, scan the local subnet, upgrade all pip modules

## Installation

It's a pick & mix! You can manually copy over files with cp, rsync, drag and drop or choose to copy over the whole folder like `cp -R etc/**/* /etc/`. This is in no way a provisioning tool, then you're better off with Puppet or Ansible. Running headless or automated not recommended since these scripts might require interaction.

## Testing?

Runs test.sh for shellcheck'ing the files on Travis CI or locally in dev with `./test.sh`

#! /usr/bin/env bash

# ▲ Updates pip and any outdated package.

pip install --upgrade pip
pip list --outdated | cut -d' ' -f1 | xargs pip install --upgrade
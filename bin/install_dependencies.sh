#!/bin/bash

if [ -x "$(command -v apt)" ]; then
  echo "Installing the necessary dependencies"

  sudo apt update &&
  # fonts-liberation includes Liberation Sans, which is used in this repo, and fonts-noto is the fallback for wider language support
  sudo apt install -y wget fonts-liberation fonts-noto pandoc weasyprint
else
  echo "Only Debian-based distros are supported for installing weasyprint. Please install this package manually."
fi

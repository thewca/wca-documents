#!/bin/bash

if ! [ -x "$(command -v pandoc)" ]; then
  echo "Pandoc not found. Installing..."
  wget https://github.com/jgm/pandoc/releases/download/2.2.2.1/pandoc-2.2.2.1-1-amd64.deb -O /tmp/pandoc.deb
  dpkg -i /tmp/pandoc.deb
else
  echo "Pandoc already installed."
fi

if ! [ -x "$(command -v weasyprint)" ]; then
  if [ -x "$(command -v apt)" ]; then
    echo -e "\nweasyprint not found. Installing..."
    apt install -y weasyprint
  else
    echo -e "\nOnly Debian-based distros are supported for installing weasyprint. Please install this package manually."
  fi
else
  echo -e "\nweasyprint already installed."
fi

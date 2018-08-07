#!/bin/bash

if ! [ -x "$(command -v pandoc)" ]; then
  echo "Pandoc not found. Installing..."
  wget https://github.com/jgm/pandoc/releases/download/2.2.2.1/pandoc-2.2.2.1-1-amd64.deb -O /tmp/pandoc.deb
  sudo dpkg -i /tmp/pandoc.deb
else
  echo "Pandoc already installed."
fi

if ! [ -x "$(command -v wkhtmltopdf)" ]; then
  echo "wkhtmltopdf not found. Installing..."
  # Copied from https://github.com/thewca/worldcubeassociation.org/blob/5698831f9addb26091641c80beadfa7c902bcb18/chef/site-cookbooks/wca/recipes/regulations.rb#L17-L18
  wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz -O /tmp/wkhtml.tar.xz
  sudo tar -xf /tmp/wkhtml.tar.xz --strip-components=1 -C /usr/local
else
  echo "wkhtmltopdf already installed."
fi

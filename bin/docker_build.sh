#!/bin/bash

rm -rf build

if [ "$1" = "--rebuild" ] || [ -z "$(docker images | grep wca-pdf-builder)" ]; then
  docker build --tag wca-pdf-builder .
fi

docker run --rm --name wca-pdf-builder \
  -v ./build:/home/app/wca-documents/build:rw \
  -v .:/home/app/wca-documents:ro \
  wca-pdf-builder
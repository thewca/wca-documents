#!/bin/bash

# Get the directory to build argument
if [ -n "$1" ] && [ "$1" != "--rebuild" ]; then
  directory_to_build=$1
elif [ -n "$2" ] && [ "$2" != "--rebuild" ]; then
  directory_to_build=$2
fi

# Build the Docker image, if the --rebuild flag was used or if an image hasn't been built yet

if [ -z "$(docker images | grep wca-pdf-builder)" ]; then
  image_exists=true
  docker rmi wca-pdf-builder
fi

if [ "$1" = "--rebuild" ] || [ "$2" = "--rebuild" ] || [ "$image_exists" = true ]; then
  docker build --tag wca-pdf-builder --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) . || exit
fi

# If DIRECTORY_TO_BUILD is empty, all directories will be built
docker run --rm --name wca-pdf-builder \
  -e DIRECTORY_TO_BUILD=$directory_to_build \
  -v ./build:/home/app/wca-documents/build:rw \
  -v .:/home/app/wca-documents:ro \
  wca-pdf-builder
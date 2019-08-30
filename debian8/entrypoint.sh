#!/bin/bash

if [ -z "$1" ]; then
  echo "CPAN Module name missing."
  exit 0
fi

cpanm install $1

#export DEB_BUILD_OPTIONS=nocheck

dh-make-perl \
  --build \
  --recursive \
  --cpan \
  $1
#!/bin/bash

if [ -z "$1" ]; then
  echo "CPAN Module name missing."
  exit 0
fi

cpanm $1

export DEB_BUILD_OPTIONS=nocheck

dh-make-perl \
  --build \
  --cpan \
  $1
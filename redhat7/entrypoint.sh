#!/bin/bash

if [ -z "$1" ]; then
  echo "CPAN Module name missing."
  exit 0
fi

cpanm $1

cpantorpm \
  --packager centos \
  --rpmbuild /opt/build \
  $1
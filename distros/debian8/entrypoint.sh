#!/bin/bash

if [ -z "$2" ]; then
  echo "Installing latest"
  fqn=$(cpanm --info $1)
else
  echo "Installing Version $2"
  fqn=$(cpanm --info $1@$2)
fi

tarball=$(echo $fqn | sed 's/.*\///')
package_folder=$(echo $tarball | sed 's/\(.*\)\.tar\.gz/\1/')

rm -rf /opt/build/*

cpanm $fqn --installdeps

find / -name $tarball | xargs cp -t /opt/build/

cd /opt/build/ && tar -pzxf $tarball

export DEB_BUILD_OPTIONS=nocheck

dh-make-perl --build /opt/build/$package_folder

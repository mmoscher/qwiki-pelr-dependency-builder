#!/bin/bash

if [ -z "$2" ]; then
  echo "Installing latest"
  fqn=$(cpanm --info $1)
else
  echo "Installing Version $2"
  fqn=$(cpanm --info $1@$2)
fi

tarball=$(echo $fqn | sed 's/.*\///')

rm -rf /opt/build/*

mkdir -p /opt/build/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}

cp /opt/rpmmacros /root/.rpmmacros

cpanm $fqn --installdeps

find / -name $tarball | xargs cp -t /opt/build/SOURCES/

cpanspec --follow /opt/build/SOURCES/$tarball

sed -i '/%files/ a /usr/*' /opt/build/*.spec

mv /opt/build/*.spec SPECS

rpmbuild -ba --nodeps /opt/build/SPECS/*.spec

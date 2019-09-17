#!/bin/bash

cpanm $1

cp /opt/rpmmacros /root/.rpmmacros

rm -rf /opt/build/*

mkdir -p /opt/build/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}

cpanspec --follow $1

sed -i '/%files/ a %define _unpackaged_files_terminate_build 0' /opt/build/*.spec

mv /opt/build/*.spec SPECS

mv /opt/build/*.tar.gz SOURCES

rpmbuild -ba --nodeps /opt/build/SPECS/*.spec

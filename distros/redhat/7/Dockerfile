FROM centos:7

USER root

RUN yum -y update; yum clean all
RUN yum -y install epel-release
RUN yum -y install \
  wget \
  centos-packager \
  perl-core \
  perl-CPAN \
  make \
  rpm-build \
  cpanspec

RUN rpm -Uvh https://yum.postgresql.org/11/redhat/rhel-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
RUN yum -y install cpanm \
  gcc \
  perl \
  perl-App-cpanminus \
  perl-Config-Tiny \
  postgresql11 \
  postgresql11-server \
  postgresql11-client \
  postgresql11-debuginfo \
  postgresql11-libs \
  postgresql11-devel \
  postgresql11-contrib

RUN ln -s /usr/pgsql-11/bin/pg_config /usr/bin/pg_config
WORKDIR /opt/build

ADD entrypoint.sh /opt/entrypoint.sh
ADD rpmmacros /opt/rpmmacros

ENTRYPOINT ["/opt/entrypoint.sh"]

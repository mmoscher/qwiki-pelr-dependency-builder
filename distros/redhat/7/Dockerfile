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

RUN  yum -y install cpanm gcc perl perl-App-cpanminus perl-Config-Tiny postgresql-libs postgresql-devel

WORKDIR /opt/build

ADD entrypoint.sh /opt/entrypoint.sh
ADD rpmmacros /opt/rpmmacros

ENTRYPOINT ["/opt/entrypoint.sh"]

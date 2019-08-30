FROM centos:7

USER root

RUN yum -y update; yum clean all
RUN yum -y install epel-release
RUN yum -y install \
  wget \
  strace \
  centos-packager \
  perl-core \
  perl-CPAN \
  make \
  rpm-build \
  rpmdevtools

RUN  yum -y install cpanm gcc perl perl-App-cpanminus perl-Config-Tiny
RUN cpanm install cpantorpm; rm -rf root/.cpanm;

WORKDIR /opt/build

ADD entrypoint.sh entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
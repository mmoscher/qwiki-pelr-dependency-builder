FROM debian:8

USER root

RUN apt-get update
RUN apt-get install -y dh-make-perl
RUN curl -L http://cpanmin.us | perl - --self-upgrade

RUN git config --global user.email "you@example.com"; git config --global user.name "Your Name"

WORKDIR /opt/build

ADD entrypoint.sh /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]
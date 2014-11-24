FROM google/debian:wheezy

MAINTAINER Günter Zöchbauer <guenter@gzoechbauer.com>

WORKDIR /app

ENV DART_SDK /usr/lib/dart
ENV PATH $DART_SDK/bin:$PATH
ENV DART_VERSION 1.8.0-dev.4.5
RUN apt-get -q update && apt-get install --no-install-recommends -y -q curl git ca-certificates apt-transport-https apt-utils #\
#  net-tools sudo procps telnet apt-show-versions
RUN curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_unstable.list > /etc/apt/sources.list.d/dart_unstable.list && \
  apt-get update && \
  apt-cache madison dart && \
  apt-get install dart=$DART_VERSION-1 && \
  rm -rf /var/lib/apt/lists/* && \
  echo dart --version

ADD dart_run.sh /dart_runtime/

RUN chmod 755 /dart_runtime/dart_run.sh && \
  chown root:root /dart_runtime/dart_run.sh

## Expose ports for debugger (5858), application traffic (8080)
## and the observatory (8181)
EXPOSE 8080 8181 5858

CMD []
ENTRYPOINT ["/dart_runtime/dart_run.sh"]

ONBUILD ADD pubspec.yaml /app/
ONBUILD ADD pubspec.lock /app/

############################################################
### Add to Dockerfile that uses this image as base image

## local path dependencies
#ADD some_pkg /bwu_pkg
##

#RUN pub get
#ADD . /app/
#RUN pub get --offline
############################################################



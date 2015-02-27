FROM google/debian:wheezy

MAINTAINER Günter Zöchbauer <guenter@gzoechbauer.com>

ENV DEBIAN_FRONTEND noninteractive
ENV DART_SDK /usr/lib/dart
ENV PATH $DART_SDK/bin:$PATH
ENV DART_VERSION 1.9.0-dev.8.0
#1.8.0-dev.4.6
# Note to self: run it without any version to get the most recent Dart version
# or add RUN apt-get-versions dart (works only when Dart installation succeeded)
# or apt-cache policy dart
# beware that in one run command the package information is downloaded and 
# purged

RUN \
  apt-get -q update && \
  DEBIAN_FRONTEND=noninteractive && \
  apt-get install --no-install-recommends -y -q \
    apt-transport-https \
    apt-utils \
    apt-show-versions \
    ca-certificates \
    curl \
    git 

#  net-tools sudo procps telnet 
RUN \
  curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_unstable.list > \
    /etc/apt/sources.list.d/dart_unstable.list && \
  apt-get update && \
  apt-cache policy dart && \
  apt-get install dart=$DART_VERSION-1 && \
  rm -rf /var/lib/apt/lists/* && \
  ln -s /usr/lib/dart /usr/lib/dart/bin/dart-sdk
  
  # see https://github.com/angular/angular.dart/issues/1270#issuecomment-64967674

ADD dart_run.sh /dart_runtime/

RUN \
  chmod 755 /dart_runtime/dart_run.sh && \
  chown root:root /dart_runtime/dart_run.sh

WORKDIR /app

#ONBUILD ADD pubspec.* /app/

## Expose ports for debugger (5858), application traffic (8080)
## and the observatory (8181)
EXPOSE 8080 8181 5858

RUN \
  echo "alias la='ls -lahFLH --color --group-directories-first'" >> /root/.bashrc && \
  echo "PROMPT_COMMAND='PS1=\"\[\e]0;\W\007\e[38;5;69m\]\u@\h \[\e[38;5;36m\]\w\n\[\e[38;5;222m\]\[\e[38;5;47m\] $$\[\e[0m\] \"'" >> /root/.bashrc

CMD []
ENTRYPOINT ["/dart_runtime/dart_run.sh"]

############################################################
### Add the following lines to the Dockerfile that uses this image as base image

## local path dependencies
# ADD some_pkg /bwu_pkg # for each local dependency
##

#RUN pub get
#ADD . /app/
#RUN pub get --offline
############################################################


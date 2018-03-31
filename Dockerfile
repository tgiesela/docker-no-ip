#FROM resin/rpi-raspbian:jessie
FROM phusion/baseimage:0.9.19

MAINTAINER Tonny Gieselaar <tonny@devosverzuimbeheer.nl>

ENV DEBIAN_FRONTEND noninteractive

# Speed up APT
RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup \
  && echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache

VOLUME ["/config"]

RUN set -x \
  && apt-get update \
  && apt-get --no-install-recommends install -y expect \
  && apt-get install -y build-essential \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD https://www.noip.com/client/linux/noip-duc-linux.tar.gz /files/

WORKDIR files
RUN set -x \
  && chmod a+rwX /files \
  && tar -x -f /files/noip-duc-linux.tar.gz \
  && cd noip* && make && mv noip2 /files \
  && rm -rf /files/noip-2.1.9-1 /files/noip-duc-linux.tar.gz

COPY ["noip.conf", "create_config.exp", "noip.sh", "/files/"]
RUN apt-get remove -y build-essential 
RUN chmod +x /files/noip.sh

CMD /files/noip.sh

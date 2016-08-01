FROM armv7/armhf-ubuntu:16.04
MAINTAINER kayrus

# Let the container know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# Generate the locale
RUN locale-gen en_US.UTF-8

# Update ubuntu
RUN apt-get -q update
RUN apt-get dist-upgrade -qy && apt-get install -y wget

# Add emby repo
RUN wget -qO - http://download.opensuse.org/repositories/home:emby/xUbuntu_16.04/Release.key | apt-key add -
RUN echo 'deb http://download.opensuse.org/repositories/home:/emby/xUbuntu_16.04/ /' > /etc/apt/sources.list.d/emby.list
RUN apt-get -q update

# Install emby server. You can set specific version here
RUN apt-get install -y ffmpeg emby-server

RUN apt-get clean -y && rm -rf /var/lib/apt/lists/* /var/cache/* /var/tmp/* /tmp/mono*

VOLUME ["/var/lib/emby-server","/media"]

# Default MB3 HTTP/tcp server port
EXPOSE 8096/tcp
# Default MB3 HTTPS/tcp server port
EXPOSE 8920/tcp
# UDP server port
EXPOSE 7359/udp
# ssdp port for UPnP / DLNA discovery
EXPOSE 1900/udp

ENTRYPOINT ["/usr/bin/emby-server","start"]

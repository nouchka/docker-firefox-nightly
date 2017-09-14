FROM debian:stable
MAINTAINER Jean-Avit Promis "docker@katagena.com"
LABEL org.label-schema.vcs-url="https://github.com/nouchka/docker-firefox-nightly"
LABEL version="latest"

ENV DEBIAN_FRONTEND=noninteractive

ARG FIREFOX_FILE_MD5SUM=8e045c093cb1f9ad503101c203443deb0506d051bf856f3cfab16244a0a27ac0
ARG FIREFOX_URL=https://archive.mozilla.org/pub/firefox/nightly/latest-mozilla-central-l10n/firefox-57.0a1.fr.linux-x86_64.tar.bz2

RUN apt-get update --fix-missing && \
	apt-get update && \
	apt-get install -y -q curl bzip2 libfreetype6 libfontconfig1 libxrender1 libasound-dev libdbus-glib-1-dev libgtk-3-0 libxt6 dbus-x11 libxext-dev libxrender-dev libxtst-dev

RUN curl -o /tmp/firefox.tar.bz2 $FIREFOX_URL && \
	echo "${FIREFOX_FILE_MD5SUM}  /tmp/firefox.tar.bz2"| sha256sum -c - && \
	mkdir -p /usr/local/share/ && \
	tar xvjf /tmp/firefox.tar.bz2 -C /usr/local/share/

RUN export uid=1000 gid=1000 && \
	mkdir -p /home/developer && \
	echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
	echo "developer:x:${uid}:" >> /etc/group && \
	chown ${uid}:${gid} -R /home/developer

USER developer
ENV HOME /home/developer

ENTRYPOINT /usr/local/share/firefox/firefox

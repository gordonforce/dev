# Use this version of the dev image when debuging volume mount points and other
# guest parameters as it has no external configuration dependencies: no volume
# mount points nor build arguments. Add such items in a child Dockerfile
# docker-compose.yaml files.
#
# Based on a recent stable alpine OS build with the sudoer stable jdk installed.
# Open JDK is the legal version for Docker. Also contains all of the
# development tools I expect to find at a minimum. I need to add these as meta
# tags.
FROM openjdk:latest

MAINTAINER Gordon Force Jr <gordonff@gmail>

# Set terminal sessions look nice in a host OS console.
ENV TERM xterm-256color

# Enables apt headless operation without bitching
ENV DEBIAN_FRONTEND	noninteractive

#
# Added sudoer inorder to mount CIFS volumes. Child containers should decide if
# a user has sudoer access by adding them to the  sudoer group
#
RUN apt-get update -qq \
    && apt-get install -yqq --no-install-recommends \
        apt-utils \
        avahi-daemon \
        avahi-utils \
        bridge-utils \
        build-essential \
        debconf-utils \
        file \
        glogg \
        less \
        libnss-mdns \
        man-db \
        net-tools \
        openssh-server \
        p7zip-full \
        python \
        python3 \
        rsync \
        sudo \
        tree \
        tzdata \
        vim-gtk \
        vim \
    && rm -rf /var/lib/apt/lists/* \
    && chmod a+rwx /etc/sudoers \
    && rm -rf /etc/sudoers

ENV SDKMAN_DIR /usr/local/sdkman

# The SDKMAN installation should be on its own line so adding or removing a
# utility using apt will not cause a fullreinstall of SDKMAN and its managed
# applications.
#
# RUN  export SDKMAN_DIR="/usr/local/sdkman" && curl -s get.sdkman.io | bash
RUN  bash -c "export SDKMAN_DIR='/usr/local/sdkman' && curl -s get.sdkman.io | bash"

WORKDIR $SDKMAN_DIR

COPY config etc/config

RUN bash -c "source /usr/local/sdkman/bin/sdkman-init.sh \
 && sdk install scala \
 && sdk install sbt \
 && sdk install maven \
 && sdk install ant \
 && sdk install activator \
 && sdk flush candidates \
 && sdk flush archives \
 && sdk flush temp"

COPY docker-entrypoint.sh docker-entrypoint.sh

COPY sudoers /etc/sudoers

RUN chmod -R 700 /etc/sudoers

ENTRYPOINT /bin/bash -c "/bin/bash"


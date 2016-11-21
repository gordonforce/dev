#
# Use this version of the dev image when debuging volume mount points and other guest parameters as it has no
# external configuration dependencies: no volume mount points nor build arguments. Add such items in a child Dockerfile
# docker-compose.yaml files.
#
# Based on a recent stable alpine OS build with the sudoer stable jdk installed. Open JDK is the legal version for
# Docker. Also contains all of the development tools I expect to find at a minimum. I need to add these as meta tags.
#
FROM gordonff/dev:latest

MAINTAINER Gordon Force Jr <gordonff@gmail>

ARG TIMEZONE="US/Pacific"
ARG LOGIN="user"

VOLUME /home/$LOGIN

# TODO: Add links to articles about the useradd and usermod commands
# And that POS siicky bit
RUN echo $TIMEZONE > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -d /home/$LOGIN -s /bin/bash $LOGIN \
		&& usermod -a -G staff $LOGIN \
		&& chmod -R 5755 /usr/local/sdkman

USER $LOGIN

WORKDIR /home/$LOGIN


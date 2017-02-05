# Based on a recent stable ubuntu OS build with the sudoer access and a stable
# recen t jdk installed. Open JDK is the legal version for Docker. Also
# contains all of the # development tools I expect to find at a minimum.
FROM ubuntu:latest

LABEL maintainer "gordonff@gmail"

SHELL ["/bin/bash","-c"]

ARG LOGIN=user

# Enables apt headless operation without bitching
# Set terminal sessions look nice in a host OS console.
# do not set it earlier unless you want to see all of the those color
# ANSI escape sequences pass by during the build.
ENV DEBIAN_FRONTEND=noninteractive \
	TERM=xterm-256color \
	SDKMAN_DIR=/usr/local/sdkman

# Added sudoer inorder to mount CIFS volumes. Child containers should decide if
# a user has sudoer access by adding them to the sudoer group
RUN apt-get update -qq \
    && apt-get install -yqq --no-install-recommends \
        apt-utils \
        bridge-utils \
        build-essential \
        curl \
        debconf-utils \
        dnsutils \
        file \
        git \
        glogg \
        htop \
        less \
        libnss-mdns \
        lsb-release \
        man-db \
        meld \
        net-tools \
        nmap \
        openjdk-8-jdk \
        openssh-client \
        p7zip-full \
        python \
        python3 \
        python3-apt \
				python3-pip \
        rsync \
        sudo \
        subversion \
        tree \
        tzdata \
        unzip \
        vim \
        vim-gtk \
        zip \
  && apt-get dist-upgrade -yqq \
  && chmod a+rwx /etc/sudoers \
  && rm -rf /etc/sudoers

COPY sudoers /etc/sudoers

# the chmod command locks down the sudoers file so the sudo commmand will work.
# membership in the staff allows one to execute sdkman installed commands
# membership in the sudo allows one to execute commands as root
# the curl command is an example of combining operations from different logical
#   separations or boundearies into one RUN command to reduce the number of
#   layers in the final image
RUN chmod -R 0755 /etc/sudoers \
	&& useradd -G sudo,staff -s /bin/bash -m $LOGIN \
	&& curl -s get.sdkman.io | /bin/bash

# If one sets the sdkman install directory as the "work" directory before
# installing sdkman, the sdkman installer thinks sdkman has installed
# already as the WORKDIR directive creates the declared directory if it does
# not exist; hence, it will not install sdkman at all. Keep this declaration a
# line below the installation of sdkman to avoid this situation.
WORKDIR ${SDKMAN_DIR}

COPY config ${SDKMAN_DIR}/etc/config

# Add volitale settings towards the end of this file to shorten rebuild time.
# Reduce layers at the end of the development cycle to shorten redbuild time
#   over the entire project lifecycle

# The call to chmod allows members of the staff group to execute sdkman
# scripts. For some reason, there was no group execute access by default
RUN source /usr/local/sdkman/bin/sdkman-init.sh \
	&& sdk install scala \
	&& sdk install sbt \
	&& sdk install maven \
	&& sdk flush archives \
	&& chmod -R g+rxs-w ${SDKMAN_DIR} \
	&& chmod -R g+rwxs ${SDKMAN_DIR}/var

USER $LOGIN

VOLUME /data /src /dest /home/$LOGIN

WORKDIR /home/$LOGIN

CMD /bin/bash

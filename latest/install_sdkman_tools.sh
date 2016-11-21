#!/usr/bin/env bash

# Easier to read when this script is outside of the Dockerfile.

export SDKMAN_DIR=/usr/local/sdkman

cd ${SDKMAN_DIR}

source ./bin/sdkman-init.sh \
 && sdk install scala \
 && sdk install sbt \
 && sdk install maven \
 && sdk install ant \
 && sdk install activator \
 && sdk flush candidates \
 && sdk flush archives \
 && sdk flush temp

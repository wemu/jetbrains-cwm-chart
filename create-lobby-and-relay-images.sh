#!/bin/bash

BUILD_DIR=${PWD}/build
echo "creating Lobby and Relay Server Docker Images in ${BUILD_DIR}"

mkdir -p ${BUILD_DIR}/lobby
mkdir -p ${BUILD_DIR}/relay


LOBBY_SERVER_FILE=lobby-server-linux-x64.1400.tar.gz
RELAY_SERVER_FILE=ws-relayd-linux-x64.1068.tar.gz

LOBBY_VERSION=1400
RELAY_VERSION=1068

#
# https://www.jetbrains.com/help/cwm/code-with-me-administration-guide.html
#
if [ -f "${BUILD_DIR}/${LOBBY_SERVER_FILE}" ]; then
    echo "Lobby Server file exists, will continue..."
else
    echo "Lobby Server file missing."
    echo "Please download it from https://surveys.jetbrains.com/s3/code-with-me-server"
    echo "and save it under: ${BUILD_DIR}/${LOBBY_SERVER_FILE}"
    exit 4
fi

if [ -f "${BUILD_DIR}/${RELAY_SERVER_FILE}" ]; then
    echo "Relay Server file exists, will continue..."
else
    echo "Relay Server file missing."
    echo "Please download it from https://surveys.jetbrains.com/s3/code-with-me-server"
    echo "and save it under: ${BUILD_DIR}/${RELAY_SERVER_FILE}"
    exit 5
fi

echo "extracting lobby tar file..."
tar -C ${BUILD_DIR}/lobby -xf ${BUILD_DIR}/${LOBBY_SERVER_FILE}

echo "extracting relay tar file..."
tar -C ${BUILD_DIR}/relay -xf ${BUILD_DIR}/${RELAY_SERVER_FILE}
# loving this already, relay tgz contains a versioned directory...
echo "moving directory to a know location..."
mv ${BUILD_DIR}/relay/ws-relayd-linux-x64.* ${BUILD_DIR}/relay/ws-relayd


if [[ -f "${BUILD_DIR}/lobby/lobby_private.pem" || -f "${BUILD_DIR}/relay/lobby_public.pem" ]]; then
    echo "Lobby Server private key or relay public key exists"
else
    echo "Creating private key and public key..."
    openssl ecparam -name secp384r1 -genkey -noout -out ${BUILD_DIR}/lobby/lobby_private.pem
    openssl ec -in ${BUILD_DIR}/lobby/lobby_private.pem -pubout -out ${BUILD_DIR}/relay/lobby_public.pem
fi


docker build -t jetbrains/cwm/lobby:$LOBBY_VERSION . -f Dockerfile.lobby

docker build -t jetbrains/cwm/relay:$RELAY_VERSION . -f Dockerfile.relay

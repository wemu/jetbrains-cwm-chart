#!/bin/bash

BUILD_DIR=${PWD}/build
echo "creating Lobby and Relay Server Docker Images in ${BUILD_DIR}"

mkdir -p ${BUILD_DIR}/lobby
mkdir -p ${BUILD_DIR}/relay


LOBBY_SERVER_FILE=lobby-server.tar.gz
RELAY_SERVER_FILE=ws-relayd

#
# https://www.jetbrains.com/help/cwm/code-with-me-administration-guide.html
#
if [ -f "${BUILD_DIR}/${LOBBY_SERVER_FILE}" ]; then
    echo "Lobby Server file exists"
else
    echo "Downloading Lobby Server file..."
    wget -q -O ${BUILD_DIR}/${LOBBY_SERVER_FILE} https://download.jetbrains.com/idea/code-with-me/backend/20201008T113700Z/lobby-server-linux-x64.1128.tar.gz?_ga=2.52704298.381351510.1603426577-1724742732.1601578118
    tar -C ${BUILD_DIR}/lobby -xf ${BUILD_DIR}/${LOBBY_SERVER_FILE}
fi

if [ -f "${BUILD_DIR}/${RELAY_SERVER_FILE}" ]; then
    echo "Relay Server file exists"
else
    echo "Downloading Relay Server file..."
    wget -q -O ${BUILD_DIR}/relay/${RELAY_SERVER_FILE} https://download.jetbrains.com/idea/code-with-me/backend/20201008T113700Z/ws-relayd1032?_ga=2.52704298.381351510.1603426577-1724742732.1601578118
fi

if [[ -f "${BUILD_DIR}/lobby/lobby_private.pem" || -f "${BUILD_DIR}/relay/lobby_public.pem" ]]; then
    echo "Lobby Server private key or relay public key exists"
else
    echo "Creating private key and public key..."
    openssl ecparam -name secp384r1 -genkey -noout -out ${BUILD_DIR}/lobby/lobby_private.pem
    openssl ec -in ${BUILD_DIR}/lobby/lobby_private.pem -pubout -out ${BUILD_DIR}/relay/lobby_public.pem
fi


docker build -t jetbrains/cwm/lobby:latest . -f Dockerfile.lobby

docker build -t jetbrains/cwm/relay:latest . -f Dockerfile.relay


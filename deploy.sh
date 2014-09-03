#!/bin/bash -x

APP_REPO=$1
APP_ENV=$2

# Read properties
function getProp(){
  grep "$1=" $APP_REPO/env/$APP_ENV.properties |cut -d"=" -f2
}

function getGlobal(){
  grep "$1=" $APP_REPO/env/docker.properties |cut -d"=" -f2
}

#PORT_MAPPING=$(grep ports.mapping $APP_REPO/env/$APP_ENV.properties |cut -d"=" -f2)
PORT_MAPPING=$(getProp ports.mapping)
DOCKER_REPOSITORY=$(getGlobal docker.repository)
DOCKER_VERSION=$(getGlobal docker.repository.version)
CORE_OS=$(getProp coreos.ip)

PORTS_ARG=""
for MAP in $(echo $PORT_MAPPING | tr "," "\n" );do
  PORTS_ARG="$PORTS_ARG -p $MAP"
done

ENV_ARGS="env=$APP_ENV"

# Go

#https://github.com/Jean-Eudes/hello-world
ssh -i $APP_REPO/env/$APP_ENV.key.pem core@$CORE_OS "docker stop $APP_ENV ;docker rm $APP_ENV; docker run -d -e $ENV_ARGS --name=$APP_ENV $PORTS_ARG $DOCKER_REPOSITORY:$DOCKER_VERSION"


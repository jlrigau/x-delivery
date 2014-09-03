#!/bin/bash

APP_REPO=$1
APP_ENV=$2

function usage(){
  echo deploy.sh /PATH/TO/PROJECT ENV
}

function getProp(){
  grep "$1=" $APP_REPO/env/$APP_ENV.properties |cut -d"=" -f2
}

function getGlobal(){
  grep "$1=" $APP_REPO/env/docker.properties |cut -d"=" -f2
}

# Check parameters
if [ $# -lt 2 ];then
  usage
  exit 1
fi

if [ ! -d $APP_REPO ];then
  echo Unable to find project $APP_REPO
  exit 1
fi

if [ ! -e $APP_REPO/env/$APP_ENV.properties ];then
  echo Unable to find $APP_REPO/env/$APP_ENV.properties
  exit 1
fi

# Read properties
DOCKER_REPOSITORY=$(getGlobal docker.repository)
DOCKER_VERSION=$(getGlobal docker.repository.version)
DOCKER_PRIVILEGED=$(getGlobal docker.privileged)

CORE_OS=$(getProp coreos.ip)

PORT_MAPPING=$(getProp ports.mapping)
PORTS_ARG=""
for MAP in $(echo $PORT_MAPPING | tr "," "\n" );do
  PORTS_ARG="$PORTS_ARG -p $MAP"
done

ENV_ARGS="env=$APP_ENV"
if [ "DOCKER_PRIVILEGED" == "true"];then
  PRIVILEGED_ARGS="-privileged"
fi
# Go
chmod 600 $APP_REPO/env/$APP_ENV.key.pem
ssh -oStrictHostKeyChecking=no -i $APP_REPO/env/$APP_ENV.key.pem core@$CORE_OS "docker stop $APP_ENV ;docker rm $APP_ENV; docker run -d $PRIVILEGED_ARGS -e $ENV_ARGS --name=$APP_ENV $PORTS_ARG $DOCKER_REPOSITORY:$DOCKER_VERSION"

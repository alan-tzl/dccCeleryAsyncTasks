#!/bin/bash
#
# Author:
#   Alan Tai
# Program:
#   Pull dcc imgs from docker hub
# Date:
#   3/21/2017

set -e

# export variables
source $(pwd)/scripts/envVariables
CWD=$(pwd)

finish() {
  local existcode=$?
  cd $CWD
  exit $existcode
}

trap "finish" INT TERM

# login registry
docker login -u $DCC_USER_NAME -p $DCC_PWD

set +e
# pull imgs
IMAGE_ARY=("$DCC_IMG_REPO:$DCC_NAME_FLASK_SERVER.$DCC_IMG_VERSION_FLASK_SERVER"
  "$DCC_IMG_REPO:$DCC_NAME_CELERY_TASKS-$DCC_IMG_VERSION_CELERY_TASKS"
)

for ith in "${IMAGE_ARY[@]}"; do
  docker pull $ith
done
set -e

docker logout

#!/bin/bash
#
# Author:
#   Alan Tai
# Program:
#   Build the base of the docker imgs
# Date:
#   3/21/2018

set -e

source $(pwd)/scripts/envVariables

bold=$(tput bold)
normal=$(tput sgr0)

# login registry
docker login -u $DCC_USER_NAME -p $DCC_PWD

set +e
$(docker inspect $DCC_IMG_REPO:$DCC_NAME_FLASK_SERVER-$DCC_IMG_VERSION_FLASK_SERVER)
EXITCODE_OF_FLASK_SERVER_IMG_INSPECTION=$?
$(docker inspect $DCC_IMG_REPO:$DCC_NAME_CELERY_TASKS-$DCC_IMG_VERSION_CELERY_TASKS)
EXITCODE_OF_CELERY_TASKS_IMG_INSPECTION=$?
set -e

if [[ $EXITCODE_OF_FLASK_SERVER_IMG_INSPECTION -eq 1 ]]; then
  echo "DCC image, ${bold} $DCC_IMG_REPO:$DCC_NAME_FLASK_SERVER-$DCC_IMG_VERSION_FLASK_SERVER ${normal}, already exists!"
else
  docker build \
    -t "$DCC_IMG_REPO:$DCC_NAME_FLASK_SERVER-$DCC_IMG_VERSION_FLASK_SERVER" \
    --build-arg APP_DIR=$APP_DIR \
    --build-arg USER_ID=$USER_ID \
    -f $(pwd)/flask_server/Dockerfile .

  # push img to the registry
  docker push "$DCC_IMG_REPO:$DCC_NAME_FLASK_SERVER-$DCC_IMG_VERSION_FLASK_SERVER"
fi

if [[ $EXITCODE_OF_CELERY_TASKS_IMG_INSPECTION -eq 1 ]]; then
  echo "DCC image, ${bold} $DCC_IMG_REPO:$DCC_NAME_CELERY_TASKS-$DCC_IMG_VERSION_CELERY_TASKS ${normal}, already exists!"
else
  docker build \
    -t "$DCC_IMG_REPO:$DCC_NAME_CELERY_TASKS-$DCC_IMG_VERSION_CELERY_TASKS" \
    --build-arg APP_DIR=$APP_DIR \
    --build-arg USER_ID=$USER_ID \
    -f $(pwd)/celery_tasks/Dockerfile .

  # push img to the registry
  docker push "$DCC_IMG_REPO:$DCC_NAME_CELERY_TASKS-$DCC_IMG_VERSION_CELERY_TASKS"
fi

docker logout


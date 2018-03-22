#!/bin/bash
#
# Author:
#   Alan Tai
# Program:
#   Spin up the flask-celery-based topology
# Date:
#   3/21/2017

set -e

source $(pwd)/scripts/envVariables

# redis dcc
docker run -d \
  -p 4999:6379 \
  --name $DCC_TOPOLOGY_REDIS_NAME \
  --net=$DCC_TOPOLOGY_TZL_NETWORK_NAME \
  --ip=$DCC_TOPOLOGY_REDIS_IP \
  --log-opt mode=non-blocking \
  --log-opt max-buffer-size=4m \
  --log-opt max-size=100m \
  --log-opt max-file=5 \
  --restart \
  unless-stopped \
  redis redis-server \
  --appendonly yes

# falsk server
docker run -d \
  -p 5000:8080 \
  --name $DCC_NAME_FLASK_SERVER \
  --net=$DCC_TOPOLOGY_TZL_NETWORK_NAME \
  --ip=$DCC_FLASK_SERVER_IP \
  --log-opt mode=non-blocking \
  --log-opt max-buffer-size=4m \
  --log-opt max-size=100m \
  --log-opt max-file=5 \
  --restart \
  unless-stopped \
  "$DCC_IMG_REPO:$DCC_NAME_FLASK_SERVER-$DCC_IMG_VERSION_FLASK_SERVER" \
  sh -c 'python app.py'

# tasks one
celery_tasks_one_commands=(
  "celery worker -A tasks_one.celery --loglevel=info -Q tasks_one_queue1 -n worker1@%h & "
  "celery worker -A tasks_one.celery --loglevel=info -Q tasks_one_queue2 -n worker2@%h"
)
docker run -d \
  --name $DCC_CELERY_TASKS_ONE \
  --net=$DCC_TOPOLOGY_TZL_NETWORK_NAME \
  --ip=$DCC_CELERY_TASKS_ONE_IP \
  --log-opt mode=non-blocking \
  --log-opt max-buffer-size=4m \
  --log-opt max-size=100m \
  --log-opt max-file=5 \
  --restart \
  unless-stopped \
  "$DCC_IMG_REPO:$DCC_NAME_CELERY_TASKS-$DCC_IMG_VERSION_CELERY_TASKS" \
  sh -c "${celery_tasks_one_commands[*]}"

# tasks two
celery_tasks_two_commands=(
  "celery worker -A tasks_two.celery --loglevel=info -Q tasks_two_queue1 -n worker1@%h & "
  "celery worker -A tasks_two.celery --loglevel=info -Q tasks_two_queue2 -n worker2@%h"
)
docker run -d \
  --name $DCC_CELERY_TASKS_TWO \
  --net=$DCC_TOPOLOGY_TZL_NETWORK_NAME \
  --ip=$DCC_CELERY_TASKS_TWO_IP \
  --log-opt mode=non-blocking \
  --log-opt max-buffer-size=4m \
  --log-opt max-size=100m \
  --log-opt max-file=5 \
  --restart \
  unless-stopped \
  "$DCC_IMG_REPO:$DCC_NAME_CELERY_TASKS-$DCC_IMG_VERSION_CELERY_TASKS" \
  sh -c "${celery_tasks_two_commands[*]}"

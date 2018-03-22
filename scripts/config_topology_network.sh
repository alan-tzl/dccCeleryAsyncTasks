#!/bin/bash
#
# Author:
#   Alan Tai
# Program:
#   Configure network
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

set +e
# check if network exists
NETWORK_INSPECTION=$(docker network inspect "$DCC_TOPOLOGY_TZL_NETWORK_NAME")
EXITCODE_NETWORK_INSPECTION=$?
[[ $EXITCODE_NETWORK_INSPECTION -ne 0 ]] || (echo "Network, $DCC_TOPOLOGY_TZL_NETWORK_NAME, exists and will be reset" && docker network rm $DCC_TOPOLOGY_TZL_NETWORK_NAME)

# create network
docker network create \
  --driver=$DCC_TOPOLOGY_NETWORK_DRIVER \
  --gateway=$DCC_TOPOLOGY_GATEWAY \
  --subnet=$DCC_TOPOLOGY_SUBNET \
  $DCC_TOPOLOGY_TZL_NETWORK_NAME
set -e

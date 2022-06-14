#!/bin/bash

if [ -z ${serverAddresses+x} ]; then
  echo "serverAddresses is unset. You need to set a comma separated list of machine:port. Exiting program.";
  exit 1;
else
  echo "serverAddresses is set to '$serverAddresses'";
fi

mongoDbInitiateTemplate="rs.initiate({ _id : \"@@clusterRole@@\", members: [@@members@@] })"
membersTemplate="{ _id : @@id@@, host : \"@@machine@@\" }"

IFS=',' read -r -a serverAddressesSplit <<< "$serverAddresses"

cnt=0
declare -a memberFormatted=()

for serverAddress in "${serverAddressesSplit[@]}"
do
  idReplaced=${membersTemplate/@@id@@/$cnt}
  machineReplaced=${idReplaced/@@machine@@/$serverAddress}
  memberFormatted[${#memberFormatted[@]}]=$machineReplaced
  cnt=$((cnt+1))
done

echo "${memberFormatted[@]}"

memberFormattedJoinedByComa=$(IFS=, ; echo "${memberFormatted[*]}")

membersReplaced=${mongoDbInitiateTemplate/@@members@@/$memberFormattedJoinedByComa}

configServerInitiate=${membersReplaced/@@clusterRole@@/replicaSetConfigServer}
shardServerInitiate=${membersReplaced/@@clusterRole@@/replicaSetShardServer}

echo "$configServerInitiate"
echo "$shardServerInitiate"

# execute initiate.


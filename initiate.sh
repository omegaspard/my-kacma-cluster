#!/bin/bash

if [ -z ${serverAddresses+x} ]; then
  echo "serverAddresses is unset. You need to set a comma separated list of machine:port. Exiting program.";
  exit 1;
else
  echo "serverAddresses is set to '$serverAddresses'";
fi

mongoDbInitiateTemplate="rs.initiate({  _id : \"myReplSet\",  members: [{{members}}]})"
membersTemplate="{ _id : {{id}}, host : \"{{machine}}\" }"

IFS=',' read -r -a serverAddresssesSplit <<< "$serverAddresses"

cnt=0
declare -a memberFormated=()

for serverAddress in "${serverAddressesSplit[@]}"
do
  echo $cnt
  echo "$serverAddress"
  memberFormated[${#memberFormated[@]}]=severAddress
  cnt=cnt+1
  # replace id by cnt
  # replace machine by machine name
  # put the result in a new array
done

# run docker compose --profile shard with the string.



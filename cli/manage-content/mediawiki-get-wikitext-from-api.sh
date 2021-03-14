#!/bin/bash

source ./envs/my-new-system.env

####################################

source ./cli/lib/utils.sh

CR=$(curl -S \
	$OPTION_INSECURE \
	--location \
    --silent \
	--cookie $cookie_jar \
	--cookie-jar $cookie_jar \
	--user-agent "Curl Shell Script" \
	--keepalive-time 60 \
	--header "Accept-Language: en-us" \
	--header "Connection: keep-alive" \
	--compressed \
	--request "GET" "${WIKIAPI}?action=query&prop=revisions&titles=$TITLE&rvslots=*&rvprop=content&formatversion=2&format=json&rvsection=$SECTION")

rm ${folder}/cache.json
echo "$CR" > ${folder}/cache.json
WIKITEXT=$(jq --raw-output '.query.pages[0].revisions[0].slots.main.content' ${folder}/cache.json)
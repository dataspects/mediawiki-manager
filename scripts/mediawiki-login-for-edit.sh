#!/bin/bash

source ./CanastaInstanceSettings.env

####################################

USERNAME=Admin
USERPASS=123adminpass456
WIKI=https://dserver/w
WIKIAPI=https://dserver/w/api.php
cookie_jar="wikicj"
folder="/tmp"

OPTION_INSECURE=--insecure

CR=$(curl -S \
    $OPTION_INSECURE \
	--location \
    --silent \
	--retry 2 \
	--retry-delay 5\
	--cookie $cookie_jar \
	--cookie-jar $cookie_jar \
	--user-agent "Curl Shell Script" \
	--keepalive-time 60 \
	--header "Accept-Language: en-us" \
	--header "Connection: keep-alive" \
	--compressed \
	--request "GET" "${WIKIAPI}?action=query&meta=tokens&type=login&format=json")

rm ${folder}/login.json
echo "$CR" > ${folder}/login.json
TOKEN=$(jq --raw-output '.query.tokens.logintoken'  ${folder}/login.json)
if [ "$TOKEN" == "null" ]; then
	echo "Getting a login token failed."
	exit
fi

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
	--data-urlencode "username=$USERNAME" \
	--data-urlencode "password=$USERPASS" \
	--data-urlencode "rememberMe=1" \
	--data-urlencode "logintoken=$TOKEN" \
	--data-urlencode "loginreturnurl=$WIKI" \
	--request "POST" "$WIKIAPI?action=clientlogin&format=json")

STATUS=$(echo $CR | jq '.clientlogin.status')
if [[ $STATUS == *"PASS"* ]]; then
	echo "Successfully logged in as $USERNAME."
	echo "-----"
else
	echo "Unable to login $USERNAME with $USERPASS, is logintoken ${TOKEN} correct?"
	exit
fi

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
	--request "GET" "${WIKIAPI}?action=query&meta=tokens&type=csrf&format=json")

echo "$CR" > ${folder}/edittoken.json
EDITTOKEN=$(jq --raw-output '.query.tokens.csrftoken' ${folder}/edittoken.json)
rm ${folder}/edittoken.json

if ! [[ $EDITTOKEN == *"+\\"* ]]; then
	echo "Edit token not set."
	exit
fi

#!/bin/bash

echo $PAGENAME
echo $WIKITEXT

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
	--data-urlencode "title=$PAGENAME" \
	--data-urlencode "text=$WIKITEXT" \
	--data-urlencode "token=${EDITTOKEN}" \
	--request "POST" "${WIKIAPI}?action=edit&format=json")
echo "Injected content into $PAGENAME."
sleep 0.5
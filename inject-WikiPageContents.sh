#!/bin/bash

source ./CanastaInstanceSettings.env

####################################

source ./scripts/mediawiki-login-for-edit.sh

for filename in WikiPageContents/*.wikitext; do
    PAGENAME=$(sed -r 's/.*\/(.*).wikitext/\1/g' <<< $filename)
    WIKITEXT=`cat "$filename"`
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
    echo "Injected content '$WIKITEXT' into $PAGENAME."
done
#!/bin/bash   

COMMAND="ifconfig | grep \"inet \" | grep -v 127.0.0.1 | cut -d' '  -f2"
INET_IP=`eval $COMMAND`
PORT=$1
if [ "$PORT" = "" ] ; then
	PORT=5984
fi

HTTP_RES_CODE=`curl -Is http://${INET_IP}:${PORT} | head -1 | cut -d' '  -f2`

if [ "$HTTP_RES_CODE" = "200" ] ; then
	echo "off"
else 
	echo "on"
fi

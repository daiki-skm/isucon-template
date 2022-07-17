#!/bin/sh

CMDNAME=`basename $0`
if [ $# -ne 1 ]; then
  echo "Usage: sh $CMDNAME file" 1>&2
  exit 1
fi

# mv /var/log/nginx/access.log /var/log/nginx/access.log.`date +%Y%m%d-%H%M%S`
mv /var/log/nginx/access.log /var/log/nginx/access.log.$1 &&

nginx -s reopen &&

k6 run $1.js &&

alp json --sort sum -r -m "/posts/[0-9]+,/@\w+" -o count,method,uri,min,avg,max,sum < /var/log/nginx/access.log.$1 ||

echo "ERROR";
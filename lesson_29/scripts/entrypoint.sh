#!/bin/bash
set -e
    max_tries=15
    attempt_num=0
    until (echo > "/dev/tcp/$MYSQL_HOST/$MYSQL_PORT") >/dev/null 2>&1; do
	    sleep $(( attempt_num++ ))
	    if (( attempt_num == max_tries )); then
		    exit 1
	    fi
    done
   mysqlsh "$MYSQL_USER@$MYSQL_HOST:$MYSQL_PORT" --dbpassword="$MYSQL_PASSWORD" -f "$MYSQLSH_SCRIPT" 
exec "$@"

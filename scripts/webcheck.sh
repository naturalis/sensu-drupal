#!/bin/bash
#
# each line in the url file should consist of a testable GET route 
# in the site this is just to check if the site still works and 
# returns a 200 code on each of the routes
#
urlfile="/opt/repo/scripts/routes.txt"
TIMEOUT=10
WARNING_COUNT=0
ERROR_COUNT=0

if [ ! -f $urlfile ]
then
    echo "$urlfile not found"
    exit 1
fi

while read -r url
do
  status_code=$(curl -sL -w '%{http_code}' $url -m $TIMEOUT -o /dev/null)
  if [ "$status_code" -ne 200 ]
    then
        if [ "$status_code" -gt 404 ]
        then 
            ERROR_COUNT=$((ERROR_COUNT+1))
        elif [ "$status_code" -eq 0 ]
        then
            ERROR_COUNT=$((ERROR_COUNT+1))
        else
            WARNING_COUNT=$((WARNING_COUNT+1))
        fi
  fi
done < $urlfile
echo "URL check: $ERROR_COUNT errors, $WARNING_COUNT warning"
if [ $ERROR_COUNT -gt 0 ]
then
    exit 2
elif [ $WARNING_COUNT -gt 0 ]
then
    exit 1
fi
exit 0

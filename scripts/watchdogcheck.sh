#!/bin/bash
#
# Check the Drupal watchdog logging for trouble
FORMAT=$1
COUNT_SEVERE=0
COUNT_NORMAL=0
SEVERE_ERRORS="0 1"
NORMAL_ERRORS="2 3"
cd /opt/docker-drupal
if [ ! $FORMAT ] ; then
    FORMAT='list'
fi
for lvl in $NORMAL_ERRORS; do
    while read -r line; do
        COUNT_NORMAL=$((COUNT_NORMAL+1))
    done < <(sudo docker-compose exec -T drupal drush ws --severity=$lvl --format=$FORMAT 2> /dev/null)
done
for lvl in $SEVERE_ERRORS; do
    while read -r line; do
        COUNT_SEVERE=$((COUNT_SEVERE+1))
    done < <(sudo docker-compose exec -T drupal drush ws --severity=$lvl --format=$FORMAT 2> /dev/null)
done
echo "Log messages: $COUNT_SEVERE severe, $COUNT_NORMAL normal"
cd -
if [ $COUNT_SEVERE -gt 0 ]
then
    exit 2
elif [ $COUNT_NORMAL -gt 0 ]
then
    exit 0
fi
exit 0

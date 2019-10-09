#!/bin/bash
#
# Check the Drupal watchdog logging for trouble
FORMAT=$1
COUNT_SEVERE=0
COUNT_NORMAL=0
SEVERE_ERRORS="1 2"
NORMAL_ERRORS="3 4"
cd /opt/composeproject
if [ ! $FORMAT ] ; then
    FORMAT='list'
fi
for lvl in $NORMAL_ERRORS; do
    while read -r line; do
        COUNT_NORMAL=$((COUNT_NORMAL+1))
    done < <(docker-compose exec -T drupal drush ws --severity=$lvl --format=$FORMAT --pipe)
done
for lvl in $SEVERE_ERRORS; do
    while read -r line; do
        COUNT_SEVERE=$((COUNT_SEVERE+1))
    done < <(docker-compose exec -T drupal drush ws --severity=$lvl --format=$FORMAT --pipe)
done
echo "Log messages: $COUNT_SEVERE severe, $COUNT_NORMAL normal"
if [ $COUNT_SEVERE -gt 0 ]
then
    exit 2
elif [ $COUNT_NORMAL -gt 0 ]
then
    exit 0
fi
exit 0

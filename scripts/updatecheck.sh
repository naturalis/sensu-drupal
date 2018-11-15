#!/bin/bash
#
# This script checks if there are drupal updates. First security updates followed by all other updates.
#
SECURITYUPDATES=0
NORMALUPDATES=0
cd /opt/docker-drupal
while read -r line
do
    SECURITYUPDATES=$((SECURITYUPDATES+1))
done < <(sudo docker-compose exec -T drupal drush ups --format=list --security-only 2> /dev/null )
while read -r line
do
    NORMALUPDATES=$((NORMALUPDATES+1))
done < <(sudo docker-compose exec -T drupal drush ups --format=list 2> /dev/null)
cd -
echo "Updates: $SECURITYUPDATES security, $NORMALUPDATES normal"
if [ $SECURITYUPDATES -gt 0 ]
then
    exit 1
fi
exit 0

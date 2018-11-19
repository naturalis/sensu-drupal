#!/bin/bash
#
# This script checks if there are drupal updates. First security updates followed by all other updates.
#
cd /opt/docker-drupal
SECURITYUPDATES=$(docker-compose exec -T drupal drush ups --security-only --pipe |wc -l)
NORMALUPDATES=$(docker-compose exec -T drupal drush ups --pipe |wc -l)
echo "Updates: $SECURITYUPDATES security, $NORMALUPDATES normal"
if [ $SECURITYUPDATES -gt 0 ]
then
    exit 1
fi
exit 0

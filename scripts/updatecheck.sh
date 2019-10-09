#!/bin/bash
#
# This script checks if there are drupal updates. First security updates followed by all other updates.
#
cd /opt/composeproject
SECURITYUPDATES=$(docker-compose exec -T drupal drush pm:security --pipe |wc -l)
NORMALUPDATES=$(docker-compose exec drupal composer update --dry-run | grep "^  -" | wc -l)
echo "Updates: $SECURITYUPDATES security, $NORMALUPDATES normal"
if [ $SECURITYUPDATES -gt 0 ]
then
    exit 1
fi
exit 0

#!/bin/bash
## Author: Hugo van Duijn
## Description : Runs all scripts in predefined directory
## Version : 1.0
##
scriptdir=/opt/repo/scripts
scriptextension='sh'

if [ ! -d "$scriptdir" ]; then
  echo "No drupal scriptdir found."
  exit 0
fi

if find $scriptdir -name "*.${scriptextension}" -exec false {} +
then
  echo "No scripts with extension .${scriptextension} in scriptdir found."
  exit 0
fi

highestlevel=0
currentlevel=0

for file in $(find ${scriptdir} -type f -name "*.${scriptextension}"); do
   $file
   currentlevel=$?
   if [ $currentlevel -gt $highestlevel ]
     then
        highestlevel=$currentlevel
     fi
   done

exit $highestlevel

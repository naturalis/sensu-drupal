# Sensu Drupal

These script check the dockerized drupal installations of Naturalis
via sensu.

## Installation

* login as root
* clone this installation in /opt/repo
* add urls to scripts/routes.txt

If something results in errors or warnings, joep.vermaat@naturalis.nl 
will receive e-mail about it and it will show up in the infra
information center.

## Drupalchk.sh

This script scans the scripts directory and calls every executable
script in this directory. It keeps track of the error level of each
executed script and puts it through to the sensu system.

## scripts/updatecheck.sh

Checks the updates of the drupal installation. First by doing:

```
drush ups --security-only
```

Which lists all security level updates. Anything coming up here results in
a errorlevel=1 and should be reported.

Then the normal (and security) updates get counted.

```
drush ups
```

These are not reported, only when there are security updates, the script
'fails'.

You can check which security updates are needed by executing ```drush ups``` by hand.

## scripts/watchdogcheck.sh

This scripts checks the Drupal logfile with command:

```
drush ws --severity=0
```

Which lists log entries of a certain error level. 0 and 1 are *severe*, 
2 and 3 are **normal**. Any severe errors result in error level 2.

Whenever you receive warnings from sensu you should run this command by
hand:

```
drush ws --severity=0
```


## scripts/webcheck.sh

The last check is a simple 200 check on certains web routes. It just does
a curl GET call with this url. If any turn up other then 200, there's
something wrong with the sanity of the installation.

You should add important url's to `/opt/repo/scripts/routes.txt` and if
any of the url's result in error, it should be checked and fixed.



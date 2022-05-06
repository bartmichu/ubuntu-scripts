#!/bin/bash

## ----------------------------------------------------------------------
## https://github.com/bartmichu/ubuntu-scripts
##
## Check if reboot-required flag is set and email notification if
## needed.
##
## This script may be executed by a cron job.
##
## ----------------------------------------------------------------------

email_address="root"
email_subject="`/bin/hostname` - Reboot Required"

if [ -f /var/run/reboot-required ]; then
  echo "A reboot is required following updates to this server: `/bin/hostname`" | /usr/bin/mail -s "$email_subject" $email_address
fi

#!/bin/bash

## ----------------------------------------------------------------------
## https://github.com/bartmichu/ubuntu-scripts
##
## Run Lynis system audit and email warnings.
##
## This script may be executed by a cron job.
##
## ----------------------------------------------------------------------

email_address="root"
email_subject="`/bin/hostname` - Lynis Audit Warnings"
lynis_cmd="/usr/sbin/lynis"

if [ ! -x ${lynis_cmd} ]; then
  echo "Error: Lynis is not installed, can not run system audit."
  exit 1
fi

lynis_report="`/usr/sbin/lynis audit system --cronjob --warnings-only`"

if [ -n "$lynis_report" ]; then
  /usr/bin/printf '%s\n' "$email_subject" "" "$lynis_report" | /usr/bin/mail -s "$email_subject" "$email_address"
fi

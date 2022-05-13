#!/bin/bash

## ----------------------------------------------------------------------
## https://github.com/bartmichu/ubuntu-scripts
##
## Run Lynis system audit and email warnings when needed.
##
## Requirements:
## - mail utility installed, for example from mailutils package
## - lynis package installed
##
## ----------------------------------------------------------------------

# User configuration block starts here ->
email_address="root"
email_subject="`/bin/hostname` - Lynis Audit Warnings"
# <- User configuration block ends here

lynis_cmd="/usr/sbin/lynis"
mail_cmd="/usr/bin/mail"

if [ ! -x ${mail_cmd} ]; then
  echo "Error: mail utility is not installed."
  exit 1
fi

if [ ! -x ${lynis_cmd} ]; then
  echo "Error: Lynis is not installed, can not run system audit."
  exit 1
fi

lynis_report="`${lynis_cmd} audit system --cronjob --warnings-only`"

if [ -n "$lynis_report" ]; then
  /usr/bin/printf '%s\n' "$email_subject" "" "$lynis_report" | ${mail_cmd} -s "$email_subject" "$email_address"
fi

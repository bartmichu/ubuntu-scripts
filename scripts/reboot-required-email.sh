#!/bin/bash

## ----------------------------------------------------------------------
## https://github.com/bartmichu/ubuntu-scripts
##
## Check if system reboot is required and send email notification when
## needed.
##
## Requirements:
## - mail utility installed, for example from mailutils package
##
## ----------------------------------------------------------------------

# User configuration block starts here ->
email_address="root"
email_subject="`/bin/hostname` - Reboot Required"
# <- User configuration block ends here

mail_cmd="/usr/bin/mail"
reboot_flag_file="/var/run/reboot-required"

if [ ! -x ${mail_cmd} ]; then
  echo "Error: mail utility is not installed."
  exit 1
fi

if [ -f ${reboot_flag_file} ]; then
  echo "A reboot is required following updates to this server: `/bin/hostname`" | ${mail_cmd} -s "$email_subject" $email_address
fi

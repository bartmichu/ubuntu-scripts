#!/bin/bash

# -----------------------------------------------------------------------
# https://github.com/bartmichu/ubuntu-scripts
#
# This script checks if a system reboot is required and sends an email
# notification when necessary.
#
# Requirements:
# - The 'mail' utility must be installed, for example, from the
#   'mailutils' package.
#
# -----------------------------------------------------------------------

# User configuration block starts here
email_address="root"
email_subject="`/bin/hostname` - Reboot Required"
# User configuration block ends here

mail_cmd="/usr/bin/mail"
reboot_flag_file="/var/run/reboot-required"

if [ ! -x ${mail_cmd} ]; then
  echo "Error: The mail utility is not installed."
  exit 1
fi

if [ -f ${reboot_flag_file} ]; then
  echo "A reboot is required after updates to this server: `/bin/hostname`" | ${mail_cmd} -s "$email_subject" $email_address
fi

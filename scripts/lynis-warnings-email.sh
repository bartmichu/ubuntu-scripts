#!/bin/sh

email_address="root"
email_subject="`/bin/hostname` - Lynis Audit Warnings"

lynis_report="`/usr/sbin/lynis audit system --cronjob --warnings-only`"

if [ -n "$lynis_report" ]; then
   /usr/bin/printf '%s\n' "$email_subject" "" "$lynis_report" | /usr/bin/mail -s "$email_subject" "$email_address"
fi

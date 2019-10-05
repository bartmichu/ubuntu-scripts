#!/bin/sh

date=$(date +%Y%m%d)
email_address="root"
email_subject="`hostname` - Lynis Audit Warnings"

printf '%s\n' "$email_subject" "" "`/usr/sbin/lynis audit system --cronjob --warnings-only`" | /usr/bin/mail -s "$email_subject" $email_address

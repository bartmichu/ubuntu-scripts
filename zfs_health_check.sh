#!/bin/sh

#
# Based on https://calomel.org/zfs_health_check_script.html by Calomel.org
#

capacity_threshold=80
scrub_threshold=35
email_address="root"

condition=$(/sbin/zpool status | egrep -i '(DEGRADED|FAULTED|OFFLINE|UNAVAIL|REMOVED|FAIL|DESTROYED|corrupt|cannot|unrecover)')
problems=0

if [ "${condition}" ]; then
        email_subject="`hostname` - ZFS pool - HEALTH fault"
        problems=1
fi

if [ ${problems} -eq 0 ]; then
   capacity=$(/sbin/zpool list -H -o capacity | cut -d'%' -f1)
   for line in ${capacity}
     do
       if [ $line -ge $capacity_threshold ]; then
         email_subject="`hostname` - ZFS pool - Capacity Exceeded"
         problems=1
       fi
     done
fi

if [ ${problems} -eq 0 ]; then
   errors=$(/sbin/zpool status | grep ONLINE | grep -v state | awk '{print $3 $4 $5}' | grep -v 000)
   if [ "${errors}" ]; then
        email_subject="`hostname` - ZFS pool - Drive Errors"
        problems=1
   fi
fi

if [ ${problems} -eq 0 ]; then
   current_date=$(date +%s)
   zfs_volumes=$(/sbin/zpool list -H -o name)

  for volume in ${zfs_volumes}
   do
    if [ $(/sbin/zpool status $volume | egrep -c "none requested") -ge 1 ]; then
        printf "ERROR: You need to run \"zpool scrub $volume\" before this script can monitor the scrub expiration time."
        break
    fi
    if [ $(/sbin/zpool status $volume | egrep -c "scrub in progress|resilver") -ge 1 ]; then
        break
    fi

    scrub_raw_date=$(/sbin/zpool status $volume | grep scrub | awk '{print $11" "$12" " $13" " $14" "$15}')
    scrub_date=$(date -d "$scrub_raw_date" +%s)

     if [ $(($current_date - $scrub_date)) -ge $(($scrub_threshold * 24 * 60 * 60)) ]; then
        email_subject="`hostname` - ZFS pool - Scrub Time Expired. Scrub Needed on Volume(s)"
        problems=1
     fi
   done
fi

if [ "$problems" -ne 0 ]; then
  printf '%s\n' "$email_subject" "" "`/sbin/zpool list`" "" "`/sbin/zpool status`" | /usr/bin/mail -s "$email_subject" $email_address
  logger $email_subject
fi

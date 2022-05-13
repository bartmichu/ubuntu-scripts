#!/bin/bash

## ----------------------------------------------------------------------
## https://github.com/bartmichu/ubuntu-scripts
##
## Create the reboot-required flag file if some services require restart
## i.e. they continue to use files deleted after upgrade or removal of
## packages.
##
## Requirements:
## - needrestart package installed (default on Ubuntu Server 22.04)
##
## ----------------------------------------------------------------------

# User configuration block starts here ->
# <- User configuration block ends here

needrestart_cmd="/usr/sbin/needrestart"
reboot_flag_file="/var/run/reboot-required"

if [ ! -x ${needrestart_cmd} ]; then
  echo "Error: needrestart is not installed, can not check which services need to be restarted."
  exit 1
fi

needrestart_output=`$needrestart_cmd -b -r l -l`
needrestart_rc=$?

if [ $needrestart_rc -eq 0 ]; then
  services_number=`echo $needrestart_output | /usr/bin/grep -i 'needrestart-svc' | /usr/bin/wc -l`

  if [ $services_number -gt 0 ]; then
    if [ -f ${reboot_flag_file} ]; then
      exit 0
    else
      /usr/bin/touch ${reboot_flag_file}
      touch_rc=$?
      if [ $touch_rc -eq 0 ]; then
        exit 0
      else
        echo "Error: touch command returned unhandled code: "
        echo $touch_rc
        exit $touch_rc
      fi
    fi
  else
    exit 0
  fi
else
  echo "Error: needrestart command returned unhandled code: "
  echo $needrestart_rc
  exit $needrestart_rc
fi

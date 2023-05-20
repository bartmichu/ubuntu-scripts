#!/bin/bash

## ----------------------------------------------------------------------
## https://github.com/bartmichu/ubuntu-scripts
##
## Graceful shutdown check.
##
## This script consists of three parts:
## - graceful-shutdown-set.service file
##   Creates a flag file on proper system shutdown.
## - graceful-shutdown-sentinel.service file
##   Activates on system startup if the flag file exists, clears it up,
##   and then remains active.
## - graceful-shutdown-check.sh file
##   The actual script file. It utilizes services and the flag file to
##   determine if the last shutdown was graceful and outputs the
##   corresponding message. It returns 0 when the system was shut down
##   gracefully and 1 when it was shut down ungracefully.
##
## Installation:
##   $ sudo mv graceful-shutdown-sentinel.service /etc/systemd/system/graceful-shutdown-sentinel.service
##   $ sudo mv graceful-shutdown-set.service /etc/systemd/system/graceful-shutdown-set.service
##   $ sudo systemctl daemon-reload
##   $ sudo systemctl enable graceful-shutdown-sentinel
##   $ sudo systemctl enable graceful-shutdown-set
##   $ sudo chmod 0700 graceful-shutdown-check.sh
##
## Usage:
##   $ sudo ./graceful-shutdown-check.sh
##
## Or, alternatively, service state can be used directly:
##   $ sudo systemctl --quiet is-active graceful-shutdown-sentinel && echo graceful || echo UNGRACEFUL
##
## ----------------------------------------------------------------------

/usr/bin/systemctl --quiet is-active graceful-shutdown-sentinel
service_rc=$?

if [ $service_rc -eq 0 ]; then
  echo "System was shut down gracefully"
  exit 0
elif [ $service_rc -eq 3 ]; then
  echo "System was NOT shut down gracefully"
  exit 1
else
  echo "Unhandled return code: "
  echo $service_rc
  exit $service_rc
fi

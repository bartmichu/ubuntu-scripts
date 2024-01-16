#!/bin/bash

# -----------------------------------------------------------------------
# https://github.com/bartmichu/ubuntu-scripts
#
# Graceful shutdown check.
#
# This script comprises three components:
# - graceful-shutdown-set.service: Generates a flag file during a proper
#   system shutdown.
# - graceful-shutdown-sentinel.service: Activates during system startup
#   if the flag file exists, clears it, and remains active.
# - graceful-shutdown-check.sh: The script file determines the
#   gracefulness of the last shutdown by analyzing services and the flag
#   file, providing an output message. It returns 0 for a graceful
#   shutdown and 1 for an ungraceful one.
#
# Installation:
#   $ sudo mv graceful-shutdown-sentinel.service /etc/systemd/system/graceful-shutdown-sentinel.service
#   $ sudo mv graceful-shutdown-set.service /etc/systemd/system/graceful-shutdown-set.service
#   $ sudo systemctl daemon-reload
#   $ sudo systemctl enable graceful-shutdown-sentinel
#   $ sudo systemctl enable graceful-shutdown-set
#   $ sudo chmod 0700 graceful-shutdown-check.sh
#
# Usage:
#   $ sudo ./graceful-shutdown-check.sh
#
# Or, alternatively, service state can be used directly:
#   $ sudo systemctl --quiet is-active graceful-shutdown-sentinel && echo graceful || echo UNGRACEFUL
#
# -----------------------------------------------------------------------

/usr/bin/systemctl --quiet is-active graceful-shutdown-sentinel
service_rc=$?

if [ $service_rc -eq 0 ]; then
  echo "The system was shut down gracefully"
  exit 0
elif [ $service_rc -eq 3 ]; then
  echo "The system was not shut down gracefully"
  exit 1
else
  echo "Unhandled return code: "
  echo $service_rc
  exit $service_rc
fi

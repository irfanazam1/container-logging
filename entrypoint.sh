#!/bin/bash
echo "Entry point."
# run crond in the background
/usr/sbin/crond -b
fluentd -c "/fluentd/etc/fluent.conf"
echo "Exiting entry point."

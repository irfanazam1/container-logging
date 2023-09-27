#!/bin/bash

count=0
while [ $count -lt 300 ]; do
  if nc -z fluentd 24224; then
    echo "Fluentd is up and running."
    break
  else
    echo "Waiting for Fluentd to start..."
    sleep 1
    count=$((count+1))
  fi
done

echo "Leaving the wait for Fluentd."
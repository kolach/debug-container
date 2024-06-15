#!/bin/bash

# This script is used to keep the container running
# so that we can exec into it to debug the container.

handle_sigterm() {
  echo "Received SIGTERM, exiting..."
  exit 0
}

trap 'handle_sigterm' SIGTERM SIGINT

while true 
do 
  sleep 1000 &
  wait $!
done

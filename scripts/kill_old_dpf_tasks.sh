#!/bin/bash

while true; do
  killall --older-than 15s dpf-manager 2> /dev/null
  sleep 20
done

#!/bin/bash

apache=$(cat $PWD/utils/get_keys.json | jq -r '.apache')

if [ "$apache" = true ]; then
  if ! dpkg -s apache2 >/dev/null 2>&1; then
     sudo apt-get install apache2 -y -V
  fi
fi

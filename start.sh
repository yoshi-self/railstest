#!/bin/sh
#bundle exec puma -d -C config/puma.rb
puma -d -C config/puma.rb
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start my_first_process: $status"
  exit $status
fi
ps aux
/usr/sbin/nginx -g 'daemon off;'

#!/bin/sh
bundle exec puma -d -C config/puma.rb
/usr/sbin/nginx -g 'daemon off;'

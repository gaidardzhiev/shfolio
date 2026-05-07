#!/bin/sh

printf "go to http://localhost:8080\n"

busybox httpd -f -p 8080 -h "$PWD"

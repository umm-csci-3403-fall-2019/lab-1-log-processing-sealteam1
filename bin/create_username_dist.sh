#!/usr/bin/env bash

WORK_PATH="$1"

cd "$WORK_PATH"

for directory in ./*; do
  sed -E "s/[A-Za-z]+ [0-9]+ [0-9]+ ([a-zA-Z]+) [a-zA-Z0-9. ]+/\1/;t;d" < "failed_login_data.txt" > "stripped_usernames.txt"
  cd "../"
done

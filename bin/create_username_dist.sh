#!/usr/bin/env bash

WORK_PATH="$1"

cd "$WORK_PATH"

for directory in ./*; do
  echo "$directory"
  cd "$directory"
  echo "$PWD"
  cat "failed_login_data.txt"
  cd "../"
done

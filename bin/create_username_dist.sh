#!/usr/bin/env bash

WORK_PATH="$1"

cd "$WORK_PATH"

for directory in ./*; do
  cd "$directory"
  sed -E "s/[A-Za-z]+ [0-9]+ [0-9]+ ([a-zA-Z]+) [a-zA-Z0-9. ]+/\1/;t;d" < "failed_login_data.txt" > "stripped_usernames.txt"
  #Thanks to https://stackoverflow.com/questions/15984414/bash-script-count-unique-lines-in-file
  #This handles making unique and getting counts
  sort "stripped_usernames.txt" | uniq -c | sort -bgr > "user_counts.txt"
  #now we reformat them
  sed -E "s/ +([0-9]+) ([a-zA-Z\-_0-9]+)/data\.addRow\(\['\2', \1\]\)/" < "user_counts.txt" 
  cd "../"
done

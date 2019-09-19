#!/usr/bin/env bash
WORK_PATH=$1

EXP1="([a-zA-Z]+ [0-9]+ [0-9]+):[0-9]+:[0-9]+ [a-zA-Z_]+ sshd\[[0-9]+\]: Failed password for invalid user ([a-zA-Z0-9_\-]+) from ([0-9.]+).*"
EXP2="([a-zA-Z]+ [0-9]+ [0-9]+):[0-9]+:[0-9]+ [a-zA-Z_]+ sshd\[[0-9]+\]: Failed password for ([a-zA-Z0-9_\-]+) from ([0-9.]+).*"
EXP3="([a-zA-Z]+  [0-9]+ [0-9]+):[0-9]+:[0-9]+ [a-zA-Z_]+ sshd\[[0-9]+\]: Failed password for root from ([0-9\.]+).*"
cd "$WORK_PATH" || exit
touch "failed_login_data.txt"
#chmod 733 "failed_login_data.txt"
for filename in ./var/log/*; do
  # from http://mywiki.wooledge.org/BashPitfalls#line-57
  [ -e "$filename" ] || continue
  { sed -E "s/$EXP1/\1 \2 \3/;t;d" "$filename"; sed -E "s/$EXP2/\1 \2 \3/;t;d" "$filename";  sed -E "s/$EXP3/\1 root \2/;t;d" "$filename"; } >> "failed_login_data.txt"
done

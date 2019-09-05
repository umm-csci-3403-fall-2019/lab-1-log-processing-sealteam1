#!/usr/bin/env bash
WORK_PATH=$1

EXP1="([a-zA-Z]+ [0-9]+ [0-9]+):[0-9]+:[0-9]+ ([a-zA-Z]+) sshd\[[0-9]+\]: Invalid user ([a-zA-Z0-9_]+) from ([0-9\.]+)"
EXP2=""

sed -E "s/$EXP1/\1 \3 \4/;t;d" < ../secure

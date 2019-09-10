#!/usr/bin/env bash

WORK_PATH="$1"
START_PATH=$(pwd)

cd "$WORK_PATH"

for directory in ./*; do
 	cd "$directory"
  	sed -E "s/[A-Za-z]+ [0-9]+ [0-9]+ ([a-zA-Z]+) [a-zA-Z0-9. ]+/\1/;t;d" < "failed_login_data.txt" > "../${directory}_data.txt"
	cd .. 

done
#Combine the data from all machines into one file
for file in ./*_data.txt; do
  cat $file >> "combined.txt"
done

#Thanks to https://stackoverflow.com/questions/15984414/bash-script-count-unique-lines-in-file
#This handles making unique and getting counts
sort "combined.txt" | uniq -c | sort -bgr > "combined_data.txt"

#now we reformat them into js commands
sed -E "s/ +([0-9]+) ([a-zA-Z\-_0-9]+)/data\.addRow\(\['\2', \1\]\);/" < "combined_data.txt" > "combined_js.txt"

cd "$START_PATH"

./bin/wrap_contents.sh "${WORK_PATH}/combined_js.txt" "./html_components/username_dist" "${WORK_PATH}/username_dist.html"



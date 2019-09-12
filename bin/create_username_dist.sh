#!/usr/bin/env bash

WORK_PATH="$1"

#Do all the work in the scratch directory in a subshell
(cd "$WORK_PATH" || exit

for directory in ./*/; do
	#use a subshell to go into the directory
 	(cd "$directory" || exit
  	sed -E "s/[A-Za-z]+ [0-9]+ [0-9]+ ([a-zA-Z]+) [a-zA-Z0-9. ]+/\1/;t;d" < "failed_login_data.txt" > "../${directory}_data.txt")

done
#Combine the data from all machines into one file
for file in ./*_data.txt; do
  cat "$file" >> "combined.txt"
done

#Thanks to https://stackoverflow.com/questions/15984414/bash-script-count-unique-lines-in-file
#This handles making unique and getting counts
sort "combined.txt" | uniq -c >> "combined_data.txt"

#now we reformat them into js commands
sed -E "s/ +([0-9]+) ([a-zA-Z_\-]+)/data\.addRow\(\['\2', \1\]\);/;t;d" < "combined_data.txt" > "combined_js.txt")

./bin/wrap_contents.sh "${WORK_PATH}/combined_js.txt" "./html_components/username_dist" "${WORK_PATH}/username_dist.html"

#now remove our temp files, so that other scripts can have a clear workspace
rm "$WORK_PATH"combined_*.txt

#done

#!/usr/bin/env bash

WORK_PATH="$1"
ORIGIN_PATH=$(pwd)

#Do all the work in the scratch directory in a subshell
cd "$WORK_PATH" || exit

for directory in ./*; do
  #Check if it's actually a directory
  if [[ -d "$directory" ]]; then
   	cd "$directory" || exit
        #put those under a different file extension to not have later proccessing stages get picked up by even later scripts
    	sed -E "s/[A-Za-z]+ +[0-9]+ ([0-9]+) [a-zA-Z0-9_\-]+ [0-9. ]+/\1/;t;d" < "failed_login_data.txt" > "../${directory}_hours_data.src"
        #jump back up to the higher folder
        cd ../ || exit
  fi
done

#Combine the data from all machines into one file
for file in ./*hours_data.src; do
  cat "$file" >> "hours_combined.txt"
done

#Thanks to https://stackoverflow.com/questions/15984414/bash-script-count-unique-lines-in-file
#This handles making unique and getting counts
sort "hours_combined.txt" > "hours_sorted.txt"

# now we make them unique and get counts
uniq -c "hours_sorted.txt" > "hours_counts.txt"


#now we reformat them into js commands
sed -E "s/ +([0-9]+) ([0-9]+)[ a-zA-Z0-9]*/data\.addRow\(\['\2', \1\]\);/" < "hours_counts.txt" > "hours_js.txt"

cd "$ORIGIN_PATH" || exit

./bin/wrap_contents.sh "${WORK_PATH}/hours_js.txt" "./html_components/hours_dist" "${WORK_PATH}/hours_dist.html"

#!/usr/bin/env bash

WORK_PATH="$1"
ORIGIN_PATH=$(pwd)

#Do all the work in the scratch directory in a subshell
(cd "$WORK_PATH" || exit

for directory in ./*; do
  #Check if it's actually a directory
  if [[ -d "$directory" ]]; then
   	cd "$directory" || exit
    #put those under a different file extension to not have later proccessing stages get picked up by even later scripts
    	sed -E "s/[A-Za-z]+ [0-9]+ [0-9]+ ([a-zA-Z]+) [a-zA-Z0-9. ]+/\1/;t;d" < "failed_login_data.txt" > "../${directory}_username_data.src"
      #jump back up to the higher folder
      cd "$ORIGIN_PATH/$WORK_PATH"
  fi
done

done
#Combine the data from all machines into one file
for file in ./*username_data.txt; do
  cat "$file" >> "username_combined.txt"
done

#Thanks to https://stackoverflow.com/questions/15984414/bash-script-count-unique-lines-in-file
#This handles making unique and getting counts
sort "username_combined.txt" | uniq -c > "username_combined_data.txt"

#now we reformat them into js commands
sed -E "s/ +([0-9]+) ([a-zA-Z_\-]+)/data\.addRow\(\['\2', \1\]\);/;t;d" < "username_combined_data.txt" > "username_combined_js.txt")

./bin/wrap_contents.sh "${WORK_PATH}/username_combined_js.txt" "./html_components/username_dist" "${WORK_PATH}/username_dist.html"

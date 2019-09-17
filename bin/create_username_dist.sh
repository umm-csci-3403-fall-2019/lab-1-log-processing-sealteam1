#!/usr/bin/env bash

WORK_PATH="$1"
ORIGIN_PATH=$(pwd)

#move into to the work directory
cd "$WORK_PATH" || exit

for directory in ./*; do
	if [[ -d "$directory" ]]; then
		#Enter the directory
 		cd "$directory" || exit
  		sed -E "s/[A-Za-z]+ [0-9]+ [0-9]+ ([a-zA-Z]+) [a-zA-Z0-9. ]+/\1/;t;d" < "failed_login_data.txt" > "../${directory}_username_data.src"
		#jump back up to the higher folder
		cd "$ORIGIN_PATH/$WORK_PATH"
	fi
done

#Combine the data from all machines into one file
for file in ./*_username_data.src; do
  cat "$file" >> "username_combined.txt"
done

#Thanks to https://stackoverflow.com/questions/15984414/bash-script-count-unique-lines-in-file
#This handles making unique and getting counts
sort "username_combined.txt" | uniq -c >> "username_combined_data.txt"

#now we reformat them into js commands
sed -E "s/ +([0-9]+) ([a-zA-Z_\-]+)/data\.addRow\(\['\2', \1\]\);/;t;d" < "username_combined_data.txt" > "username_combined_js.txt"

#now we exit the work directory
cd "$ORIGIN_PATH"
#Now wrap our created files
./bin/wrap_contents.sh "${WORK_PATH}/username_combined_js.txt" "./html_components/username_dist" "${WORK_PATH}/username_dist.html"

#now remove our temp files, so that other scripts can have a clear workspace
rm "$WORK_PATH"/*.txt

#done

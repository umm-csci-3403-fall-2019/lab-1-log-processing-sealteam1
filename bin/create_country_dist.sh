#!/usr/bin/env bash

WORK_PATH="$1"
ORIGIN_PATH=$(pwd)

cd "$WORK_PATH" || exit

for directory in ./*; do
  #Check if it's actually a directory
  if [[ -d "$directory" ]]; then
   	cd "$directory" || exit
    #put those under a different file extension to not have later proccessing stages get picked up by even later scripts
    	sed -E "s/[A-Za-z]+ [0-9]+ [0-9]+ [A-Za-z0-9_\-]+ ([0-9\.]+) port [0-9]+ ssh2/\1/;t;d" < "failed_login_data.txt" > "../${directory}_country_data.src"
      #jump back up to the higher folder
      cd ../ || exit
  fi
done

#Combine the data from all machines into one file
for file in ./*country_data.src; do
  cat "$file" >> "country_combined.txt"
done

#Thanks to https://stackoverflow.com/questions/15984414/bash-script-count-unique-lines-in-file
#This handles making unique and getting counts
sort "country_combined.txt" > "country_sorted.txt"

#now to convert to country codes
join "country_sorted.txt" "$ORIGIN_PATH/etc/country_IP_map.txt" > "country_codes.txt"

# now we make them unique and get counts
uniq -c "country_codes.txt" > "country_counts.txt"


#now we reformat them into js commands
sed -E "s/ +([0-9]+) [0-9\.]+ ([A-Z]{2})/data\.addRow\(\['\2', \1\]\);/" < "country_counts.txt" > "country_js.txt"

cd "$ORIGIN_PATH" || exit

./bin/wrap_contents.sh "${WORK_PATH}/country_js.txt" "./html_components/country_dist" "${WORK_PATH}/country_dist.html"

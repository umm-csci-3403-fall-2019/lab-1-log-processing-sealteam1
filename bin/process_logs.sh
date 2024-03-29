#!/usr/bin/env bash

#https://stackoverflow.com/questions/4632028/how-to-create-a-temporary-directory

#Make a scratch working directory safely
WORKSPACE=$(mktemp -d)
#WORKSPACE=$(pwd)/tastebed

if [ ! -e "$WORKSPACE" ]; then
  echo "could not create temp directory"
  exit 1
fi

trap "exit 1"           HUP INT PIPE QUIT TERM
trap 'rm -rf "$TMPDIR"' EXIT

#record the location of the scripts, for access from scratch directory
SCRIPT_PATH=$(pwd)/bin
ORIGIN_PATH=$(pwd)

for ARCHIVE in "$@"
do
  #create the path to the scratch directory and the relevant subfolder
  PRESENT_DIR=${WORKSPACE}/$(basename "$ARCHIVE" _secure.tgz)
  #make the relevant subfolder
  mkdir "$PRESENT_DIR"
  #extract the data from the working directory into the scratch subfolder
  tar -xzf "$ARCHIVE" -C "$PRESENT_DIR"
  (
    #In a subshell, go do process_client_logs
    cd "$PRESENT_DIR"
    "$SCRIPT_PATH"/process_client_logs.sh
  )
done


#new subshell for commands that run after
(
#run create_username_dist.sh
"$SCRIPT_PATH/"create_username_dist.sh "$WORKSPACE"

#other create_ scripts go here
"$SCRIPT_PATH/"create_country_dist.sh "$WORKSPACE"

"$SCRIPT_PATH/"create_hours_dist.sh "$WORKSPACE"
#assemble_report goes here
"$SCRIPT_PATH/"assemble_report.sh "$WORKSPACE"


mv "${WORKSPACE}/failed_login_summary.html" "$ORIGIN_PATH/failed_login_summary.html"
)
#All done, and so the script triggers it's own self destruct clause automatically

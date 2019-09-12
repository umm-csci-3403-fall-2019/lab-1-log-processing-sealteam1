#!/usr/bin/env bash

DIST_DIR="$1"
WKDIR=$(pwd)
SCRIPT_PATH="$WKDIR"/bin
(cd "$DIST_DIR" || exit
cat "country_dist.html" "hours_dist.html" "username_dist.html" > "total_dist.html"

"$SCRIPT_PATH"/wrap_contents.sh "total_dist.html" "$WKDIR/html_components/summary_plots" "failed_login_summary.html"
)

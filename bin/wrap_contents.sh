#!/usr/bin/env bash

#Charlot Shaw
CONTENTS_FILE="$1"
WRAPPER_NAME="$2"
OUTPUT_NAME="$3"

#create our output file
touch "$OUTPUT_NAME"

#make the header and footer names
#string concatenation is a two step process it seems
HEADER_NAME="$WRAPPER_NAME"
HEADER_NAME+="_header.html"

FOOTER_NAME="$WRAPPER_NAME"
FOOTER_NAME+="_footer.html"


#append the contents of the header, then the middle bit, then the footer



cat "$HEADER_NAME" "$CONTENTS_FILE" "$FOOTER_NAME" >> "$OUTPUT_NAME"


#done

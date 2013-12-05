#!/bin/sh
set -e

if [ ! "$1" ]; then
    exec scanadf --source "ADF Front" --threshold 128 -d fujitsu -S "$0"
    #exec scanadf --source "ADF Front" --threshold 128 -d fujitsu --page-height 355.6 -y 355.6 -S "$0"
    #exec scanadf --source "ADF Duplex" --threshold 128 -d fujitsu -S "$0"
fi

output_dir=~/net/doc/Scanned
if [ ! -d "$output_dir" ]; then
    output_dir=~/doc/scanned
fi

# $1 - the image filename
# $SCAN_RES - the image resolution (in DPI)
# $SCAN_WIDTH - the image width (in pixels)
# $SCAN_HEIGHT - the image height (in pixels)
# $SCAN_DEPTH - the image bit-depth (in bits)
# $SCAN_FORMAT - a string representing the image format (e.g. gray, g42d, text, etc)
# $SCAN_FORMAT_ID - the numeric image format identifier

mkdir -p "${output_dir}"
unpaper --overwrite --pre-border 50,0,50,100 -dn left,top,right,bottom "$1" "up-$1"
rm "$1"
filename="${output_dir}/$(date +%s)-$1.djvu"
cjb2 -dpi "$SCAN_RES" -clean -lossy "up-$1" "$filename"
rm "up-$1"
echo "Stored: $filename"

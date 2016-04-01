#!/bin/sh
set -e

if [ "$SCAN_RES" ]; then
	# $1 - the image filename
	# $SCAN_RES - the image resolution (in DPI)
	# $SCAN_WIDTH - the image width (in pixels)
	# $SCAN_HEIGHT - the image height (in pixels)
	# $SCAN_DEPTH - the image bit-depth (in bits)
	# $SCAN_FORMAT - a string representing the image format (e.g. gray, g42d, text, etc)
	# $SCAN_FORMAT_ID - the numeric image format identifier

	#unpaper --overwrite --pre-border 50,0,50,100 -dn left,top,right,bottom "$1" "up-$1"
	cjb2 -dpi "$SCAN_RES" -clean -lossy "$1" "$1.djvu"
	rm "$1"
	exit
fi

if [ "$1" = "--front" ]; then
	shift
	source="ADF Front"
else
	source="ADF Duplex"
fi

if [ "$1" = "--legal" ]; then
	shift
	size="--page-width 216 -x 216 --page-height 356 -y 356"
else
	size=""
fi

t="$(mktemp -d)"
scanadf $size --source "$source" --threshold 128 --device-name fujitsu --scan-script "$0" --script-wait --output-file "$t/page-%04d"

output_dir=~/net/doc/Scanned
if [ ! -d "$output_dir" ]; then
	output_dir=~/doc/scanned
fi
mkdir -p "${output_dir}"
name="$(date -u +"%Y%m%d-%H%M%S")-$(echo $@ | tr 'A-Z ' 'a-z-')"
djvm -c "${output_dir}/${name}.djvu" "$t"/page-*.djvu
echo "${output_dir}/${name}.djvu"
ddjvu --format=pdf "${output_dir}/${name}.djvu" "${TEMP:-/tmp}/${name}.pdf"
echo "${TEMP:-/tmp}/${name}.pdf"
rm -rf "$t"

#!/bin/bash

TARGETS=$@
OUTPUT="scans"
OPTIONS="-v -T4 -F -sV"
date=`date +%F`

if [ ! -d $OUTPUT ]; then
	mkdir $OUTPUT
fi

cd $OUTPUT
nmap $OPTIONS $TARGETS -oX scan-$date.xml > /dev/null
../nmap2csv scan-$date.xml >> scan-$date.csv
if [ -e scan-prev.xml ]; then
        ndiff scan-prev.xml scan-$date.xml > diff-$date
fi
ln -sf scan-$date.xml scan-prev.xml
ln -sf scan-$date.csv scan-prev.csv

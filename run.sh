#!/bin/bash

TARGETS=$@
OUTPUT="scans"
OPTIONS="-v -T4 -F -sV"
date=`date +%F`

if [ ! -d $OUTPUT ]; then
	mkdir $OUTPUT
fi

cd $OUTPUT
nmap $OPTIONS $TARGETS -oA scan-$date > /dev/null
xsltproc scan-$date.xml -o scan-$date.html
if [ -e scan-prev.xml ]; then
        ndiff --xml scan-prev.xml scan-$date.xml > diff-$date.xml
	echo "*** NDIFF RESULTS ***"
        cat diff-$date
        echo
	
fi
echo "*** NMAP RESULTS ***"
cat scan-$date.nmap
ln -sf scan-$date.xml scan-prev.xml
ln -sf scan-$date.html scan-prev.html

#!/bin/bash
. config/config.cfg


date=$_date
SCAN_OUTPUT=$_SCAN_OUTPUT
ROOT=$_ROOT
OUTPUT=$_OUTPUT
OPTIONS=$_OPTIONS

echo "$date $SCAN_OUTPUT $ROOT $OUTPUT $OPTIONS"

if [ ! -d "output" ]; then
  mkdir "output"
fi

if [ ! -d "$SCAN_OUTPUT" ]; then
  mkdir $SCAN_OUTPUT
fi

if [ "$2" = "fast" ]; then
  OPTIONS="$OPTIONS -T4"
fi

cd $SCAN_OUTPUT
while read line
do
  echo $line
  IP=${line%/*}
  nmap $OPTIONS $line -oX scan-$date-$IP.xml
  $ROOT/nmap2csv scan-$date-$IP.xml > scan-$date-$IP.csv
  if [ -e scan-prev-$IP.xml ]; then
    ndiff scan-prev-$IP.xml scan-$date-$IP.xml > diff-$date-$IP.xml
  fi
  ln -sf scan-$date-$IP.xml scan-prev-$IP.xml
  ln -sf scan-$date-$IP.csv scan-prev-$IP.csv
done < $ROOT/$1

cd $ROOT

files=($SCAN_OUTPUT/scan-$date-*.csv)

if [ ! -d $OUTPUT ]; then
  mkdir $OUTPUT
fi

cat ${files[0]} > $OUTPUT/scan-$date.csv

for (( c=1; c<${#files[@]};c++ ))
do
  tail -n+2 ${files[$i]} >> $OUTPUT/scan-$date.csv
done
if [ -e $OUTPUT/scan-prev.csv ]; then
  diff $OUTPUT/scan-prev.csv $OUTPUT/scan-$date.csv > $OUTPUT/diff-$date.csv
fi

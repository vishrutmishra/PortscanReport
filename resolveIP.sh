#!/bin/bash
max_range=`cat config/max_range.cfg`
fullIP=$1

function getIndex {
  echo `expr index $1 '/'`
}
index=`getIndex $fullIP`

function getIP {
  echo ${1:0:$[index-1]}
}
ip=`getIP $fullIP`

function getRange {
  local range2=$[32-${1:$index}]
  echo "2^$range2" | bc
}
range=`getRange $fullIP`

function getI {
  echo "$1/$2" | bc
}
i=`getI $range $max_range`

function ip2bin { 
  for i in $(echo $1 | tr '.' ' '); do echo "obase=2 ; $i" | bc; done | awk '{printf "%.08d", $1}' | cut -c2-
}
bin=`ip2bin $ip`

function bin2dec {
  echo $((2#$1))
}
dec=`bin2dec $bin`

function dec2bin {
  echo "obase=2;$1" | bc
}
bin2=`dec2bin $dec`

function bin2ipbin {
  local length=${#1}
  local ip=""
  ip="$ip${1:0:$[length-24]}"
  ip="$ip.${1:$[length-24]:8}"
  ip="$ip.${1:$[length-16]:8}"
  ip="$ip.${1:$[length-8]}"
  echo $ip
}
ipbin=`bin2ipbin $bin2`

function ipbin2ip {
for i in $(echo $1 | tr '.' ' '); do echo $((2#$i)) | bc; done
}
ip2=`ipbin2ip $ipbin`
ip2=`echo $ip2 | tr ' ' '.'`

echo $ip2-$max_range


function test {
  local result=""
  result="$result max_range:$max_range"
  result="$result fullIP:$fullIP"
  result="$result index:$index"
  result="$result i:$i"
  result="$result range:$range"
  result="$result bin:$bin"
  result="$result dec:$dec"
  result="$result bin2:$bin2"
  result="$result ipbin:$ipbin"
  result="$result ip2:$ip2"
  echo $result
}
#test

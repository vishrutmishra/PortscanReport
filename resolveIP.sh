#!/bin/bash
. config/config.cfg

max_range=$_max_range
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

function bin2ipbin {
  local length=${#1}
  local ip=""
  ip="$ip${1:0:$[length-24]}"
  ip="$ip.${1:$[length-24]:8}"
  ip="$ip.${1:$[length-16]:8}"
  ip="$ip.${1:$[length-8]}"
  echo $ip
}

function ipbin2ip {
  local ip=""
  ip=`for i in $(echo $1 | tr '.' ' '); do echo $((2#$i)) | bc; done`
  ip=`echo $ip | tr ' ' '.'`
  echo $ip
}

function getMaxDec {
  echo $[$1 + $2]
}
maxdec=`getMaxDec $dec $range`

function getResult {
  local result=""
  local bin=""
  local ipbin=""
  local ip=""
  while [ $dec -lt $maxdec ]
  do
    bin=`dec2bin $dec`
    ipbin=`bin2ipbin $bin`
    ip=`ipbin2ip $ipbin`
    result="$result $ip-$max_range"
    dec=$[dec+max_range]
  done
  echo "$result"
}
result=`getResult`
echo $result | tr ' ' '\n'


function test {
  local result=""
  result="$result max_range:$max_range"
  result="$result fullIP:$fullIP"
  result="$result index:$index"
  result="$result i:$i"
  result="$result range:$range"
  result="$result bin:$bin"
  result="$result dec:$dec"
  result="$result maxdec:$maxdec"
  echo $result
}
#test

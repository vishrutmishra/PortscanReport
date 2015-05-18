#!/bin/sh

function ip2dec { 
  for i in $(echo $1 | tr '.' ' '); do echo "obase=2 ; $i" | bc; done | awk '{printf "%08d", $1}' | cut -c2- 
}



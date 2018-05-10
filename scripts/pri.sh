#!/bin/bash

c=1;
p=2;
d=2;
while (( $c <= $1 )); do if (( $p % $d == 0)); then (( $p == $d )) && printf "$p es primo\n"; let c=$c+1; d=2; let p=$p+1; else let d=$d+1; fi done

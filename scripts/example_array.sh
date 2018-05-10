#!/usr/bin/env bash
vector=()
vector[0]="2";
vector[1]="0";
vector[2]="6";
vector[3]="9";
vector[4]="0";
vector[5]="8";
vector[6]="11";
vector[7]="10";
vector[8]="5";
vector[9]="0";

for (( i = 0 ; i < ${#vector[@]} ; i++ )) do 
	[[ ${vector[$i]} = 0 ]] && printf "pos %s $i: ${vector[$i]}\\n" 
done

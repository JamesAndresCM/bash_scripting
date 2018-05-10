#!/bin/bash

n=20;
c=1;
p=2;
d=2;
while (( $c <= $n )) 
do
    if (($p % $d == 0))
    then 
      	if (($p == $d))
		then 
         		echo $p
        	 let c=$c+1
     	fi 
      		d=2;
      		let p=$p+1
	else
		let d=$d+1;
    	fi

done

#!/bin/bash  

largo=${largo:-20}

while read dev a b c used mp; do
	if [[ -b $dev ]]; then
		used=${used%\%}
		hasta=$(($largo*$used/100))
		echo -ne "$dev $mp ["
		for ((i = 1; i <= $largo; ++i)); do
			(( $i <= $hasta )) && echo -n "*" || echo -n "="
		done
		echo "] ${used}%"
	fi
done < <(df)



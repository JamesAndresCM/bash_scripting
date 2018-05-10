#!/bin/bash

n=1
while read line; do
	eval LINE$n=\"\$line\"
	n=$((n+1))
done < "$1"

n=$((n-1))
echo "PRIMERA LINEA: " $LINE1
eval echo "ULTIMA LINEA: " \$LINE$n

#!/bin/bash
printf "Enter number decimal : \\n"
read input
resto=0
        while [ $input -ne 0 ]; do
          resto=$[$input % 2]
          c=$[$c+1]
          input=$[$input / 2]
          let "nn=$nn+($resto*(10**($c-1)))"
         done
echo "Bin : $nn"

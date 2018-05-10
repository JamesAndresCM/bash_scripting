#!/bin/bash

text_file="/tmp/exist.txt"

printf "#Paste text and enter %s (save in $text_file)\\n"
echo -e  "Entry text : " 
text=$(sed '/^$/q')

printf "%s $text\\n" >> $text_file


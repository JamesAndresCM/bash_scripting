#!/bin/bash

city=$(curl -s ipinfo.io/"$(dig +short myip.opendns.com @resolver1.opendns.com)" | grep -w \"city\" | awk '{print $2}'| sed -e 's/"//g;s/,//g'); curl -s wttr.in/"$city"




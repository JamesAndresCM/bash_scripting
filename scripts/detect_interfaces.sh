#!/bin/bash


ARGS=/sys/class/net/*/operstate


echo -e "\n******Interfaces******"

for i in $ARGS; 
do 
	echo -e "\nNombre de Interfaz" && ls $i | sed -e 's/^.\{15\}//' -e 's/.\{10\}$//' && echo "status" && cat $i;
	if [[ $(cat $i) == "up" ]]; then

	echo "$i" | sed -e 's/^.\{15\}//' -e 's/.\{10\}$//' > /tmp/interfaz
		
		TEMP=/tmp/interfaz
	
	echo -e "\nIPV4 : " $(ip -4 add show dev $(cat $TEMP) | grep inet | awk '{print $2}' | cut -d/ -f1)
	echo -e "IPV6 : " $(ip -6 add show dev $(cat $TEMP) | grep inet6 | awk '{print $2}' | cut -d/ -f1) 
	echo -e "MAC  :  " $(ip link show dev $(cat $TEMP) | grep link | awk '{print $2}')
	
				echo -e "\nActualmente en uso" $(cat $TEMP)
		
				rm $TEMP
		fi

done

echo -e "\n******Interfaces******" 


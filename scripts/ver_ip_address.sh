#!/usr/bin/env bash

file_ip="/tmp/file"
package=google-chrome

die(){
                echo >&2 "$@";
        }
        if grep -P "(([1-9]\d{0,2})\.){3}(?2)" <<< "$1"; then
                curl ipinfo.io/"$1" 2> /dev/null | grep -v -e "[{}]" -e "ip" > $file_ip
		cat /tmp/file
		coordenada=$(grep "loc" $file_ip | awk '{print $2}' | tr -s "," " " |tr -d '""')
		read -rep $'Ver localizacion en google maps ? Y/N: \n' op
		case $op in
        		[yY][eE][sS]|[yY]) 
            		if which $package &> /dev/null; then
				touch $file_ip;
				google-chrome https://www.google.cl/maps/place/"$coordenada"
				rm -r $file_ip;
			else
				printf "chrome no esta instalado...\n"
			fi
            		;;
       		 *)
            		printf "saliendo...\n"
            	;;
    esac

        else
                die "ingrese una ip valida! no $1 ** uso : infoip 181.XXX.XXX.XXX **"

        fi


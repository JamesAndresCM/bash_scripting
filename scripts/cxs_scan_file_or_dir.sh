#!/usr/bin/env bash

CXS="/usr/sbin/cxs"
SCAN_TMP="/tmp/log_cxs_files.scan"

[[ $EUID -ne 0 ]] && printf "Error! Se deben tener permisos de root para ejecutar este script\n" && exit 1

die(){
 	echo >&2 "$@";
 	exit 1
}

usage(){
	printf "Uso :  bash $0 nombre_archivo o nombre_directorio\n"
	exit 1	
}


if [[ "$#" -eq 1 ]]; then 
	if  [[ -d $1 || -f $1 ]]; then 
	    if which cxs &> /dev/null; then
		/etc/init.d/cxswatch status &> /dev/null
		if (( $? == 0 )); then
			size=$(du -bsh $1 | awk '{print $2, $1}')
			printf "Por favor Espere mientras se realiza el SCAN\n"
			printf "Tamaño $size\n"

			printf "\n**********SCAN CXS $1**********\n\n"
			$CXS  --report $SCAN_TMP --exploitscan --virusscan --sversionscan --bayes --options  mMOLfSGchexdnwZRrD \
			--voptions mfuhexT --quiet $1 --html --nofallback
			grep -B 1 -E "(Known exploit | virus)" $SCAN_TMP
			printf "\n"
			grep -A 9 "SCAN SUMM" $SCAN_TMP
			rm $SCAN_TMP
		else
			printf "Error! Cxswatch no esta en ejecucion ( inicielo con : /etc/init.d/cxswatch start )\n" && exit 1
		fi

	     else
		 printf "Error! Cxs no esta instalado saliendo...\n" && exit 1
	    fi

	else 
		printf "Error! $1 no es un archivo o directorio\n" && exit 1
	fi
elif [[ -z "$1" ]]; then
	usage
else
	die "Error solo se permite 1 argumento!, no $#"
fi

#!/usr/bin/env bash

D=$(date +%H:%M:%S)

[[ $# -ne 1 ]] && echo "Debes ingresar un argumento... (opciones -h , -m , -s, -ms)" && exit 1  

echo -e "Hora Actual\n"$D 
case $1 in 	
	-h) while [[ -z $hora ]]; do
		read -rep $'Ingresa tiempo en horas:\n' hora  && clear
		case $hora in
			*[!0-9]*)
			hora= ;;
		esac
			sleep "$hora"h >& /dev/null;
		done;;
	-m)  while [[ -z $min ]]; do
		read -rep $'Ingresa tiempo en minutos:\n' min && clear
		case $min in
			*[!0-9]*)
			min= ;;
		esac
			sleep "$min"m >& /dev/null;
		done;; 
	-s) while [[ -z $seg ]]; do
	       read -rep $'Ingresa tiempo en segundos:\n' seg && clear
       		case $seg in
	 		*[!0-9]*)
			seg= ;;
		esac
			echo "saliendo despues de $seg ...segundos";
			sleep "$seg"s >& /dev/null;
		done;;		
	-ms) while [[ -z $min ]]; do
	       read -rep $'Ingresa tiempo en Minutos:\n' min && clear
       		case $min in
	 		*[!0-9]*)
			min= ;;
		esac
			
		done
		while [[ -z $seg ]]; do
        	 read -rep "Ingresa tiempo en Segundos: " seg && clear
        	  case $seg in
                       *[!0-9]*)
                        seg= ;;
        	esac
			echo "Hacer Accion despues de $min minutos y $seg ...segundos";
			sleep "$min"m "$seg"s >& /dev/null;
		done;;
	
	 *)echo "opcion desconocida uso : script -h || -m || -s || -ms (horas,segundos, minutos)"
	esac


#indicamos que el interprete a usar sera bash
#!/usr/bin/env bash

#depurar errores
set -x 

#declaramos tres variables para los 3 numeros
declare num1=
declare num2=
declare num3=


#ciclo while con la condicional ( -z para no permitir valores nulos)
#con read pedimos el ingreso del numero1
#luego se comprueba que el valor sea de tipo numerico en medio del case
while [[ -z $num1 ]]; do
	read -p "Numero 1: " num1
	case $num1 in
		*[!0-9]*)
			num1= ;;
	esac
done

while [[ -z $num2 ]]; do
	read -p "Numero 2: " num2
	case $num2 in
		*[!0-9]*)
			num2= ;;
	esac
done

while [[ -z $num3 ]]; do
	read -p "Numero 3: " num3
	case $num3 in
		*[!0-9]*)
			num3= ;;
	esac
done

#asignamos a la variable sum , la suma de los 3 numeros
sum=$((num1+num2+num3))

#luego con expr calculamos el promedio de los numeros
printf "\nEL promedio es : $(expr $sum / 3 ) \n" 


#comparaciones logicas mediante test (ciclo if mas corto) 
#gt = greater than = mayor que
#lt = less than = menor que
[[ $num1 -gt $num2 ]] && [[ $num1 -gt $num3 ]] && printf "El numero mayor es: $num1\n"

[[ $num2 -gt $num1 ]] && [[ $num2 -gt $num3 ]] && printf "El numero mayor es: $num2\n"

[[ $num3 -gt $num1 ]] && [[ $num3 -gt $num2 ]] && printf "El numero mayor es: $num3\n"

[[ $num1 -lt $num2 ]] && [[ $num1 -lt $num3 ]] && printf "El numero menor es: $num1\n"

[[ $num2 -lt $num1 ]] && [[ $num2 -lt $num3 ]] && printf "El numero menor es: $num2\n"

[[ $num3 -lt $num1 ]] && [[ $num3 -lt $num2 ]] && printf "El numero menor es: $num3\n"


printf "\nOrdenados menor a mayor de manera ascendente\n"
#con la instruccion sort ordenamos los valores
printf "${num1}\n${num2}\n${num3}\n" | sort -n

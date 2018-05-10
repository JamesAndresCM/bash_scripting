#!/bin/bash


function InstallDNS() {
	yum install -y bind bind-chroot bind-utils
}


function validar_ip() {
   local  ip=$validaip
   local  stat=1
   if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]];
    then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255  && ${ip[2]} -le 255 &&  ${ip[3]} -le 255 ]]
        stat=$?
   fi
return $stat
} 


function ConfigurarDns() {

	echo "Ingrese IP para el servidor DNS"
		read "validaip"

			if validar_ip validaip;
   				then
				
				sed -i 's/listen-on port 53 { 127.0.0.1; };/'"listen-on port 53 { 127.0.0.1; $validaip;};"'/' /etc/named.conf
				sed -i 's/allow-query     { localhost; };/allow-query     { any; };/' /etc/named.conf
				
   		else
   			echo "Error esto no es una IP";
	fi


	echo "Ingresa nombre de host : "
		read -r nomhost
	sed -i '2d' /etc/sysconfig/network

	echo "HOSTNAME=""$nomhost" >> /etc/sysconfig/network
	hostname "$nomhost"
	/etc/init.d/network restart

	echo "Ingrese nombre del dominio eje (example.com) : "
		read -r nomdom

	echo "$validaip" "$nomhost"."$nomdom"   "$nomhost" >> /etc/hosts


nombre=$(hostname -f)
	
	echo "Ingrese Nombre archivo Zona Directa (default zonadirecta) : "
		read -r zd
	
		if [ "$zd" == "" ] > /dev/null 2>&1; then
			echo "sin cambios"
		else
			touch /var/named/$zd
	fi
			{	
				echo ""'$ORIGIN'" "$nomdom"." 
				echo '' 
				echo ""'$TTL'" 3D" 
				echo '' 
				echo ""@	SOA     " "$nombre"." "root."$nomdom"." "(12 4h 1h 1w 1h)" 	
				echo '' 
				echo  "@	IN	NS	""$nombre"."" 
				echo '' 
				echo  "@      IN	A"           "$validaip" 
				echo '' 
				echo  "www      IN	A"           "$validaip" 
				echo ''
                                echo  "mail	IN	A"           "$validaip"
				echo ''
				echo  "ftp	IN	CNAME"	     "$validaip"	
				echo '' 
				echo "$nomhost" "IN    A"           "$validaip" 
			}>> /var/named/"$zd"
			
			{
				echo "zone" '"'$nomdom'"'" {"
				echo	"type master;"	      	
				echo    "file" '"'$zd'"'";"   
				echo "};"
			} >> /etc/named.conf

	echo "Ingrese Nombre Zona Inversa : (Default zonainversa)"
		read -r zi

			if [[ "$zi" == "" ]] > /dev/null 2>&1; then
				echo "nombre por defecto"
			else
				touch /var/named/$zi
		fi

	oct1=$(echo $validaip | cut -d. -f1)
	oct2=$(echo $validaip | cut -d. -f2).
	oct3=$(echo $validaip | cut -d. -f3).
	oct4=$(echo $validaip | cut -d. -f4)


			{
				echo ""'$ORIGIN'" "$oct3$oct2$oct1.in-addr.arpa." " 
				echo '' 
				echo ""'$TTL'" 3D" 
				echo '' 
				echo ""@        SOA     " "$nombre"." "root."$nomdom"." "(12 4h 1h 1w 1h)"
				echo ''
                                echo "$nomhost" "IN    A"           "$validaip" 
				echo '' 
				echo  "@        IN	NS	""$nombre"."" 
				echo '' 
				echo  "$oct4"  "IN	PTR	""$nombre"."" 
			} >> /var/named/"$zi"
	



			{
				echo "zone" '"'$oct3$oct2$oct1.in-addr.arpa'"'" {"
				echo	"type master;"	      	
				echo    "file" '"'$zi'"'";"   
				echo "};"
			} >> /etc/named.conf

check=$(yum list installed | grep wget)			
		
		if [[ $check != "" ]] > /dev/null 2>&1; then
		    wget -N http://www.internic.net/domain/named.root -O /var/named/named.ca
	else
		yum -y install wget && wget -N http://www.internic.net/domain/named.root -O /var/named/named.ca
fi
			chown root:named /var/named/named.ca
			chmod 640 /var/named/named.ca			
			iptables -A INPUT -p udp -m udp --dport 53 -j ACCEPT
			/sbin/service iptables save
			service named start
			
			echo "Cargar named al iniciar el sistema? Y/N "
        		read -r res

        		if [[ "$res" == "Y" || "$res" == "y" ]] > /dev/null 2>&1; then
                		chkconfig named on
        	else
        		echo "no se arrancara el servicio al iniciar.."
        fi

			
}

			while [ ${exit:-n} != "y" ] > /dev/null 2>&1; do

				echo "*********************************************************"
				echo "1-Instalar paquetes necesarios para el servidor DNS"
				echo "2-configuracion principal DNS,Zona Directa,Zona Inversa"
				echo "3-Salir"
				echo -e "\n*********************************************************"

				read -p "Ingresar opcion: " op

					case $op in

						1)InstallDNS;;

						2)ConfigurarDns;;

						3) read -p "desea salir? y/n : " exit;;

					*)echo -e "\e[31mopcion no valida ingresa una opcion valida\e[0m"

				esac

			done

		exit


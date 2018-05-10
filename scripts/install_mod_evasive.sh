#!/usr/bin/env bash

#set -x

src="/usr/local/src/"
mod_e="mod_evasive/mod_evasive"
apache_conf="/usr/local/apache/conf/httpd.conf"
mod_evasive_conf="/usr/local/apache/conf/includes/mod_evasive.conf"
dir_log="/var/log/httpd/mod_evasive"
apache="/etc/init.d/httpd"
mod_evasive="/usr/local/apache/modules/mod_evasive24.so"
package_mod_evasive="http://www.zdziarski.com/blog/wp-content/uploads/2010/02/mod_evasive_1.10.1.tar.gz"

if [[ ! -e $mod_evasive ]]; then
	wget -qO- $package_mod_evasive | tar xz -C $src
	cp ${src}${mod_e}{20,24}.c; sed -i 's/remote_ip/client_ip/g' ${src}${mod_e}24.c
	/usr/local/apache/bin/apxs -i -a -c ${src}${mod_e}24.c &> /dev/null
	sed -i '/evasive20_module/ a Include "'${mod_evasive_conf}'"' $apache_conf

cat > $mod_evasive_conf <<'EOL'
<IfModule mod_evasive24.c>
	DOSHashTableSize    3097
	DOSPageCount        20
	DOSSiteCount        100
	DOSPageInterval     1
	DOSSiteInterval     1
	DOSBlockingPeriod   300
	#DOSEmailNotify     domain@example.com
	DOSLogDir           "/var/log/httpd/mod_evasive/"
	DOSWhitelist 127.0.0.1
	DOSWhitelist 127.0.0.*
</IfModule>
EOL

	[[ ! -d $dir_log ]] && mkdir -p $dir_log; chown -R root:nobody $dir_log; chmod 0770 $dir_log; $apache restart || $apache restart
	httpd -M | grep "evasive" &> /dev/null; (( $? == 0 )) && printf "el modulo mod_evasive fue instalado\n" || printf "Error mod_evasive no fue instalado"
else
	printf "saliendo mod_evasive esta instalado...\n" && exit 1
fi

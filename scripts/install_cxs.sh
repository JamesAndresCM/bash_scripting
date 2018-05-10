#!/usr/bin/env bash

#set -x

ROOT_PATH="/root"

WGET="/usr/bin/wget"
YUM="/usr/bin/yum"
TAR="/bin/tar"
CAT="/bin/cat"
TOUCH="/bin/touch"
CHMOD="/bin/chmod"
PERL="/usr/bin/perl"
INIT="/etc/init.d"

CXS_DOWNLOAD="https://download.configserver.com/cxsinstaller.tgz"
CXS="/usr/sbin/cxs"
CXSFTP_FILE="/etc/cxs/cxsftp.sh"
CXSWATCH_FILE="/etc/cxs/cxswatch.sh"
CXSDAILY_FILE="/etc/cxs/cxsdaily.sh"
CXS_QUARANTINE="/etc/cxs/quarantine"
CXSIGNORE_FILE="/etc/cxs/cxs.ignore.example"


PURE_FTPD_CONF="/etc/pure-ftpd.conf"

RULE_MOD_SEC="https://download.configserver.com/waf/meta_configserver.yaml"


install_wget(){
 if which $WGET &> /dev/null; then
         printf "$WGET ya esta instalado se continuara el proceso de instalacion\n"
         sleep 2
 else
        while [[ -z $op || $op =~ [^"YynN"] ]]; do
                read  -p "Wget no instalado instalar Y/N? "  op
                clear
        done
[[ $op =~ [^"Yy"] ]] && printf "saliendo sin instalar wget.\n" break && exit 0 || $YUM install $WGET  -y -q 2> /dev/null
                if (( $? == 0 )); then
                        printf "wget fue instalado correctamente\n"
                fi
fi
}


install_cxs(){

	if which $CXS &> /dev/null; then
                printf "$CXS ya esta instalado saliendo...\n" exit 0
        else
                printf "***CXS sera instalado***\n"
                sleep 2
                cd $ROOT_PATH
                $WGET -qO- $CXS_DOWNLOAD | $TAR xvz &> /dev/null;
                if (( $? == 0 )); then
                        printf "cxs ha sido descargado correctamente\n"
                else
                        printf "error al descargar el archivo cxs...\n" exit 0
                fi

        fi
}


configure_cxs(){
	if [[ -e $CXSFTP_FILE ]]; then
		mv $CXSFTP_FILE{,.backup}		
		$TOUCH $CXSFTP_FILE; $CHMOD 0700 $CXSFTP_FILE

$CAT > $CXSFTP_FILE <<'EOL'
#!/bin/sh
/usr/sbin/cxs --quiet --ftp --smtp --mail root "$1"		
EOL

	fi

	if [[ -e $CXSWATCH_FILE ]]; then
		mv $CXSWATCH_FILE{,.backup}
		$TOUCH $CXSWATCH_FILE; $CHMOD 0700 $CXSWATCH_FILE
	
$CAT > $CXSWATCH_FILE <<'EOL'
#!/bin/sh
/usr/sbin/cxs --options -wW --Wstart --allusers --www --smtp --ignore /etc/cxs/cxs.ignore --log /var/log/cxs.log --Wmaxchild 3 --Wloglevel 0 --Wsleep 3 --filemax 0 --Wrateignore 300
EOL
	fi

	if [[ -e $CXSDAILY_FILE ]]; then
		mv $CXSDAILY_FILE{,.backup}
		$TOUCH $CXSDAILY_FILE; $CHMOD 0700 $CXSDAILY_FILE
$CAT > $CXSDAILY_FILE <<'EOL'
#!/bin/sh
/usr/sbin/cxs --upgrade --quiet
EOL
	fi

	if [[ -e $CXSIGNORE_FILE ]]; then
		cp $CXSIGNORE_FILE /etc/cxs/cxs.ignore	
	fi

	printf "***check clamv***\n"
			
	/scripts/update_local_rpm_versions --edit target_settings.clamav installed		
	/scripts/check_cpanel_rpms --fix --targets=clamav

}

configure_pure_ftpd(){

	if [[ -e $PURE_FTPD_CONF ]]; then
		cp $PURE_FTPD_CONF{,.backup}
		if grep "#CallUploadScript yes" $PURE_FTPD_CONF &> /dev/null; then 
			sed -i -E 's/#CallUploadScript (yes|no)/CallUploadScript yes/' $PURE_FTPD_CONF; 
		fi 
	fi

	$INIT/pure-ftpd restart
	$INIT/pure-uploadscript restart
}


mod_security_rule(){
	/scripts/modsec_vendor add $RULE_MOD_SEC
	/scripts/modsec_vendor enable configserver
	$INIT/apache restart
}


ping -c 1 google.cl &> /dev/null
        if (( $? == 0 )); then
                if (( $EUID == 0 )); then
                        install_wget
                        install_cxs
                        printf "***instalando cxs***\n"
                        sleep 2
                        $PERL cxsinstaller.pl 2> /dev/null
			if which $CXS &> /dev/null; then
			configure_cxs
			configure_pure_ftpd
			mod_security_rule
			ln -s /etc/cxs/cxsdaily.sh /etc/cron.daily/
			$INIT/cxswatch start
			chkconfig cxswatch on
			rm cxsinstaller.pl
			else
				printf "no se pudo completar la instalacion de cxs\n"
			fi

                else
                        printf "saliendo... se requieren permisos para ejecutar este script\n" exit 0;
                fi
        else
                printf "no hay una conexion a internet...\n" exit 0;
        fi


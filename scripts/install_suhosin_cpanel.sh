#!/usr/bin/env bash

#set -x

GREEN='\033[0;32m'
RED='\033[0;31m'
WGET="/usr/bin/wget"
TAR="/bin/tar"
PHPIZE="/usr/bin/phpize"
PHPCONFIG="/usr/bin/php-config"
BASENAME="/bin/basename"
PATH_PHP="/opt/alt"
SUCONF="etc/php.ini"
suhosin_php44_php51="http://download.suhosin.org/suhosin-0.9.20.tgz"
suhosin_php52_php53="https://download.suhosin.org/suhosin-0.9.37.tgz"
suhosin_php54_php55_php56="https://download.suhosin.org/suhosin-0.9.38.tar.gz"

suhosin_file() {

log_suhosin="/var/log/suhosin_"$1".log"

touch $log_suhosin; chmod 666 $_;


cat >> $PATH_PHP/$1/$SUCONF <<'EOL'
extension="suhosin.so"

;configuraciones de registro
suhosin.log.file = 511
suhosin.log.syslog.facility = 13
suhosin.log.syslog.priority = 1
suhosin.log.file.name = 

suhosin.executor.disable_eval=On
EOL

sed -i "s|suhosin.log.file.name = |suhosin.log.file.name = $log_suhosin|g" $PATH_PHP/$1/$SUCONF

}

php_ver_suhosin() {

        cd /tmp/;
        if [[ $1 == "php44" ]]; then
                printf "$RED ********************$1********************\n"
                $WGET $suhosin_php44_php51 &> /dev/null
                $TAR xzf $($BASENAME $suhosin_php44_php51) &> /dev/null
                if (( $? == 0 )); then
                    cd $($BASENAME $_ .tgz)
                    $PATH_PHP/$1$PHPIZE &> /dev/null
                    ./configure --with-php-config="$PATH_PHP/$1$PHPCONFIG" &> /dev/null
					suhosin_file $1
                    make &> /dev/null; make install &> /dev/null
                    printf "$GREEN $($PATH_PHP/$1/usr/bin/php -v 2> /dev/null)\n"
					rm -r /tmp/$($BASENAME $suhosin_php44_php51 .tgz)
                else
                    printf "saliendo no se ha podido realizar la operacion...\n" && exit 1
                fi

        elif [[ $1 == "php51" ]]; then
                printf "$RED ********************$1********************\n"
                $TAR xzf $($BASENAME $suhosin_php44_php51) &> /dev/null
                if (( $? == 0 )); then
                    cd $($BASENAME $_ .tgz)
                    $PATH_PHP/$1$PHPIZE &> /dev/null
                    ./configure --with-php-config="$PATH_PHP/$1$PHPCONFIG" &> /dev/null
					suhosin_file $1
                    make &> /dev/null; make install &> /dev/null
                    printf "$GREEN $($PATH_PHP/$1/usr/bin/php -v 2> /dev/null)\n"
                    rm /tmp/$($BASENAME $suhosin_php44_php51)
                    rm -r /tmp/$($BASENAME $suhosin_php44_php51 .tgz)
                else
                    printf "saliendo no se ha podido realizar la operacion...\n" && exit 1
                fi
        elif [[ $1 == "php52" ]]; then
                printf "$RED ********************$1********************\n"
                $WGET $suhosin_php52_php53 &> /dev/null
                $TAR xzf $($BASENAME $suhosin_php52_php53) &> /dev/null
                if (( $? == 0 )); then
                    cd $($BASENAME $_ .tgz)
                    $PATH_PHP/$1$PHPIZE &> /dev/null
                    ./configure --with-php-config="$PATH_PHP/$1$PHPCONFIG" &> /dev/null
					suhosin_file $1
                    make &> /dev/null; make install &> /dev/null
                    printf "$GREEN $($PATH_PHP/$1/usr/bin/php -v 2> /dev/null)\n"
                    rm -r /tmp/$($BASENAME $suhosin_php52_php53 .tgz)
                else
                    printf "saliendo no se ha podido realizar la operacion...\n" && exit 1
                fi
        elif [[ $1 == "php53" ]]; then
                printf "$RED ********************$1********************\n"
                $TAR xzf $($BASENAME $suhosin_php52_php53) &> /dev/null
                if (( $? == 0 )); then
                    cd $($BASENAME $_ .tgz)
                    $PATH_PHP/$1$PHPIZE &> /dev/null
                    ./configure --with-php-config="$PATH_PHP/$1$PHPCONFIG" &> /dev/null
					suhosin_file $1
                    make &> /dev/null; make install &> /dev/null
                    printf "$GREEN $($PATH_PHP/$1/usr/bin/php -v 2> /dev/null)\n"
                    rm /tmp/$($BASENAME $suhosin_php52_php53)
                    rm -r /tmp/$($BASENAME $suhosin_php52_php53 .tgz)
                else
                    printf "saliendo no se ha podido realizar la operacion...\n" && exit 1
                fi
		elif [[ $1 == "php54" || $1 == "php55"  ]]; then
                printf "$RED ********************$1********************\n"
				if [[ ! -e $suhosin_php54_php55_php56 ]]; then
                	$WGET $suhosin_php54_php55_php56 &> /dev/null
				fi
                $TAR xzf $($BASENAME $suhosin_php54_php55_php56) &> /dev/null
                if (( $? == 0 )); then
                    cd $($BASENAME $_ .tar.gz)
                    $PATH_PHP/$1$PHPIZE &> /dev/null
                    ./configure --with-php-config="$PATH_PHP/$1$PHPCONFIG" &> /dev/null
					suhosin_file $1
                    make &> /dev/null; make install &> /dev/null
                    printf "$GREEN $($PATH_PHP/$1/usr/bin/php -v 2> /dev/null)\n"
                    rm -r /tmp/$($BASENAME $suhosin_php54_php55_php56 .tar.gz)
                else
                    printf "saliendo no se ha podido realizar la operacion...\n" && exit 1
                fi
		elif [[ $1 == "php56"  ]]; then
                printf "$RED ********************$1********************\n"
                if [[ ! -e $suhosin_php54_php55_php56 ]]; then
                    $WGET $suhosin_php54_php55_php56 &> /dev/null
                fi
                $TAR xzf $($BASENAME $suhosin_php54_php55_php56) &> /dev/null
                if (( $? == 0 )); then
                    cd $($BASENAME $_ .tar.gz)
                    $PATH_PHP/$1$PHPIZE &> /dev/null
                    ./configure --with-php-config="$PATH_PHP/$1$PHPCONFIG" &> /dev/null
					suhosin_file $1
                    make &> /dev/null; make install &> /dev/null
                    printf "$GREEN $($PATH_PHP/$1/usr/bin/php -v 2> /dev/null)\n"
                    rm -r /tmp/$($BASENAME $suhosin_php54_php55_php56 .tar.gz)
                    rm /tmp/$($BASENAME $suhosin_php54_php55_php56*)
                else
                    printf "saliendo no se ha podido realizar la operacion...\n" && exit 1
                fi
        else
                printf "version no valida de php..\n" && exit 1
        fi
}

for x in /opt/alt/php*; do
    version_php=$($BASENAME $x);
        case $version_php in
            php44)
                php_ver_suhosin php44;;
            php51)
                php_ver_suhosin php51;;
            php52)
                php_ver_suhosin php52;;
            php53)
                php_ver_suhosin php53;;
            php54)
                php_ver_suhosin php54;;
            php55)
                php_ver_suhosin php55;;
            php56)
                php_ver_suhosin php56;;
        esac

done

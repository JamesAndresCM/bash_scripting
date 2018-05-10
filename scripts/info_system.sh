#!/usr/bin/env bash

os=$(lsb_release -d | sed 's/.*:[[:space:]]//')
kernelr=$(uname -r)
host=$(sysctl -a 2>/dev/null|grep kernel.hostname|sed 's/.*=[[:space:]]//')
cpu=$(awk 'BEGIN{FS=":"} /model name/ { print $2; exit }' /proc/cpuinfo | sed 's/ @/\n/' | head -1)
uptime=$(uptime -p)

logo="\t       \e[0;36m/@\          \e[1;37m
              \e[0;36m/   \      \e[1;37m
             \e[0;36m/^.   \     \e[1;37m
            \e[0;36m/  .-.  \    \e[1;37m
           \e[0;36m/  (   ) _\   \e[1;37m
          \e[1;36m/ _.~   ~._^\  \e[1;37m
         \e[1;36m/.^         ^.\ \e[0;37m "

    printf "\e[1;32mOS\e[0m : $os \e[1;32mUtime\e[0m : $uptime \e[1;31mKernel Ver\e[0m : $kernelr\n"
    printf "\e[1;32mHostname\e[0m : $host \e[1;31mCPU Model\e[0m : $cpu\n"
    
    printf "$logo"
    printf "\n\e[1;34mNetwork Interfaces\e[0m \n"

    ip=$(dig +short myip.opendns.com @resolver1.opendns.com)
    printf "\e[1;32mPrivate IP\e[0m : $ip\n"
    count=0
    readarray -t nameserver <<< $(grep ^names /etc/resolv.conf | awk '{print $2}'); \
    for x in "${nameserver[@]}"; do ((count++));
    printf "\e[1;32mNameserver\e[0m : $x\n"; done
    printf "\e[1;32mTotal Nameserver\e[0m : $count\n"

    for inter in /sys/class/net/*; do
	    #echo ${inter##*/}
        printf "\e[1;32mInterfaz\e[0m : ${inter##*/}"
	    while read ip; do
		    printf " $ip"
	    done < <(ip address show ${inter##*/} | grep inet | awk '{print $2}' | cut -d: -f2)
        printf "\n"
    done

    printf "\n\e[1;34mUsuarios en sesion\e[0m "
    who | sed 's/[[:space:]].*//' | sort | uniq

    read a memT memU memL all < <(free -m|grep -i ^mem)

    printf "\n\e[1;34mRAM\e[0m \e[1;31mTotal\e[0m : $memT MiB \e[1;31mUse\e[0m : $memU MiB\n"

    printf "\n\e[1;34mParticiones HDD\e[0m"
    while read dev size used avail target; do
	    [ -b $dev ] && printf "\n\e[1;32mParticion\e[0m : $dev\t\e[1;31mTotal\e[0m: $size\t\e[1;31mUsado\e[0m: $used\t\e[1;31mDisponible\e[0m: $avail\t\e[1;31mMontada en\e[0m: $target"
    done < <(df -hl --output=source,size,used,avail,target)
    printf "\n"

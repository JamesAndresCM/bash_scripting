#!/usr/bin/env bash

folder=/opt/download_music
Package=youtube-dl

install_youtube_dl(){

 if ! which $Package &> /dev/null; then
		read -rep $'\e[32mYoutube-dl no esta instalado.. instalar Y/n? \n\e[m' op
			if [[ $op =~ [^"Yy"] || -z "$op" ]]; then
			        printf "sin respuesta..\n" && exit
			else
		curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl && chmod a+rx /usr/local/bin/youtube-dl

		fi
	fi
}

function Descarga {
	regex="^((https?:)?\/\/)?((www|m)\.)?((youtube\.com|youtu.be))(\/([\w\-]+\?v=|embed\/|v\/)?)([\w\-]+)([^[:space:]]+)?$"
		while ! [[ $url =~ $regex ]]
		do
			read -rep $'\e[32mEntry youtube url \n\e[m' url
		done
		while ! [[ $name != "" ]] 
		do
			read -rep $'\e[32mEntry name for download \n\e[m' name
		done
		$Package --extract-audio --audio-format mp3 $url -o "$folder/$name.%(mp3)s"
    }

[[ $EUID != 0 ]] && echo "no root exit...." && exit 0 ||
install_youtube_dl
[[ ! -d $folder ]] && mkdir -p $folder && cd $folder || cd $folder	
Descarga

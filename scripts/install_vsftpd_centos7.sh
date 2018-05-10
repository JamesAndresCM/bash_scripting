#!/bin/bash

DAEMON=vsftpd
PORTS=(21 40000)
PACKAGE=vsftpd

install_vsftpd(){

 if which $PACKAGE &> /dev/null; then
	echo "$PACKAGE ya esta instalado.."	
		else
		echo -e "Vsftpd no instalado instalar Y/n?" ; read op
		if [[ -z "$op" ]]; then
		        echo "vacio"
		else
			if [[ $op =~ [^"Yy"] ]]; then
				echo "saliendo" && exit
			else
				yum install vsftpd -y
		fi
	fi
fi
}

conf_vsftpd(){
FILE=/etc/vsftpd/vsftpd.conf 
	cp $FILE{,.bak}
cat > $FILE <<'EOL'
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_std_format=YES
ftpd_banner=Welcome
chroot_local_user=YES
listen=NO
listen_ipv6=YES
pam_service_name=vsftpd
userlist_enable=YES
tcp_wrappers=YES
allow_writeable_chroot=YES
pasv_enable=Yes
pasv_max_port=40000
pasv_min_port=40000
EOL
}

conf_openssh(){
	
	FILE=/etc/ssh/sshd_config
	cp $FILE{,.bak}
	sed -i 's/Subsystem/#Subsystem/' $FILE 
	echo '
Subsystem sftp internal-sftp
Match group sftp_users
ChrootDirectory %h
X11Forwarding no
AllowTcpForwarding no
ForceCommand internal-sftp' >> $FILE

	/usr/bin/systemctl restart sshd 
}

ping -c 1 google.cl &> /dev/null
	if (( $? == 0 )); then
		if (( $EUID == $0 )); then
			install_vsftpd
			conf_vsftpd
			conf_openssh 
		for port in ${PORTS[@]}; do
			/usr/bin/firewall-cmd --permanent --add-port=$port/tcp
		done
		/usr/bin/firewall-cmd --reload
		/usr/sbin/setsebool -P ftp_home_dir on
		/usr/bin/systemctl start $DAEMON 
		read -p "Remember create group sftp_users(groupadd sftp_users) and create users! press Enter to continue.."
		else
			echo "no root..."
		fi
	else
		echo "no internet.."
fi
#remember create group and users!
#eje:
#groupadd groupname
#useradd username -g groupname -s /sbin/nologin
#passwd username <--asign passwd to login sftp service
#change permissions folder
#mkdir /home/user/foldername
#chown root /home/user
#chmod 755 /home/user
#chown username /home/username/foldername
#chmod 755 /home/username/foldername



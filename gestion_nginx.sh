#!/usr/bin/bash

#Fonction de création du fichier systemd.
mksmd () { 
		bash -c "printf '%s\n' '[Unit]' 'Description=The NGINX HTTP and reverse proxy server ' 'After=syslog.target network-online.target remote-fs.target nss-lookup.target' 'Wants=network-online.target' ' '   '[Service]' 'Type=forking' 'PIDFile=/run/nginx.pid' 'ExecStartPre=/usr/sbin/nginx -t' 'ExecStart=/usr/sbin/nginx' 'ExecReload=/usr/sbin/nginx -s reload' 'ExecStop=/bin/kill -s QUIT $MAINPID' 'PrivateTmp=true' ' '  '[Install]' 'WantedBy=multi-user.target' > /lib/systemd/system/nginx.service"
		}

PS3='Choisir une operation: '
ops=("Installer"  "Mettre a jour" "Desinstaller" "Quitter")
select op in "${ops[@]}"; do
    case $op in
        "Installer")
			
			if [ -f /etc/debian_version ]; then
			echo -e "\033[0;32mInstallation des dépendences Debian... \033[0m "
			apt install -q build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev libgd-dev \
				libxml2 libxml2-dev uuid-dev devscripts -y 2>/dev/null >/dev/null \
				/

		elif [ -f /etc/redhat-release ]; then
			echo -e "\033[0;32mInstallation des dépendences Redhat... \033[0m "
			yum install -q pcre pcre-devel zlib zlib-devel openssl openssl-devel  -y 2>/dev/null >/dev/null;

		fi
			echo -e "\033[0;34mVersions de Nginx possibles : \033[0m "
			rmadison nginx
			read -p $'\e[34mQuelle version installer ? ( ex: \e[32m1.22.1 \e[34mpour installer la version 1.22.1-1 \e[34m):\e[0m ' ver

			echo -e "\033[0;32mTélechargement de Nginx... \033[0m "
			wget https://nginx.org/download/nginx-$ver.tar.gz
			tar zxf nginx-$ver.tar.gz
			cd nginx-$ver
			echo -e "\033[0;32mConfiguration de Nginx... \033[0m " 
			./configure --sbin-path=/usr/bin/nginx \
						--conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log \
						--http-log-path=/var/log/nginx/access.log --with-pcre --pid-path=/var/run/nginx.pid \
						--with-debug &> /dev/null \
			/

			echo -e "\033[0;32mInstallation de Nginx... \033[0m "
			make install &> /dev/null 
			cd ..
			rm nginx-$ver.tar.gz
			nginx -v
			

			echo -e "\033[0;32mCréation de fichiers systèmes et démmarage des services... \033[0m "
			touch /lib/systemd/system/nginx.service
			mksmd
			systemctl daemon-reload
			/etc/init.d/apache2 stop
			systemctl unmask nginx.service
			systemctl enable nginx.service
			systemctl start nginx.service
			systemctl status nginx.service
			echo -e "\033[0;32mDémarrage de Nginx... \033[0m "
			nginx 
			echo -e "\033[0;32mInstallation terminée ! \033[0m "
		break
            ;;
 
        "Mettre a jour")
        
        echo -e "\033[0;32mSauvegarde des fichiers de configuration... \033[0m "   	
		cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup
		
		echo -e "\033[0;32mMise à jour... ! \033[0m "
		add-apt-repository ppa:nginx/stable
		
		if [ -f /etc/debian_version ]; then
			apt update
			apt dist-upgrade -y nginx
		
		elif [ -f /etc/redhat-release ]; then
			yum remove nginx nginx-common nginx-core
		fi
		break
            ;;
        "Desinstaller")
            
            read -p "Archiver nginx ? (o/n): " arc
        if [ "$arc" == [O/o] ];then
        	echo -e "\033[0;32mArchivage... \033[0m "
            tar -zcvf nginx-backup.tar.gz /etc/nginx/
          else
          
           
        echo -e "\033[0;32mDesinstallation... \033[0m "   
        if [ -f /etc/debian_version ]; then
        apt purge nginx nginx-common nginx-core -y
        apt autoremove -y

    	elif [ -f /etc/redhat-release ]; then
    	yum remove nginx nginx-common nginx-core -y
        fi
        fi

		break
            ;;
		"Quitter")
			exit
	    	;;
        *) echo "invalide :(";;
    esac
done
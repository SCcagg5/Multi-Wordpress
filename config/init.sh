read -p "Enter domain: " ip
scp ./id_rsa.pub root@$ip:.ssh/authorized_keys
scp ./install.sh root@$ip:install.sh

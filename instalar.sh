#!/bin/bash
echo  Digite seu nome por favor
read NAME
echo "Oi $NAME! Primeiramente vamos atualizar os repositórios..."
sudo apt-get update
echo "OK! Agora vamos atualizar o sistema ..."
sudo apt-get upgrade -y
echo "Pronto! Agora vamos instalar o Apache..."
sudo apt install apache2 -y
echo "Agora Ajustar o Firewall para Permitir Tráfego Web..."
sudo ufw allow in "Apache Full"
echo "Agora instalar o MySQL..."
sudo apt install mysql-server -y
sudo mysql_secure_installation
echo "Agora instalar o PHP..."
sudo apt install php libapache2-mod-php php-mysql -y
sudo nano /etc/apache2/mods-enabled/dir.conf
echo "OK! Agora reiniciar o Apache ..."
sudo systemctl restart apache2
echo "Pronto! O LAMP está OK. Agora vamos ao Asterisk..."
sudo su
apt-get install build-essential wget libssl-dev libncurses5-dev libnewt-dev libxml2-dev linux-headers-$(uname -r) libsqlite3-dev uuid-dev git subversion -y
cd /usr/src
wget downloads.asterisk.org/pub/telephony/asterisk/asterisk-13-current.tar.gz
tar zxvf asterisk-13-current.tar.gz
# cd asterisk-13*
git clone git://github.com/asterisk/pjproject pjproject
cd pjproject
./configure --prefix=/usr --enable-shared --disable-sound --disable-resample --disable-video --disable-opencore-amr CFLAGS='-O2 -DNDEBUG'
make dep
make && make install
ldconfig
ldconfig -p |grep pj
cd ..
contrib/scripts/get_mp3_source.sh
contrib/scripts/install_prereq install -y
./configure && make menuselect && make && make install
make samples
make config
ldconfig
# Testando se está tudo OK ...
# /etc/init.d/asterisk start
# asterisk -rvvv
# systemctl stop asterisk
groupadd asterisk
useradd -d /var/lib/asterisk -g asterisk asterisk
sed -i 's/#AST_USER="asterisk"/AST_USER="asterisk"/g' /etc/default/asterisk
sed -i 's/#AST_GROUP="asterisk"/AST_GROUP="asterisk"/g' /etc/default/asterisk
chown -R asterisk:asterisk /var/spool/asterisk /var/run/asterisk /etc/asterisk /var/{lib,log,spool}/asterisk /usr/lib/asterisk
sed -i 's/;runuser = asterisk/runuser = asterisk/g' /etc/asterisk/asterisk.conf
sed -i 's/;rungroup = asterisk/rungroup = asterisk/g' /etc/asterisk/asterisk.conf
echo "O Asterisk foi instalado. Reinicie o servidor para finalizar ..."

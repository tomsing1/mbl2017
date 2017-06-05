#!/usr/bin/env bash

timedatectl set-timezone America/New_York
timedatectl status
apt-get update
apt-get install -y git python-pip htop apache2 emacs
echo "ubuntu:2017neuroscience!" | chpasswd

# install AWS CLI tool
pip install --upgrade pip
pip install --upgrade awscli

# install conda
wget -q https://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh \
  -O miniconda.sh
chmod +x miniconda.sh
./miniconda.sh -b -p /home/ubuntu/miniconda
chown -R ubuntu /home/ubuntu/
echo PATH=/home/ubuntu/miniconda/bin:$PATH >> /etc/environment

# configure apache2 webserver to listen on port 8010 and show ubuntu's home directory
cat <<EOF >> /etc/apache2/apache2.conf
 <Directory /home/ubuntu/>
       Options Indexes FollowSymLinks
       AllowOverride None
       Require all granted
</Directory>
EOF
echo "Listen 8010" > /etc/apache2/ports.conf
sed -i s/'DocumentRoot \/var\/www\/html'/'DocumentRoot \/home\/ubuntu'/ \
    /etc/apache2/sites-available/000-default.conf
sed -i s/'<VirtualHost \*:80>'/'<VirtualHost \*:8010>'/ \
    /etc/apache2/sites-available/000-default.conf
/etc/init.d/apache2 restart

# update RStudio server
wget https://download2.rstudio.org/rstudio-server-1.0.143-amd64.deb
gdebi -qn rstudio-server-1.0.143-amd64.deb

# clean AMI
clean_ami

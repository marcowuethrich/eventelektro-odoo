#!/bin/bash
################################################################################
# Author: Marco Wüthrich
#-------------------------------------------------------------------------------
# This script will install Odoo on your Ubuntu 14.04 server. It can install  Odoo instances
# in one Ubuntu because of the different xmlrpc_ports
#-------------------------------------------------------------------------------
# Make the file executable:
# sudo chmod +x odoo-install.sh
# Execute the script to install Odoo:
# ./odoo-install
################################################################################

##
###  WKHTMLTOPDF download links
## === Ubuntu Trusty x64 & x32 === (for other distributions please replace these two links,
## in order to have correct version of wkhtmltox installed, for a danger note refer to 
## https://www.odoo.com/documentation/8.0/setup/install.html#deb ):
WKHTMLTOX_X64=http://download.gna.org/wkhtmltopdf/0.12/0.12.1/wkhtmltox-0.12.1_linux-trusty-amd64.deb
WKHTMLTOX_X32=http://download.gna.org/wkhtmltopdf/0.12/0.12.1/wkhtmltox-0.12.1_linux-trusty-i386.deb

#--------------------------------------------------
# Update Server
#--------------------------------------------------
echo -e "\n---- Update Server ----"
sudo apt-get update
sudo apt-get upgrade -y

#--------------------------------------------------
# Install Git
#--------------------------------------------------
echo -e "\n---- Install Git ----"
sudo apt-get intall git

#--------------------------------------------------
# Open Corresponding Firewall Ports
#--------------------------------------------------
echo -e "\n---- Open Firewall Ports ----"
sudo ufw allow ssh
sudo ufw allow 8069/tcp
sudo ufw enable

#--------------------------------------------------
# Install PostgreSQL Server
#--------------------------------------------------
echo -e "\n---- Install PostgreSQL Server ----"
sudo apt-get install subversion git bzr bzrtools python-pip postgresql postgresql-server-dev-9.3 python-all-dev python-dev python-setuptools libxml2-dev libxslt1-dev libevent-dev libsasl2-dev libldap2-dev pkg-config libtiff5-dev libjpeg8-dev libjpeg-dev zlib1g-dev libfreetype6-dev liblcms2-dev liblcms2-utils libwebp-dev tcl8.6-dev tk8.6-dev python-tk libyaml-dev fontconfig

echo -e "\n---- Creating the ODOO PostgreSQL User  ----"
sudo su - postgres -c "createuser -s odoo" 2> /dev/null || true

#--------------------------------------------------
# Create Oddo Userand Log Direcotry
#--------------------------------------------------
echo -e "\n---- Creating odoo User  ----"
sudo adduser --system --home=/opt/odoo --group odoo

echo -e "\n---- Creating Log dir  ----"
sudo mkdir /var/log/odoo

#--------------------------------------------------
# Install Dependencies
#--------------------------------------------------

echo -e "\n---- Install Python lib  ----"
sudo pip install -r /opt/odoo/doc/requirements.txt
sudo pip install -r /opt/odoo/requirements.txt

echo -e "\n---- Install Less CSS via nodejs and npm  ----"
wget -qO- https://deb.nodesource.com/setup_6.x | sudo bash -
sudo apt-get install nodejs
sudo npm install -g less less-plugin-clean-css

#--------------------------------------------------
# Install Wkhtmltopdf if needed
#--------------------------------------------------

echo -e "\n---- Install wkhtml and place shortcuts on correct place for odoo ----"
#pick up correct one from x64 & x32 versions:
if [ "`getconf LONG_BIT`" == "64" ];then
      _url=${WKHTMLTOX_X64}
else
    _url=${WKHTMLTOX_X32}
fi
sudo wget ${_url}
sudo gdebi --n `basename ${_url}`
sudo ln -s /usr/local/bin/wkhtmltopdf /usr/bin
sudo ln -s /usr/local/bin/wkhtmltoimage /usr/bin


#--------------------------------------------------
# Install ODOO
#--------------------------------------------------

echo -e "\n---- Create custom module directory ----"
sudo mkdir /opt/odoo/custom
sudo mkdir /opt/odoo/custom/addons

echo -e "\n---- Set permission on odoo Server ----"
sudo chmod 755 -R /opt/odoo/
sudo chmod 755 -R /opt/odoo/custom/

echo -e "* Create server config file"
sudo cp /opt/odoo/debian/openerp-server.conf /etc/odoo-server.conf
sudo chmod 640 /etc/odoo-server.conf
# sudo chown odoo: /etc/odoo-server.conf

sudo chown -R odoo: /opt/odoo/
sudo chown odoo:root /var/log/odoo

echo -e "* Create startup file"
sudo cp /opt/odoo/odoo-server.sh /etc/init.d/odoo-server.sh
sudo chmod 755 /etc/init.d/odoo-server.sh
sudo chown root: /etc/init.d/odoo-server.sh

echo -e "* Starting Odoo Service"
sudo su root -c "/etc/init.d/odoo-server start"
echo "-----------------------------------------------------------"
echo "Done! The Odoo server is up and running. Specifications:"
echo "Port: 8069"
echo "User service: odoo"
echo "User PostgreSQL: odoo"
echo "Code location: odoo"
echo "Addons folder: /opt/odoo/addons/"
echo "Start Odoo service: sudo service odoo-server start"
echo "Stop Odoo service: sudo service odoo-server stop"
echo "Restart Odoo service: sudo service odoo-server restart"
echo "-----------------------------------------------------------"

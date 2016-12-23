Requirements:
----

ubuntu => 16.04


Install
----

sudo apt-get update

sudo apt-get upgrade

sudo wget https://raw.githubusercontent.com/Yenthe666/InstallScript/10.0/odoo_install.sh

sudo nano odoo_install.sh

sudo chmod +x odoo_install.sh

./odoo_install.sh


Customer Changes
----

Change the folder /odoo/odoo-server with the custom-Github repo (Main Programm Odoo and Server)

Change the folder /odoo/custom with the actual Backup order (Customer addons)


Run
---

sudo service odoo-server {start|stop|restart|force-reload}
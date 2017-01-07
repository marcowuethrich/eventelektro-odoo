Requirements:
----

ubuntu 14.04 or higher


Install Odoo 9
----

* sudo su root
* sudo apt-get install wget
* sudo wget https://raw.githubusercontent.com/marcowuethrich/odoo/version/odoo9/odoo_install.sh
* sudo sh odoo_install.sh
* chmod +x odoo_install.sh
* ./odoo_install.sh


Customer Changes
----

Change the folder /opt/odoo/odoo-server/custom with the actual Backup order (Customer addons)


Run
---

sudo service odoo-server {start|stop|restart|force-reload}
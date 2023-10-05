#!/bin/bash

<<'MULTILINE-COMMENT'
    Requirments: none
    Description: Script for configure NGINX
    Author: Marcos Silvestrini
    Date: 14/04/2023
MULTILINE-COMMENT

export LANG=C

cd /home/vagrant || exit

# Install Nginx
dnf install -y nginx-mod-stream
dnf install -y nginx

# Tunning Nginx

# Configure /etc/nginx/sites-available/backstage.skynet.com.br
cp -f configs/backstage.conf /etc/nginx/conf.d


# Check nginx configuration
nginx -t

# Enable ngix service
systemctl enable nginx

# Restart ngix service
systemctl restart nginx

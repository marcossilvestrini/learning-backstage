#!/bin/bash

<<'MULTILINE-COMMENT'
    Requirements: none
    Description: Script for install postgresql for backstage
    Author: Marcos Silvestrini
    Date: 10/10/2023
MULTILINE-COMMENT

# Set language/locale and encoding
export LANG=C

# Set working directory
WORKDIR=/home/vagrant
cd "$WORKDIR" || exit

# Check if the script is being executed with administrator privileges (root)
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root or with sudo privileges."
  exit 1
fi

# Update the repositories and install PostgreSQL and its tools
dnf install -y postgresql-server postgresql-contrib postgresql

# Initialize the PostgreSQL database and enable it to start on boot
postgresql-setup --initdb
systemctl enable postgresql
systemctl start postgresql

# Update the password for the postgres user to "backstage"
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'backstage';"

# Restart the PostgreSQL service to apply the new password
systemctl restart postgresql

# Start all services
systemctl start postgresql

echo "PostgreSQL installed, postgres user password updated to 'backstage,' and all services started."

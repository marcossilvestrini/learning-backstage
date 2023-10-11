#!/bin/bash

<<'MULTILINE-COMMENT'
    Requirements: none
    Description: Script for syncing backstage files for devs
    Author: Marcos Silvestrini
    Date: 10/10/2023
MULTILINE-COMMENT

# Set language/locale and encoding
export LANG=C

# Set working directory
WORKDIR=/home/vagrant
cd "$WORKDIR" || exit

# Check if rsync is installed
if command -v rsync &> /dev/null; then
  echo "rsync is already installed."
else
  # If rsync is not installed, install it
  echo "rsync is not installed. Installing..."
  sudo dnf install rsync -y
  if [ $? -eq 0 ]; then
    echo "rsync has been installed successfully."
  else
    echo "Error installing rsync. Please check your permissions or internet connection."
  fi
fi

# First sync files
if [ ! -d "$WORKDIR/backstage/skynet" ]; then
  mkdir -p "$WORKDIR/backstage/skynet"
fi
rsync -av --exclude=node_modules --exclude=dist-types --exclude=.git /opt/backstage/skynet/ /home/vagrant/backstage/skynet/

# Check if the cron job already exists
if ! crontab -l | grep -q 'rsync'; then
  # If it doesn't exist, add the new cron job
  (crontab -l ; echo '* * * * * rsync -av --exclude=node_modules --exclude=dist-types --exclude=.git /opt/backstage/skynet/ /home/vagrant/backstage/skynet/') | crontab -
  echo "Cron job added successfully."
else
  echo "The cron job already exists."
fi

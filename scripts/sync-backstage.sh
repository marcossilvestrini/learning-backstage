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

# Set syn script

if [ ! -f "/bin/bash /usr/local/bin/sync_script.sh" ]; then
  sudo cp scripts/sync_script.sh /usr/local/bin
  sudo chown vagrant:vagrant /usr/local/bin/sync_script.sh
  chmod +x /usr/local/bin/sync_script.sh    
fi

# First sync files
rsync -av --exclude=node_modules --exclude=dist-types --exclude=.git /home/vagrant/backstage/skynet/ /opt/backstage/skynet/
#rsync -av --exclude=node_modules --exclude=dist-types --exclude=.git /opt/backstage/skynet/ /home/vagrant/backstage/skynet/

# Verifique se a tarefa cron já existe.
if crontab -l | grep -q "/usr/local/bin/sync_script.sh"; then
  echo "A tarefa cron já existe."
else
  # Crie a tarefa cron para executar rsync a cada 10 segundos.
  (crontab -l ; echo "* * * * * /bin/bash /usr/local/bin/sync_script.sh") | crontab -
  echo "Tarefa cron criada."
fi


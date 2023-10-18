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

# Set syn script
if [ ! -f "/bin/bash /usr/local/bin/sync_script.sh" ]; then
  sudo cp scripts/sync_script.sh /usr/local/bin
  sudo chown vagrant:vagrant /usr/local/bin/sync_script.sh
  chmod +x /usr/local/bin/sync_script.sh    
fi

# First sync files
(sudo nohup rsync -av --exclude=node_modules --exclude=dist-types --exclude=.git /home/vagrant/backstage/skynet/ /opt/backstage/skynet/ </dev/null &>/dev/null &)
#rsync -av --exclude=node_modules --exclude=dist-types --exclude=.git /opt/backstage/skynet/ /home/vagrant/backstage/skynet/

# Create cron job
if ! crontab -l | grep -q "/usr/local/bin/sync_script.sh"; then  
  (echo "* * * * * /bin/bash /usr/local/bin/sync_script.sh") | crontab -    
  echo "Crontab create with success!!!"
fi

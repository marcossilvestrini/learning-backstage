#!/bin/bash

<<'MULTILINE-COMMENT'
    Requirments: none
    Description: Script for install Backstage for labs
    Author: Marcos Silvestrini
    Date: 02/10/2023
MULTILINE-COMMENT

# Set language/locale and encoding
export LANG=C

cd /home/vagrant || exit

# Install Node - https://github.com/nvm-sh/nvm#install--update-script

## Install nvm
rm -rf ~/.nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
source ~/.bashrc
nvm -v

## Instal Node.js
rm -rf ~/.npm
nvm install --lts
source ~/.bashrc
npm -v

# Install yarn
npm install --global yarn
source ~/.bashrc
yarn -v

# Instal docker
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker vagrant
sudo setfacl --modify user:vagrant:rw /var/run/docker.sock
#sudo docker run hello-world


# Create backstage app
if ! [ -d "/opt/backstage/skynet" ]; then
    sudo mkdir -p /opt/backstage
    sudo chown -R vagrant:vagrant /opt/backstage && sudo chmod -R 0777 /opt/backstage    
fi
cd /opt/backstage || exit     
echo "skynet" | npx @backstage/create-app@latest
cd skynet || exit
yarn install
sudo chown -R  vagrant:vagrant /opt/backstage/

# Set app-config.yaml
cp /home/vagrant/configs/app-config.yaml  /opt/backstage/skynet
SECRETS_FILE="security/backstage-secrets.yaml"
CONFIG_FILE="/opt/backstage/skynet/app-config.yaml"
GITHUB_TOKEN=$(grep 'GITHUB_TOKEN' "$SECRETS_FILE" | awk '{print $2}')
GITHUB_CLIENT_ID=$(grep 'GITHUB_CLIENT_ID' "$SECRETS_FILE" | awk '{print $2}')
GITHUB_CLIENT_SECRET=$(grep 'GITHUB_CLIENT_SECRET' "$SECRETS_FILE" | awk '{print $2}')
sed -i "s/\${AUTH_GITHUB_CLIENT_ID}/$GITHUB_CLIENT_ID/g" "$CONFIG_FILE"
sed -i "s/\${AUTH_GITHUB_CLIENT_SECRET}/$GITHUB_CLIENT_SECRET/g" "$CONFIG_FILE"

# Start app
yarn dev
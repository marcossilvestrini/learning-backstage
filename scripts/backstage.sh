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
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
source ~/.bashrc
nvm -v

## Instal Node.js
nvm install node
source ~/.bashrc
npm -v

# Install yarn
npm install --global yarn
source ~/.bashrc
yarn -v
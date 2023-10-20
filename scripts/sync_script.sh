#!/bin/bash

# Função para realizar a sincronização.
sync_directories() {
  rsync -av --exclude 'node_modules' --exclude 'dist-types' --exclude='.git' /home/vagrant/backstage/skynet/ /opt/backstage/skynet/
  #rsync -av --exclude 'node_modules' --exclude 'dist-types' --exclude='.git' /opt/backstage/skynet/ /home/vagrant/backstage/skynet/
}

# Chame a função de sincronização.
sync_directories
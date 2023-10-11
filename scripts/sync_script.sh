#!/bin/bash

# Função para realizar a sincronização.
sync_directories() {
  rsync -av --exclude 'node_modules' --exclude 'dist-types' /home/vagrant/backstage/skynet/ /opt/backstage/skynet/
  #rsync -av --exclude 'node_modules' --exclude 'dist-types' /opt/backstage/skynet/ /home/vagrant/backstage/skynet/
}

# Chame a função de sincronização.
sync_directories
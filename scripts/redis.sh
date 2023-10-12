<<'MULTILINE-COMMENT'
    Requirements: none
    Description: Script for install redis for backstage
    Author: Marcos Silvestrini
    Date: 12/10/2023
MULTILINE-COMMENT

# Set language/locale and encoding
export LANG=C

# Set working directory
WORKDIR=/home/vagrant
cd "$WORKDIR" || exit

# Verify if user is root
if [ "$EUID" -ne 0 ]; then
  echo "Please, execute this scripts as root user"
  exit 1
fi

# Install redis
dnf install -y redis

# Define password for redis default user
REDIS_PASSWORD="backstage"
REDIS_CONFIG="/etc/redis.conf"

# Update configuration of redis for new password
if [ -n "$REDIS_PASSWORD" ]; then
  sed -i "s/# requirepass foobared/requirepass $REDIS_PASSWORD/g" $REDIS_CONFIG
  systemctl restart redis
fi

# Start redis Inicie o serviço do Redis
systemctl start redis

# Enable redis
systemctl enable redis

# Verify redis status
systemctl status redis
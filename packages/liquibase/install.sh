sudo groupadd liquibase
sudo useradd liquibase -g liquibase -m -d  /home/liquibase -c "[LIQUIBASE ADMIN] - Administrador Liquibase" -s /bin/bash
sudo mkdir -p /usr/local/liquibase
sudo chown liquibase.liquibase /usr/local/liquibase
sudo tar -xvzf /vagrant/packages/liquibase/liquibase-4.3.4.tar.gz -C /usr/local/liquibase
sudo ln -s /usr/local/liquibase/liquibase /sbin/liquibase
sudo echo "Liquibase instalado!"
#!/bin/bash

curdir=$(pwd)

# OLD_IP=10.0.2.16
# IP=10.0.2.16
PORT_DOCKER=9000

# inject the addresses into the hosts file from the host
# sudo sed -i '/^'$OLD_IP'.*$/d' /etc/hosts
# sudo sed -i '$ a '$IP' sonarqube' /etc/hosts

#generate the SSL certificate and key
cd $(dirname "$0")/nginx/ssl 
sudo chmod +x ./generate-certificate-and-key.sh
./generate-certificate-and-key.sh

# change curent dir, so that docker-compose will use the proper docker-compose.yml file without the -f option which does not work
cd $curdir
cd $(dirname "$0")
/usr/local/bin/docker-compose build # this is very important, without it the proxy container is not injected with the required files
/usr/local/bin/docker-compose up -d --force-recreate

# # after creating the docker and its default network, need to get the IP address and inject it into proxy_pass
# IP_DOCKER=$(docker inspect -f '{{range .Containers}}{{.IPv4Address}}{{end}}' reverse-proxy_default | tr "/" "\n" | head -n 1)
IP_DOCKER=$(docker inspect -f '{{range .IPAM.Config}}{{.Gateway}}{{end}}' reverse-proxy_default | tr "/" "\n" | head -n 1)
echo "proxy_pass http://"$IP_DOCKER":"$PORT_DOCKER"/;" > ./nginx/includes/proxy_pass.conf

/usr/local/bin/docker-compose build # this is very important, without it the proxy container is not injected with the required files
/usr/local/bin/docker-compose up -d --force-recreate

cd $curdir
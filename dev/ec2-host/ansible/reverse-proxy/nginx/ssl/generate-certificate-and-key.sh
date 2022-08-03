sudo openssl req -subj "/C=RO/ST=./L=./O=Sonarqube/CN=sonarqube.company.com" -newkey rsa:2048 -nodes -keyout sonarqube.key -x509 -days 365 -out sonarqube.crt
# [centos] needed to fix permission, otherwise will get cannot read .key error when starting server
sudo chmod +r sonarqube.key
sudo chmod +r sonarqube.crt
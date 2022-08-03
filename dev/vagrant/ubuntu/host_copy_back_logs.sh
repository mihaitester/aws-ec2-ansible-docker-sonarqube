# need to move these commands here, after installing the guest additions so that mounting is successful
vagrant ssh -c "sudo cp /home/vagrant/pip.freeze.txt /vagrant/data/pip.freeze.txt"
vagrant ssh -c "sudo cp /home/vagrant/apt-list-installed.txt /vagrant/data/apt-list-installed.txt"
vagrant ssh -c "sudo cp /etc/os-release /vagrant/data/os-release"
vagrant ssh -c "sudo cp /etc/vagrant_provisioned_at /vagrant/data/vagrant_provisioned_at"
vagrant ssh -c "sudo cp /tmp/ansible.facts.json /vagrant/data/ansible.facts.json"

vagrant ssh -c "sudo cp /home/vagrant/docker-ps.txt /vagrant/data/docker-ps.txt"

vagrant ssh -c "sudo cp /home/vagrant/docker-inspect-sonarqube_sonarqube_1.txt /vagrant/data/docker-inspect-sonarqube_sonarqube_1.txt"
vagrant ssh -c "sudo cp /home/vagrant/docker-inspect-sonarqube_db_1.txt /vagrant/data/docker-inspect-sonarqube_db_1.txt"
vagrant ssh -c "sudo cp /home/vagrant/docker-inspect-reverse-proxy_proxy_1.txt /vagrant/data/docker-inspect-reverse-proxy_proxy_1.txt"

vagrant ssh -c "sudo cp /home/vagrant/docker-logs-sonarqube_sonarqube_1.txt /vagrant/data/docker-logs-sonarqube_sonarqube_1.txt"
vagrant ssh -c "sudo cp /home/vagrant/docker-logs-sonarqube_db_1.txt /vagrant/data/docker-logs-sonarqube_db_1.txt"
vagrant ssh -c "sudo cp /home/vagrant/docker-logs-reverse-proxy_proxy_1.txt /vagrant/data/docker-logs-reverse-proxy_proxy_1.txt"

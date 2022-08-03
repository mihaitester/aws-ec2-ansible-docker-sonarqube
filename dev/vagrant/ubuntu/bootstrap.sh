# cd $(dirname "$0")
sudo date > /etc/vagrant_provisioned_at # TODO: get execution time of the script

sudo apt-get install -y git

# https://stackoverflow.com/questions/3522341/identify-user-in-a-bash-script-called-by-sudo
[ $SUDO_USER ] && user=$SUDO_USER || user=`whoami`
echo "user=${user}"

dirpath="/home/vagrant"
cd "${dirpath}"
    rm -rf ./aws-ec2-ansible-docker-sonarqube
    sudo -u vagrant git clone https://github.com/headshot4good/aws-ec2-ansible-docker-sonarqube.git

cd "${dirpath}/aws-ec2-ansible-docker-sonarqube/dev/ec2-host"
    sudo chmod +x ./ansible.install.sh
    sudo -u vagrant bash -c "./ansible.install.sh" # [ubuntu] can't read /root/.bashrc: Permission denied

cd "${dirpath}/aws-ec2-ansible-docker-sonarqube/dev/ec2-host/ansible"

    # Patch the user used by ansible for running commands
    echo --- > ./vars/default.yml
    echo ansible_user: vagrant >> ./vars/default.yml
    echo root_user: root >> ./vars/default.yml
    echo python_version: 3.9.6 >> ./vars/default.yml
    # echo ansible_python_interpreter: auto >> ./vars/default.yml # https://www.toptechskills.com/ansible-tutorials-courses/how-to-fix-usr-bin-python-not-found-error-tutorial/

    # need to de-elevate root user before invoking ansible [ https://askubuntu.com/questions/617850/changing-from-user-to-superuser ]
    sudo chmod +x ./localhost.facts.sh
    echo vagrant | sudo su - vagrant -c "cd $(pwd) && sudo -u vagrant ./localhost.facts.sh" # need to figure out how to identify amazon boxes from redhat boxes

    sudo chmod +x ./localhost.play.sh
    echo vagrant | sudo su - vagrant -c "cd $(pwd) && sudo -u vagrant ./localhost.play.sh" # [ubuntu] can't read /root/.bashrc: Permission denied

python3 -m pip freeze > "${dirpath}/pip.freeze.txt"
sudo apt list --installed > "${dirpath}/apt-list-installed.txt"

docker ps > "${dirpath}/docker-ps.txt"

docker inspect sonarqube_sonarqube_1 > "${dirpath}/docker-inspect-sonarqube_sonarqube_1.txt"
docker inspect sonarqube_db_1 > "${dirpath}/docker-inspect-sonarqube_db_1.txt"
docker inspect reverse-proxy_proxy_1 > "${dirpath}/docker-inspect-reverse-proxy_proxy_1.txt"

docker logs sonarqube_sonarqube_1 > "${dirpath}/docker-logs-sonarqube_sonarqube_1.txt"
docker logs sonarqube_db_1 > "${dirpath}/docker-logs-sonarqube_db_1.txt"
docker logs reverse-proxy_proxy_1 > "${dirpath}/docker-logs-reverse-proxy_proxy_1.txt"

# sudo $installer install -y dpkg
# dpkg --get-selections > /home/vagrant/dpkg--get-selections.txt

# sudo cp /home/vagrant/pip.freeze.txt /vagrant/data/pip.freeze.txt
# # sudo cp /home/vagrant/dpkg--get-selections.txt /vagrant/data/dpkg--get-selections.txt
# sudo cp /home/vagrant/apt-list-installed.txt /vagrant/data/apt-list-installed.txt
# sudo cp /etc/os-release /vagrant/data/os-release
# sudo cp /etc/vagrant_provisioned_at /vagrant/data/vagrant_provisioned_at
# sudo cp /tmp/ansible.facts.json /vagrant/data/ansible.facts.json
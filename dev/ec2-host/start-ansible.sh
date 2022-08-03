cd $(dirname "$0")

# https://stackoverflow.com/questions/3522341/identify-user-in-a-bash-script-called-by-sudo
[ $SUDO_USER ] && user=$SUDO_USER || user=`whoami`
echo "user=${user}"

installer=$(which apt-get || which yum)
sudo $installer install -y git

cd /home/${user}
    rm -rf ./aws-ec2-ansible-docker-sonarqube
    sudo -u ${user} git clone https://github.com/headshot4good/aws-ec2-ansible-docker-sonarqube.git

cd /home/${user}/aws-ec2-ansible-docker-sonarqube/dev/ec2-host
    sudo chmod +x ./ansible.install.sh
    sudo -u ${user} bash -c "./ansible.install.sh" # [ubuntu] can't read /root/.bashrc: Permission denied

cd /home/${user}/aws-ec2-ansible-docker-sonarqube/dev/ec2-host/ansible
    # Patch the user used by ansible for running commands
    echo --- > ./vars/default.yml
    echo ansible_user: ${user} >> ./vars/default.yml
    echo root_user: root >> ./vars/default.yml
    echo python_version: 3.9.6 >> ./vars/default.yml

    sudo chmod +x ./localhost.facts.sh
    sudo -u ${user} bash -c "./localhost.facts.sh" # need to figure out how to identify amazon boxes from redhat boxes

    sudo chmod +x ./localhost.play.sh
    sudo -u ${user} bash -c "./localhost.play.sh" # [ubuntu] can't read /root/.bashrc: Permission denied
# cd $(dirname "$0")
sudo date > /etc/vagrant_provisioned_at # TODO: get execution time of the script

# # Disable Cloud init for amazon [ https://askubuntu.com/questions/405442/how-can-i-disable-cloud-init ]
sudo touch /etc/cloud/cloud-init.disabled

# # # NOTE: Cloud-init applies network settings on every boot by default. To retain network settings from first boot, add following ‘write_files’ section:
# # write_files:
# #   - path: /etc/cloud/cloud.cfg.d/80_disable_network_after_firstboot.cfg
# #     content: |
# #       # Disable network configuration after first boot
# #       network:
# #         config: disabled
sudo cat /etc/cloud/cloud.cfg.d/80_disable_network_after_firstboot.cfg
sudo sed -i '/^network:.*$/d' /etc/cloud/cloud.cfg.d/80_disable_network_after_firstboot.cfg
sudo sed -i '/^.*config: disabled.*$/d' /etc/cloud/cloud.cfg.d/80_disable_network_after_firstboot.cfg
sudo sed -i '$ a network:' /etc/cloud/cloud.cfg.d/80_disable_network_after_firstboot.cfg
sudo sed -i '$ a   config: disabled' /etc/cloud/cloud.cfg.d/80_disable_network_after_firstboot.cfg
sudo cat /etc/cloud/cloud.cfg.d/80_disable_network_after_firstboot.cfg

# # https://stackoverflow.com/questions/43847470/failed-to-start-lsb-bring-up-down-networking
# sudo sed -i 's/^DHCPV6C=.*/DHCPV6C=no/' /etc/sysconfig/network-scripts/ifcfg-eth0
# # TYPE=Ethernet
# # BOOTPROTO=static
# # PHYSDEV=eth0
# # ONBBOOT=yes
# # IPADDR=192.168.4.196
# # NETMASK=255.255.255.0
# # GATEWAY=192.168.88.254
# # USERCTL=no
# sudo sed -i 's/^BOOTPROTO=.*/BOOTPROTO=none/' /etc/resolv.conf
# sudo sed -i 's/^BOOTPROTO=.*/BOOTPROTO=none/' /etc/sysconfig/network-scipts/ifcfg-eth0

# # https://www.thegeekdiary.com/failed-to-start-lsb-bring-up-down-networking-on-restarting-network-service-centos-rhel-dhcp-client/
# sudo sed -i 's/^NETWORKING=.*/NETWORKING=yes/' /etc/sysconfig/network
# sudo sed -i 's/^PERSISTENT_DHCLIENT=.*/PERSISTENT_DHCLIENT=yes/' /etc/sysconfig/network
# sudo service network restart              ## For CentOS/RHEL 5/6
# sudo systemctl restart network 

# # https://techdocs.broadcom.com/us/en/ca-enterprise-software/it-operations-management/network-flow-analysis/10-0-0/installing/system-recommendations-and-requirements/linux-servers/disable-ipv6-networking-on-linux-servers.html
# sudo sed -i 's/^net.ipv6.conf.all.disable_ipv6.*/net.ipv6.conf.all.disable_ipv6 = 1/' /etc/sysctl.conf
# sudo sed -i 's/^net.ipv6.conf.default.disable_ipv6=.*/net.ipv6.conf.default.disable_ipv6 = 1/' /etc/sysctl.conf
# sudo reboot

# touch /etc/sysconfig/network
# # systemctl stop NetworkManager # https://www.cyberithub.com/failed-to-start-lsb-bring-up-down-networking/ - Please be careful in disabling NetworkManager in Production Systems as it might be disastrous sometimes. Please rethink before running above command.
# # systemctl start network

# # systemctl disable NetworkManager
# # systemctl enable network
# sudo systemctl disable NetworkManager && systemctl status NetworkManager
# sudo systemctl stop network && systemctl start network
# reboot

sudo yum upgrade -y
sudo yum install -y git

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

    # need to de-elevate root user before invoking ansible [ https://askubuntu.com/questions/617850/changing-from-user-to-superuser ]
    sudo chmod +x ./localhost.facts.sh
    echo vagrant | sudo su - vagrant -c "cd $(pwd) && sudo -u vagrant ./localhost.facts.sh" # need to figure out how to identify amazon boxes from redhat boxes

    sudo chmod +x ./localhost.play.sh
    echo vagrant | sudo su - vagrant -c "cd $(pwd) && sudo -u vagrant ./localhost.play.sh" # [ubuntu] can't read /root/.bashrc: Permission denied // For some reason this does not work

python3 -m pip freeze > "${dirpath}/pip.freeze.txt"
yum list installed > "${dirpath}/yum.list.installed.txt"
amazon-linux-extras > "${dirpath}/amazon-linux-extras.txt"

docker ps > "${dirpath}/docker-ps.txt"

docker inspect sonarqube_sonarqube_1 > "${dirpath}/docker-inspect-sonarqube_sonarqube_1.txt"
docker inspect sonarqube_db_1 > "${dirpath}/docker-inspect-sonarqube_db_1.txt"
docker inspect reverse-proxy_proxy_1 > "${dirpath}/docker-inspect-reverse-proxy_proxy_1.txt"

docker logs sonarqube_sonarqube_1 > "${dirpath}/docker-logs-sonarqube_sonarqube_1.txt"
docker logs sonarqube_db_1 > "${dirpath}/docker-logs-sonarqube_db_1.txt"
docker logs reverse-proxy_proxy_1 > "${dirpath}/docker-logs-reverse-proxy_proxy_1.txt"

# sudo cp /home/vagrant/pip.freeze.txt /vagrant/data/pip.freeze.txt
# sudo cp /home/vagrant/yum.list.installed.txt /vagrant/data/yum.list.installed.txt
# sudo cp /etc/redhat-release /vagrant/data/redhat-release
# sudo cp /etc/os-release /vagrant/data/os-release
# sudo cp /etc/vagrant_provisioned_at /vagrant/data/vagrant_provisioned_at
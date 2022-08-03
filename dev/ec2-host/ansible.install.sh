#supporting both debian and redhat, TODO: see how to support other package installers that have different commandline format
installer=$(which apt-get || which yum)

sudo $installer update -y
sudo $installer upgrade -y

sudo $installer install -y python3 # this overwrites the python installed manually for vagrant patching
sudo $installer install -y pip # [ubuntu] need to figure out the correct name of the package
sudo $installer install -y python3-wheel # [ubuntu]
sudo $installer install -y python3-pip # [centos]
sudo $installer install -y ansible # [centos] just avoid [ ansible-playbook: command not found ]

# https://stackoverflow.com/questions/3522341/identify-user-in-a-bash-script-called-by-sudo
# [ $SUDO_USER ] && user=$SUDO_USER || user=`whoami`
# echo "user=${user}"
user=$(id -u -n) # get actual user from invocation: [ sudo -u vagrant bash -c "./ansible.install.sh" ]

# # for some reason need to update PATH for root user [ ansible started with BECOME is run with root instead of localuser ] [ otherwise scripts fail with docker-compose not found ]
# # this does not work, because sh does not load the environment 
# sudo sed -i '/^.*export PATH.*$/d' /etc/profile
# sudo echo "export PATH=/usr/local/bin:"$PATH >> /etc/profile

#https://github.com/ansible/ansible/issues/67259
sed -i '/^.*export PATH.*$/d' /home/${user}/.bashrc
echo "export PATH=/home/${user}/.local/bin:${PATH}" >> /home/${user}/.bashrc

# source /home/${user}/.bashrc # this is not working

#add running permissions to the required files
# sudo chmod -R 777 ./ansible # need to figure out how to recreate permissions properly
# sudo chmod +x ./ansible/*.sh

# cd $(dirname "$0")
sudo chmod +x ./guest_install_python.sh
sudo -u ${user} ./guest_install_python.sh

#python3 -m pip install awscli
#python3 -m pip install aws-shell

python3 -m pip install --user --upgrade --force-reinstall pip # AVOID: [centos] ERROR: error: can't find Rust compiler
python3 -m pip install --user --upgrade wheel # AVOID: [centos] ERROR: 'pip wheel' requires the 'wheel' package
python3 -m pip install --user --upgrade --force-reinstall setuptools-rust # AVOID: [centos] https://github.com/MISP/misp-docker/issues/113 - ModuleNotFoundError: No module named 'setuptools_rust'
python3 -m pip install --user --upgrade --force-reinstall cryptography # AVOID: [centos] ERROR: error: can't find Rust compiler # NOTE: something is wrong with this on centos+python3.6
python3 -m pip install --user --upgrade ansible
python3 -m pip install --user --upgrade paramiko

#TODO: usually I prefer self restarting consoles, but that can be problematic over SSH
echo "user=${user}"
echo "WARNING: restart terminal for \$PATH changes to apply!"

#https://docs.docker.com/engine/install/debian/
# sudo apt-get remove docker docker-engine docker.io containerd runc
# sudo apt-get update
# sudo apt-get install \
#     apt-transport-https \
#     ca-certificates \
#     curl \
#     gnupg \
#     lsb-release
# curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
# echo \
#   "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
#   $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# sudo apt-get update
# sudo apt-get install docker-ce docker-ce-cli containerd.io
# #sudo apt-get install docker-ce=<VERSION_STRING> docker-ce-cli=<VERSION_STRING> containerd.io
# #sudo dpkg -i /path/to/package.deb
# sudo docker run hello-world
# Contents
This folder contains some vagrant boxes that can be run locally for easy testing of the the configuration.

        [ ./ ]
        |
        +---[ amazon/ ] - folder containing files for an amazon vagrant box
        |       |
        |       +---[ .vagrant/ ] - folder containing settings from vagrant after first init
        |       |
        |       +---[ data/ ] - folder containing logs collected after executing [ start-vagrant.sh ]
        |       |
        |       +---[ iso/ ] - folder containing amazon configuration files "this is alternative to vagrant boxes, using 2 .iso files, one containing the amazon base and the other seed.iso containing the configuration settings" - can be ignored in this
        |       |
        |       +---[ bootstrap.sh ] - file containing the commands that will be executed by vagrant during provisioning [ vagrant up ]
        |       |
        |       +---[ host_copy_back_logs.sh ] - file containing vagrant commands to copy files from the vagrant box into the shared folder [ /vagrant/data ]
        |       |
        |       +---[ host_install_vbox_additions.sh ] - file containing the commands to install the Virtual Box additions - this is required for accessing the shared folder from the DEV host and from the the Vagrant Box
        |       |
        |       +---[ start-vagrant.sh ] - file containing the commands to start up a vagrant box
        |       |
        |       +---[ Vagrantfile ] - file containing the definition of the BOX, including network settings and shared folder, as well as the startup script and extra environment variables [ bootstrap.sh ]
        |
        +---[ centos/ ]
        |       |
        |       +---[ .vagrant/ ]
        |       |
        |       +---[ data/ ]
        |       |
        |       +---[ bootstrap.sh ]
        |       |
        |       +---[ host_copy_back_logs.sh ]
        |       |
        |       +---[ host_install_vbox_additions.sh ]
        |       |
        |       +---[ start-vagrant.sh ]
        |       |
        |       +---[ Vagrantfile ]
        |
        |---[ ubuntu/ ]
        |       |
        |       +---[ .vagrant/ ]
        |       |
        |       +---[ data/ ]
        |       |
        |       +---[ bootstrap.sh ]
        |       |
        |       +---[ host_copy_back_logs.sh ]
        |       |
        |       +---[ start-vagrant.sh ]
        |       |
        |       +---[ Vagrantfile ]
        |
        +---[ .gitignore ]
        |
        +---[ README.MD ]

# Execution flow

    (HOST)[ cd amazon ] --- (HOST)[ ./start-vagrant.sh ] ---<starts vagrant>--- (HOST)[ Vagrantfile ] ---<after configuration mounts HOST:$CD as GUEST:/vagrant and executes>--- (GUEST)[ boostrap.sh ] 
                                |                                                                                                                                                           |
                                |                                                                                                                                                           +---(GUEST)[ ../../ec2-host/ansible-install.sh ] ---<launches script that installs prerequisites for ansible to run>---
                                |                                                                                                                                                           |
                                |                                                                                                                                                           +---(GUEST)[ ../../ec2-host/ansible/localhost.play.sh ] ---<launches playbooks>---
                                |                                                                                                                                                                                       |
                                |                                                                                                                                                                                       +---(GUEST)[ ../../ec2-host/ansible/playbook.yml ] ---<launches tasks for installing docker and starting the containers>---
                                |                                                                                                                                                                                                                   |
                                |                                                                                                                                                                                                                   +---(GUEST)[ ../../ec2-host/ansible/docker.install.<system>.tasks.yml ] ---<installs docker and docker-compose as well as their requirements>---
                                |                                                                                                                                                                                                                   |
                                |                                                                                                                                                                                                                   +---(GUEST)[ ../../ec2-host/ansible/sonarqube.start.tasks.yml ] ---<installs sonarqube container>---
                                |                                                                                                                                                                                                                   |
                                |                                                                                                                                                                                                                   +---(GUEST)[ ../../ec2-host/ansible/reverse-proxy.tasks.yml ] ---<installs reverse-proxy container>---
                                +--- (HOST)[ host_copy_back_logs.sh ] ---<copies back files>--- (HOST)[ ./data/ ]

# References

1. Setting up proper keyfile for vagrant box
    - https://stackoverflow.com/questions/29450404/is-there-a-default-password-to-connect-to-vagrant-when-using-homestead-ssh-for

2. Disabling shared folders
    - https://stackoverflow.com/questions/28328775/virtualbox-mount-vboxsf-mounting-failed-with-the-error-no-such-device
        - need to figure out how to avoid error
            - https://www.vagrantup.com/docs/synced-folders/basic_usage

3. Enable IP forwarding
    - https://learn.hashicorp.com/tutorials/vagrant/getting-started-networking
        Vagrant.configure("2") do |config|  
            config.vm.box = "hashicorp/bionic64"  
            config.vm.provision :shell, path: "bootstrap.sh"  
            config.vm.network :forwarded_port, guest: 80, host: 4567
        end
    - https://learn.hashicorp.com/tutorials/vagrant/getting-started-provisioning
        - need to run [ vagrant reload --provision ] to actually rerun the changes in bootstrap.sh

4. Create private network, accessible only from vagrant host
    - https://www.vagrantup.com/docs/networking/private_network

5. Disable git verification, which is insecure when cloning repo | run git command with localuser instead of root
    - https://stackoverflow.com/questions/23935138/cannot-clone-private-repo-from-vagrant-provision-file
        - actually run git command with vagrant user
            [ sudo -u vagrant git clone https://github.com/headshot4good/aws-ec2-ansible-docker-sonarqube.git ]
    
6. Vagrant not installing packages during provisioning
    - https://stackoverflow.com/questions/35247732/vagrant-shell-provisioning-not-installing
        - [ sudo apt-get -y update;sudo apt-get -y upgrade ]

7. Logs of issues with centos deployment
    - https://cryptography.io/en/latest/faq/

8. Get extra information about packages and distro
    - https://askubuntu.com/questions/17823/how-to-list-all-installed-packages
    - https://www.cyberciti.biz/faq/check-list-installed-packages-in-centos-linux/
    - https://www.cyberciti.biz/faq/how-do-i-determine-rhel-version/
    - https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/


            SECURITY:
                - I just saw that there probably is no way to check from where the packages were downloaded as pip was running or os package installers were running
                    - need to collect logs from the actual installation process, because of this reason    
                    +++ an idea is to create local mirrors for all the assets used, that way commands run faster
                        +++ more advanced would be to redirect all installation queries to a local cache system which ensures the same packages will be installed every time

9. Vagrant mounted folder permissions
    - https://serverfault.com/questions/398414/vagrant-set-default-share-permissions
    - https://stackoverflow.com/questions/28157780/recurring-vagrant-error-operation-not-permitted-on-action-create-on-an-nfs-re
    - https://www.vagrantup.com/docs/synced-folders/nfs
        - this is the most comprehensive one
    - https://www.vagrantup.com/docs/synced-folders

10. Official Vagrant Amazon Linux image does not work from https://serverfault.com/questions/506025/vagrant-box-most-similar-to-amazon-ec2-instances
    - https://aws.amazon.com/amazon-linux-2/
        - download directly image from: https://cdn.amazonlinux.com/os-images/2.0.20210721.2/virtualbox/

    - [ https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/amazon-linux-2-virtual-machine.html ]
        - need to create a seed.iso which contains the user password and network configuration
    
    - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/amazon-linux-2-virtual-machine.html#amazon-linux-2-virtual-machine-download

    ## Amazon need to disable cloud-init on first boot
    - https://serverfault.com/questions/717219/how-to-disable-executing-user-data-by-cloud-init
    - https://askubuntu.com/questions/405442/how-can-i-disable-cloud-init

            touch /etc/cloud/cloud-init.disabled

    => https://www.how2shout.com/linux/download-amazon-linux-2-to-install-on-virtualbox/
        - this is comprehensive, but uses the 2 *.iso files
    - https://gist.github.com/sebsto/6441df09e97c4cbbd22b8ba313b8d642
        - gist example for *.iso 's method

11. Vagrant disk size control 
    https://www.vagrantup.com/docs/disks/usage
        - should reduce from 25GB standard to 10-15GB

12. Vagrant install according guest additions plugin
    https://stackoverflow.com/questions/38010519/guestadditions-version-mismatch
    https://superuser.com/questions/1133345/cant-install-virtualbox-guest-additions

13. Docker, getting weird errors like "too many symbolic links"
    https://github.com/docker/for-win/issues/5763

14. Ansible 4.4.0 broken on Centos-8 with python-3.6
    https://stackoverflow.com/questions/3083235/unzipping-file-results-in-badzipfile-file-is-not-a-zip-file

15. Installing python
    https://www.liquidweb.com/kb/how-to-install-python-3-on-centos-7/    

16. Changing symlinks
    https://unix.stackexchange.com/questions/88824/how-can-i-edit-symlinks

17. Installing python with SSL package
    https://stackoverflow.com/questions/41328451/ssl-module-in-python-is-not-available-when-installing-package-with-pip3
        - otherwise getting weird error that could not verify the certificate for [ pypi.org ] where python packages are installed from
            - 'SSLError("Can't connect to HTTPS URL because the SSL module is not available."
                - https://stackoverflow.com/questions/49094768/ssl-module-in-python-is-not-available/50888765
                    - just add [ --with-ssl ] when installing python

18. Restart vagrant and ruby 

        cmd -c "taskkill.exe /f /fi 'IMAGENAME eq vagrant.exe'" && \
        cmd -c "taskkill.exe /f /fi 'IMAGENAME eq ruby.exe'"

19. list installed packages on Debian
    https://linuxize.com/post/how-to-list-installed-packages-on-debian/

20. Vagrant, 1/2 amazon-linux starts crashes
    - need to figure out why this happens, its like when the VM is created some resources are downloaded from upstream, and there is like a load balancer between 2 CDN instances, and one has resources that cause the VM to crash after it installs the VirtualBox Guest Additions.
        - figured it has something to do with the incompatible vbox-additions
            - need to close the machine from the SSH shell, instead of using the VirtualBox GUI
                - using the VirtualBox GUI, will leave some hanging processes [ vagrant.exe, ruby.exe ], and the next redeplyoment will fail, and will need to wait until then to successfully remove machine
            - if closed from the SSH shell, then the machine can be removed afterwards from the VirtualBox GUI

21. After everything works, sonarqube stopped loading for Ubuntu

        warning: no-jdk distributions that do not bundle a JDK are deprecated and will be removed in a future release
        OpenJDK 64-Bit Server VM warning: Option UseConcMarkSweepGC was deprecated in version 9.0 and will likely be removed in a future release

    - https://github.com/elastic/elasticsearch/issues/43911

22. Centos - installing guest additions
    - https://www.tecmint.com/install-virtualbox-guest-additions-in-centos-rhel-fedora/
    - https://bobcares.com/blog/modprobe-vboxguest-failed-ubuntu/
        - install headers and reboot machine
        - install virtual box additions and reboot machine
            - if it does not work then use mounted folders
                - or use the file manager menu from vbox

23. CENTOS - podman and buildah conflict with docker-ce
    - https://unix.stackexchange.com/questions/611228/getting-series-of-file-conflicts-like-runc-and-containerd-when-trying-to-install/611231

24. Vagrant - figure out how to create a testing environment locally
    - https://stackoverflow.com/questions/15243405/is-it-possible-for-vagrant-to-use-an-os-iso-install-image-directly-or-create-a
    - https://www.vagrantup.com/docs/boxes/base
        - create base boxes locally for different VM engines

25. Amazon linux not shown in available repo sources for docker # todo: need to make a different playbook for installing prerequisites
    [ https://download.docker.com/linux/ ]

        centos/
        debian/
        fedora/
        raspbian/
        rhel/
        sles/
        static/
        ubuntu/
    => Follow this tutorial: https://gist.github.com/npearce/6f3c7826c7499587f00957fee62f8ee9
    - [ https://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html ]
        - official docs
    - [ https://aws.amazon.com/blogs/compute/executing-ansible-playbooks-in-your-amazon-ec2-image-builder-pipeline/ ]

26. Python virtual env - CENTOS
    - https://www.liquidweb.com/kb/how-to-setup-a-python-virtual-environment-on-centos/
# Contents
This folder contains some split folders, on one side some code that will be executed locally and on the other side code that is executed by the deployed machines.

        [ ./ ]
        |
        +---[ dev/ ] - folder containing scripts to be executed on the (DEV)
        |       |
        |       +---[ ec2-host/ ] - folder containing the scripts to be executed on the (EC2-HOST)
        |       |       |
        |       |       +---[ ansible/ ] - folder containing ansible playbooks and scripts
        |       |       |       |
        |       |       |       +---[ reverse-proxy/ ] - folder containing scripts for deploying docker container of an NGINX proxy 
        |       |       |       |           |
        |       |       |       |           +---[ nginx/ ] - folder containing settings specific to NGINX
        |       |       |       |           |       |
        |       |       |       |           |       +---[ includes/ ]
        |       |       |       |           |       |       |
        |       |       |       |           |       |       +---[ proxy_pass.conf ] - file containing the proxy redirection 
        |       |       |       |           |       |
        |       |       |       |           |       +---[ ssl/ ]
        |       |       |       |           |       |       |
        |       |       |       |           |       |       +---[ generate-certificate-and-key.sh ] - script for generating self signed certificate for the SSL connection
        |       |       |       |           |       |       |
        |       |       |       |           |       |       +---[ ssl.config ] - config file for SSL cerficate
        |       |       |       |           |       |
        |       |       |       |           |       +---[ backend-not-found.html ] - webpage to be displayed if a missing endpoint is accessed via the proxy
        |       |       |       |           |       |
        |       |       |       |           |       +---[ default.conf ] - main config file for NGINX
        |       |       |       |           |
        |       |       |       |           +---[ docker-compose.yml ] - file containing settings for docker-compose setup of the container
        |       |       |       |           |
        |       |       |       |           +---[ Dockerfile ] - file containing the settings for docker
        |       |       |       |           |
        |       |       |       |           +---[ README.MD ] - more details about NGINX and the associated docker container
        |       |       |       |           |
        |       |       |       |           +---[ start-docker.sh ] - script to start the docker container via docker-compose
        |       |       |       |
        |       |       |       |
        |       |       |       |
        |       |       |       +---[ roles/ ] - unused folder for not - folder for storing ansible roles
        |       |       |       |
        |       |       |       |
        |       |       |       |
        |       |       |       +---[ sonarqube/ ] - folder containing scripts for deploying docker container for sonarqube
        |       |       |       |       |
        |       |       |       |       +---[ docker-compose.yml ] - file containing the settings for docker-compose
        |       |       |       |       |
        |       |       |       |       +---[ postgres_pass.env ] - file containing the POSTGRES passwords
        |       |       |       |       |
        |       |       |       |       +---[ sonarqube_pass.env ] - file containing the SONARQUBE passwords
        |       |       |       |       |
        |       |       |       |       +---[ start-docker.sh ] - script to start the docker container
        |       |       |       |
        |       |       |       |
        |       |       |       |
        |       |       |       +---[ vars/ ] - folder containing ansible settings
        |       |       |       |       |
        |       |       |       |       +---[ default.yml ] - file containing ansible variables
        |       |       |       |
        |       |       |       |
        |       |       |       |
        |       |       |       +---[ ansible.cfg ] - file containing ansible configurations - defines default inventory file
        |       |       |       |
        |       |       |       |
        |       |       |       |
        |       |       |       +---[ cleanup.yml ] - file containing ansible tasks to undo the ansible deployment
        |       |       |       |
        |       |       |       |
        |       |       |       |
        |       |       |       +---[ docker.install.amazon.tasks.yml ] - file containing ansible tasks to perform for AMAZON-LINUX deployment of docker
        |       |       |       |
        |       |       |       +---[ docker.install.debian.tasks.yml ] - file containing ansible tasks to perform for DEBIAN deployment of docker
        |       |       |       |
        |       |       |       +---[ docker.install.redhat.tasks.yml ] - file containing ansible tasks to perform for REDHAT - centos deployment of docker
        |       |       |       |
        |       |       |       |
        |       |       |       |
        |       |       |       +---[ facts.yml ] - file containing ansible tasks to dump ansible facts
        |       |       |       |
        |       |       |       +---[ inventory.yml ] - file containing ansible inventory definitions
        |       |       |       |
        |       |       |       +---[ localhost.cleanup.sh ] - file for starting [ cleanup.yml ] playbook locally
        |       |       |       |
        |       |       |       +---[ localhost.facts.sh ] - file for starting [ facts.yml ] playbook locally
        |       |       |       |
        |       |       |       |
        |       |       |       |
        |       |       |       +---[ localhost.play.sh ] - file for starting [ playbook.yml ] playbook locally
        |       |       |       |
        |       |       |       +---[ playbook.yml ] - file containing the entry point for ansible configuration
        |       |       |       |
        |       |       |       |
        |       |       |       |
        |       |       |       +---[ python.install.tasks.yml ] - file containing the tasks to deploy python - unused for now
        |       |       |       |
        |       |       |       |
        |       |       |       |
        |       |       |       +---[ reverse-proxy.start.tasks.yml ] - file containing the tasks to deploy the [ reverse-proxy ]
        |       |       |       |
        |       |       |       +---[ sonarqube.start.tasks.yml ] - file containing the tasks to deploy the [ sonarqube ]
        |       |       |
        |       |       |
        |       |       |
        |       |       +---[ ansible.install.sh ] - file containing commands that install prerequisites for ansible
        |       |       |
        |       |       +---[ guest_install_python.sh ] - file containing commands that install python 3.9, and python dependencies
        |       |       |
        |       |       +---[ start-ansible.sh ] - file contaning commands that will deploy the machine
        |       |
        |       |
        |       |
        |       +---[ vagrant/ ] - contains the vagrant boxes - view [ README.MD ] for details
        |       |
        |       |
        |       |
        |       +---[ add-hosts.sh ] - unused file - ignore for now
        |       |
        |       +---[ config ] - unused file - ignore for now
        |       |
        |       +---[ load-vars.sh ] - unused file - ignore for now
        |       |
        |       +---[ ssh.sh ] - unused file - ignore for now
        |
        |
        |
        +---[ .gitignore ]
        |
        +---[ README.MD ]

# Execution flow

## REMOTE:
- user - should not be the root user
1. Run on the HOST the following command to open SSH terminal, then enter the password and press ENTER

        ssh <user>@<aws_instance_ip>

2. Once connected to the GUEST run the following command line to start the deployment, the command contains multiple steps linked together

        sudo $(which apt-get || which yum) install -y git && \
        rm -rf ./aws-ec2-ansible-docker-sonarqube && \
        git clone https://github.com/mihaitester/aws-ec2-ansible-docker-sonarqube.git && \
        chmod +x ./aws-ec2-ansible-docker-sonarqube/dev/ec2-host/start-ansible.sh && \
        ./aws-ec2-ansible-docker-sonarqube/dev/ec2-host/start-ansible.sh 

## LOCALLY:
- prerequisites: 
    - Virtual Box 6.1.26 [ https://www.virtualbox.org/wiki/Download_Old_Builds_6_1 ]
    - Vagrant [ https://www.vagrantup.com/downloads ] 
    - Git-Bash [ https://git-scm.com/downloads ]

1. Open a terminal on the HOST in the current dir and then run the following, this command will start a vagrant box, which will self configure itself and will expose the container outside the GUEST VM to the HOST system through IP [ 192.168.10.11 - 192.168.10.13 ]

        cd ./dev/vagrant/amazon && \
        start-vagrant.sh

# NOTES:
- currently local deployment will take some time, since there will be a lot of prerequisites installed
    - to fix this, a Vagrant box could be configured, and then run from it the ansible-playbooks on a remote machine, thus installing less packages

# TODO
- move ansible scripts into roles - change task lists to roles, add specific user to run with for each command
- hide passwords - use some ignored config files
- template files
- make remote execution scripts
- document step by step how scripts run and what they do
    - perhaps make it sepparate
- have a quick tutorial to get started really fast and understand most issues
- hide even IPs - use some config files
- generate SSH keys on the HOST, inject them into the deployed system, remove password login for user, remove root login [ both password and key ]

# References

## GLOSARY
- docker
- docker-compose
- ansible
- aws
- ec2-host
- sonarqube
- postgres_sql
- nginx
- python
- amazon-linux
- centos
- ubuntu

## Useful Git commands
1. add a tag as a sepparate commit [ https://git-scm.com/book/en/v2/Git-Basics-Tagging ]

        git tag -a v1.4 -m "my version 1.4"

2. checkout a tag [ https://devconnected.com/how-to-checkout-git-tags/ ]

        git checkout tags/v1.0

3. delete tag locally [ https://stackoverflow.com/questions/5480258/how-to-delete-a-remote-tag ]

        git tags --delete v1.2

4. delete a remote tag that is already pushed

        git push --delete origin v1.2

## Useful AWS considerations and commands
1. Download and install AWS-CLI from [ https://aws.amazon.com/cli/?c=dv&sec=srv ]
    - login on AWS
    - create an AWS key and will get 
2. Basic AWS-CLI usage examples [ https://www.youtube.com/watch?v=JscvSRcFbuA = AWS CLI Explained with Examples | Install AWS CLI | AWS Tutorial for Beginners ]
3. AWS-CLI Security Groups - useful for limiting access to the EC2-HOSTS
    [ https://www.youtube.com/watch?v=sLtf7Sx8lsQ = AWS CLI Tutorial | Introduction To AWS Command Line Interface | AWS Training | Edureka ]
    [ https://github.com/aws/aws-cli ] - commandline tool to log in and configure EC2 VM instance
    [ https://github.com/awslabs/aws-shell ] - more powerful version of awscli which has autocomplete support for faster typing of commands
4. Sign-in - Sign in using a custom URL 
    [ https://account_alias_or_id.signin.aws.amazon.com/console/ ].
        - You must replace account_alias_or_id with the account alias or account ID provided by the root user.

## Useful Virtual Box considerations
1. manual installation of a test box
    - Download virtualbox [ https://www.virtualbox.org/wiki/Downloads ]
    - Download iso [ https://ubuntu.com/download/desktop ]
    - Install virtual box
    - Create new VM
        - 4GB RAM
        - 20GB VDI - 10GB is just not enough due to installing a lot of packages
        - Install OS
        - Install VirtualBox Guest Additions - from the top select insert Guest Additions ISO
        - Reboot VM
    - Use Drag-and-drop feature to share files - faster than mounting manually a shared folder

## Useful BASH considerations and commands

1. in AMAZON-LINUX there is no way to skip '\r' unless the scripts are sanitized somehow with TR before executing them
    - therefore remember to save all BASH scripts with LF instead of CRLF [ this is a problem only if developing on WINDOWS ]
        - [ https://unix.stackexchange.com/questions/355559/bash-and-carriage-return-behavior ]
2. check login attempts on the system 

        sudo cat /var/log/secure

3. check active connections to a remote system 
    [ https://www.golinuxcloud.com/list-check-active-ssh-connections-linux/ ]
    [ https://unix.stackexchange.com/questions/92560/list-all-connected-ssh-sessions ]

        sudo netstat -tnpa | grep 'ESTABLISHED.*sshd'
        ps auxwww | grep sshd:
        ps ax | grep sshd
        who -a
        ss | grep -i ssh

4. disable remote login for a specific user [ https://www.tecmint.com/disable-root-login-in-linux/ ]
    
        sudo vim /etc/passwd
        # changed [ 
        #    root:x:0:0:root:/root:/bin/bash 
        # ] to [ 
        #    root:x:0:0:root:/root:/sbin/nologin
        # ]

5. terminate another user's shell connection
    - get the terminal PID

            ps aux | egrep "sshd: [a-zA-Z]+@" ]
            sudo kill -9 PID

6. disable SSH keys that could be exploited
    [ https://stackoverflow.com/questions/25464930/how-can-i-remove-an-ssh-key ]
    [ https://serverfault.com/questions/129279/invalidating-unused-ssh-keys/129309 ]
7. SSH and SCP - copy files through SSH tunnel
    [ https://serverspace.io/support/help/copy-files-and-run-commands-through-ssh/ ]
8. SSH configuring through [ .env ] files
    [ https://stackoverflow.com/questions/19331497/set-environment-variables-from-file-of-key-value-pairs/19331521 ]

## Useful Docker commands and mentions
1. remove all docker networks - useful when rebuilding the networks between containers - will require stopping the containers before networks are closed

        docker network rm $(docker network ls -q)

    - TODO: figure out how to link docker networks, instead of attaching containers to multiple networks
2. remove docker containers that got exited [ https://docs.docker.com/engine/reference/commandline/rm/ ]

        docker rm $(docker ps --filter status=exited -q)
        docker rm $(docker ps --all -q) # removes everything that is not running

3. remove docker all docker images [ https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes ]

        docker rmi $(docker images -a -q)

4. Using docker-compose [ https://docs.docker.com/compose/reference/up/ ]
    - docker-compose is useful when starting up multiple containers within a singular network, it allows for easier management of multiple docker containers that need to be linked
        - however there is the following quirk: [ -f ] option with subdir files does not work 
            => because of this the [ start-docker.sh ] scripts need to change current directory to that where the script resides
5. when defining the networks in the [ docker-compose.yml ] will need to provide the following flag [ external: yes ], otherwise docker-compose will create a new network with that name, instead of connecting to the existing predefined network

        networks:
          - outside: external=yes

## Useful documentation about SonarQube
1. Setup
    - https://blog.setapp.pl/sonarqube_introduction
    - https://docs.sonarqube.org/latest/setup/operate-server/#header-5
    - https://hub.docker.com/_/sonarqube
    - https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html#docker-cli-run-prod-mode
    - https://docs.sonarqube.org/latest/setup/install-server/
2. Monitoring
    - https://docs.sonarqube.org/latest/setup/sonarqube-on-kubernetes/
        - prometheus exporter

## Useful documentation on reverse_proxy, using NGINX
1. Introduction
    - https://kemptechnologies.com/emea/reverse-proxy/reverse-proxy/
    - https://www.docker.com/blog/how-to-use-the-official-nginx-docker-image/

            ./ansible/reverse-proxy/README.MD

## Useful information about Ansible usage
1. Ansible usage:
    - https://www.youtube.com/watch?v=1id6ERvfozo = What is Ansible | Ansible Playbook explained | Ansible Tutorial for Beginners
    - https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html
    - https://docs.ansible.com/ansible/latest/network/getting_started/first_inventory.html
    - https://docs.ansible.com/ansible/2.9/user_guide/intro_inventory.html
    - https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html
2. Ansible tests
    - https://docs.ansible.com/ansible/latest/user_guide/playbooks_tests.html
3. Ansible breakdown into playbooks and taskfiles
    - https://docs.ansible.com/ansible/2.4/playbooks_reuse_includes.html
4. Ansible config - potential source for issues
    - https://docs.ansible.com/ansible/latest/reference_appendices/config.html#ansible-configuration-settings
5. Ansible conditionals and roles - choose between multiple installers, based on environment
    - https://docs.ansible.com/ansible/2.3/playbooks_conditionals.html
    - https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html
        - probably have to define different playbooks based on environment, but then those will be hard to maintain over time
            - these seem to be able to group tasks and config files together, which should reduce the code that has to be maintained
                - example: having to fork tasks into 2 playbooks, one for yum and one for apt-get
6. Ansible - run command as specific issue
    - https://serverfault.com/questions/662443/running-ansible-task-as-a-specific-user
    - https://docs.ansible.com/ansible/latest/user_guide/become.html
        - using become escalates the commands being run, but then those shells do not have access to the full PATH
            - https://stackoverflow.com/questions/21344777/how-to-switch-a-user-per-task-or-set-of-tasks
7. Ansible filters for variables
    [ https://docs.ansible.com/ansible/latest/user_guide/playbooks_filters.html ]

        {{ ansible_facts | to_nice_json(indent=2) }}

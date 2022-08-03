source ./load-vars.sh 
echo "sudo \$(which apt-get || which yum) install -y git && git clone "${REPO}" && chmod +x ./aws-ec2-ansible-docker-sonarqube/dev/ec2-host/start-ansible.sh && ./aws-ec2-ansible-docker-sonarqube/dev/ec2-host/start-ansible.sh" > ./temp.sh
cat ./temp.sh | ssh $USER@$HOST -t 'sudo bash -s' #https://stackoverflow.com/questions/21659637/how-to-fix-sudo-no-tty-present-and-no-askpass-program-specified-error
rm -f ./temp.sh
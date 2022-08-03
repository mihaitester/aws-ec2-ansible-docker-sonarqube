vagrant up --provision #|| vagrant reload --provision

# Virtualbox on your host claims:   6.0.0
# VBoxService inside the vm claims: 6.1.26
vagrant plugin install vagrant-vbguest #https://stackoverflow.com/questions/46318456/files-created-in-vagrant-centos-7-do-not-appear-in-windows # https://stackoverflow.com/questions/38010519/guestadditions-version-mismatch

./host_copy_back_logs.sh

ping 192.168.10.13 # test server is up
curl https://192.168.10.13 --insecure | grep -o SonarQube # test webpage loads and test proxy redirect works

vagrant ssh

read -p "[ Press any key to exit ... ]"
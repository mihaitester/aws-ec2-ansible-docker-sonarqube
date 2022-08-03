vagrant up --provision #|| vagrant reload --provision

# vagrant plugin install vagrant-disksize

# ./host_install_vbox_additions.sh
./host_copy_back_logs.sh

ping 192.168.10.11 # test server is up
curl https://192.168.10.11 --insecure | grep -o SonarQube # test webpage loads and test proxy redirect works

# vagrant rsync-auto #https://stackoverflow.com/questions/40972345/vagrant-synced-folders-not-working-real-time-on-virtualbox
vagrant ssh

read -p "[ Press any key to exit ... ]"
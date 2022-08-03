vagrant up --provision #|| vagrant reload --provision

./host_install_vbox_additions.sh
./host_copy_back_logs.sh

vagrant rsync-auto #https://stackoverflow.com/questions/40972345/vagrant-synced-folders-not-working-real-time-on-virtualbox

ping 192.168.10.12 # test server is up
curl https://192.168.10.12 --insecure | grep -o SonarQube # test webpage loads and test proxy redirect works

vagrant ssh

read -p "[ Press any key to exit ... ]"
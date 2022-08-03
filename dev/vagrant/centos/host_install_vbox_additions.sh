# GOOGLE: centos install vbox additions vagrant => https://gist.github.com/clivewalkden/b4df0074fc3a84f5bc0a39dc4b344c57
vagrant plugin install vagrant-vbguest #https://stackoverflow.com/questions/46318456/files-created-in-vagrant-centos-7-do-not-appear-in-windows # https://stackoverflow.com/questions/38010519/guestadditions-version-mismatch

timeout=5

vagrant ssh -c "sudo yum -y update"
vagrant ssh -c "sudo yum -y epel-release"
vagrant ssh -c "sudo yum -y install wget nano kernel-devel kernel-headers gcc make perl"
vagrant ssh -c "sudo dnf install -y gcc make perl kernel-devel kernel-headers bzip2 dkms"
# Need a reboot: https://forums.centos.org/viewtopic.php?t=69071

sleep ${timeout}
vagrant halt   # TODO: need to split this file into multiple boostrap.sh and generate a vagrant file for each step
vagrant reload

# http://download.virtualbox.org/virtualbox/
version="6.1.26" # [ "C:\Program Files\Oracle\VirtualBox\vboxmanage.exe" -v ]

vagrant ssh -c "sudo cd /opt && sudo wget https://download.virtualbox.org/virtualbox/${version}/VBoxGuestAdditions_${version}.iso -O /opt/VBGAdd.iso"
vagrant ssh -c "sudo mount /opt/VBGAdd.iso -o loop /mnt"
vagrant ssh -c "sudo sh /mnt/VBoxLinuxAdditions.run --nox11"
vagrant ssh -c "sudo umount /mnt"
vagrant ssh -c "sudo rm /opt/VBGAdd.iso"

sleep ${timeout}
vagrant halt # reboot VM to apply changes
vagrant reload --provision
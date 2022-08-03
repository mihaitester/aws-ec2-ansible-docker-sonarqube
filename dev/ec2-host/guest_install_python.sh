# https://stackoverflow.com/questions/3522341/identify-user-in-a-bash-script-called-by-sudo
[ $SUDO_USER ] && user=$SUDO_USER || user=`whoami`
echo "user=${user}"

# https://stackoverflow.com/questions/41328451/ssl-module-in-python-is-not-available-when-installing-package-with-pip3
# For Debian:
sudo apt-get install -y libbz2-dev libffi-dev libssl-dev
# ./configure --enable-optimizations
# make
# make altinstall
# For CentOS:
sudo yum install -y bzip2-devel libffi-devel openssl-devel
# ./configure --enable-optimizations
# make
# make altinstall

if [ -f "/usr/bin/python3.9" ]; then echo "Skipping python installation" && exit; else echo "Installing python ..."; fi # https://linuxize.com/post/bash-check-if-file-exists/

# Install updated python on centos-8 [ https://www.liquidweb.com/kb/how-to-install-python-3-on-centos-7/ ]
version="3.9.6"
cd /home/${user}/
    curl -O "https://www.python.org/ftp/python/${version}/Python-${version}.tgz"
    tar -xzf "Python-${version}.tgz"
    cd "Python-${version}/"
        
        sudo ./configure --enable-optimizations --with-ssl --with-local-prefix=/usr > ./configure.txt # https://unix.stackexchange.com/questions/346133/gcc-compilation-terminated-with-fatal-error-string-no-such-file-or-directory
        # sudo make altinstall
        sudo make install > ./make-install.txt
        sudo cp /usr/bin/python3 /usr/bin/__previous__python3
        sudo rm -f /usr/bin/python3
        
        # sudo ln -s /usr/bin/python3.9 /usr/bin/python3
        sudo ln -s "/home/${user}/Python-${version}/python" /usr/bin/python3
        sudo chmod +x /usr/bin/python3

        # https://www.toptechskills.com/ansible-tutorials-courses/how-to-fix-usr-bin-python-not-found-error-tutorial/
        # sudo ln -s /usr/bin/python3 /usr/bin/python

        # https://stackoverflow.com/questions/46752279/lsb-release-not-working-after-install-python-3-6-3-from-source
        # sudo apt-get purge -y lsb-release
        # sudo apt-get install -y lsb-release # this pops up a interrupting screen
        sudo mv -f /usr/bin/lsb_release /usr/bin/lsb_release_back

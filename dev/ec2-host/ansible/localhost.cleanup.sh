#use the inventory to apply the playbook on the hosts defined, assuming the local connection, and elevating and getting the elevation pass
# https://www.cyberciti.biz/faq/appleosx-bsd-shell-script-get-current-user/
user=$(id -u -n) # get actual user from invocation: [ sudo -u vagrant bash -c "./ansible.install.sh" ]
# su -l ${user} -c "cd $(pwd) && /home/${user}/.local/bin/ansible-playbook -i inventory.yml facts.yml --connection=local --become --ask-become-pass" # https://unix.stackexchange.com/questions/156962/how-to-change-to-normal-user-in-the-command-line-when-logged-in-as-the-root-user
/home/${user}/.local/bin/ansible-playbook -i inventory.yml facts.yml --connection=local --become --ask-become-pass # https://unix.stackexchange.com/questions/156962/how-to-change-to-normal-user-in-the-command-line-when-logged-in-as-the-root-user
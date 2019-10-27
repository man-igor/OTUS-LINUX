#!/usr/bin/env bash
sudo bash -c "sed -i 's/^PasswordAuthentication.*$/PasswordAuthentication yes/' /etc/ssh/sshd_config && systemctl restart sshd.service"
sudo sed -i '/pam_nologin.so/a account  required   pam_exec.so  /usr/local/bin/login.sh'  /etc/pam.d/sshd
sudo groupadd admin
sudo useradd user1 && echo "Otus2019" | sudo passwd --stdin user1
sudo useradd user2 && echo "Otus2019" | sudo passwd --stdin user2
sudo useradd user3 && echo "Otus2019" | sudo passwd --stdin user3
sudo usermod -a -G admin user1
sudo cp /vagrant/login.sh /usr/local/bin/
sudo sh -c 'cat  << EOF > /etc/sudoers.d/user3
%user3 ALL=(ALL) NOPASSWD: ALL
EOF'

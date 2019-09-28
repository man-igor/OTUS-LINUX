#!/usr/bin/env bash
sudo yum install -y gcc wget rpmdevtools openssl-devel createrepo
wget https://nginx.org/packages/mainline/centos/7/SRPMS/nginx-1.17.4-1.el7.ngx.src.rpm
rpmdev-setuptree
rpm -Uvh nginx-1.17.4-1.el7.ngx.src.rpm 
#vi rpmbuild/SPECS/nginx.spec 
rpmbuild -bb rpmbuild/SPECS/nginx.spec
rpmbuild -bb rpmbuild/SPECS/nginx.spec
sudo rpm -i rpmbuild/RPMS/x86_64/nginx-1.17.4-1.el7.ngx.x86_64.rpm
sudo rm -f /usr/share/nginx/html/*
sudo createrepo /usr/share/nginx/html/
sudo cp rpmbuild/RPMS/x86_64/nginx-1.17.4-1.el7.ngx.x86_64.rpm /usr/share/nginx/html/repodata/
sudo createrepo /usr/share/nginx/html/
sudo systemctl start nginx.service
sudo sed -i '/index.htm;/a\     autoindex on;' /etc/nginx/conf.d/default.conf
sudo systemctl reload nginx.service 
sudo sh -c 'cat << EOF > /etc/yum.repos.d/otus.repo
[otus]
name=Otus-Linux
baseurl=http://192.168.33.10
enabled=1
gpgcheck=0
EOF'

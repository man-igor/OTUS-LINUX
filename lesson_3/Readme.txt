 wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.3.1.tar.xz
 tar -xvf linux-5.3.1.tar.xz
 cd linux-5.3.1/
 yum install gcc ncurses-devel bison flex elfutils-libelf-devel openssl-devel perl bc
 cp -v /boot/config-$(uname -r) .config
 make menuconfig
 make
 make modules_install
 make install
 grubby --set-default /boot/vmlinuz-5.3.1

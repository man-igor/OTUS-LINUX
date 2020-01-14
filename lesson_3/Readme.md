Уменьшить том под / до 8G.


Подготовим временный том для / 
[root@lesson03 ~]# pvcreate /dev/sdb
  Physical volume "/dev/sdb" successfully created.
[root@lesson03 ~]# vgcreate vg_root /dev/sdb
  Volume group "vg_root" successfully created
[root@lesson03 ~]# lvcreate -n lv_root -l +100%FREE /dev/vg_root
  Logical volume "lv_root" created.
[root@lesson03 ~]# mkfs.xfs /dev/vg_root/lv_root
meta-data=/dev/vg_root/lv_root   isize=512    agcount=4, agsize=655104 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=0, sparse=0
data     =                       bsize=4096   blocks=2620416, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
[root@lesson03 ~]# mount /dev/vg_root/lv_root /mnt
[root@lesson03 ~]# xfsdump -J - /dev/centos/root | xfsrestore -J - /mnt
xfsdump: using file dump (drive_simple) strategy
xfsdump: version 3.1.7 (dump format 3.0)
xfsrestore: using file dump (drive_simple) strategy
xfsrestore: version 3.1.7 (dump format 3.0)
xfsdump: level 0 dump of lesson03:/
xfsdump: dump date: Mon Jan 13 14:26:28 2020
xfsdump: session id: 01793bd7-b933-4581-94e5-d6e66077da50
xfsdump: session label: ""
xfsrestore: searching media for dump
xfsdump: ino map phase 1: constructing initial dump list
xfsdump: ino map phase 2: skipping (no pruning necessary)
xfsdump: ino map phase 3: skipping (only one dump stream)
xfsdump: ino map construction complete
xfsdump: estimated dump size: 1401425280 bytes
xfsdump: creating dump session media file 0 (media 0, file 0)
xfsdump: dumping ino map
xfsdump: dumping directories
xfsrestore: examining media file 0
xfsrestore: dump description:
xfsrestore: hostname: lesson03
xfsrestore: mount point: /
xfsrestore: volume: /dev/mapper/centos-root
xfsrestore: session time: Mon Jan 13 14:26:28 2020
xfsrestore: level: 0
xfsrestore: session label: ""
xfsrestore: media label: ""
xfsrestore: file system id: e5921e5a-1a59-4bd5-965f-4bf50bb68336
xfsrestore: session id: 01793bd7-b933-4581-94e5-d6e66077da50
xfsrestore: media id: 1f65ea83-f886-43b1-878d-c89f4d17c2f6
xfsrestore: searching media for directory dump
xfsrestore: reading directories
xfsdump: dumping non-directory files
xfsrestore: 4968 directories and 35312 entries processed
xfsrestore: directory post-processing
xfsrestore: restoring non-directory files
xfsdump: ending media file
xfsdump: media file size 1367525232 bytes
xfsdump: dump size (non-dir files) : 1346934128 bytes
xfsdump: dump complete: 26 seconds elapsed
xfsdump: Dump Status: SUCCESS
xfsrestore: restore complete: 26 seconds elapsed
xfsrestore: Restore Status: SUCCESS

Проверим, что всё скопировалось:
[root@lesson03 ~]# ls /mnt/
bin  boot  dev  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
[root@lesson03 ~]# for i in /proc/ /sys/ /dev/ /run/ /boot/; do mount --bind $i /mnt/$i; done
Cделаем в него chroot и обновим grub:
[root@lesson03 ~]# chroot /mnt/
[root@lesson03 /]# grub2-mkconfig -o /boot/grub2/grub.cfg
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-3.10.0-1062.9.1.el7.x86_64
Found initrd image: /boot/initramfs-3.10.0-1062.9.1.el7.x86_64.img
Found linux image: /boot/vmlinuz-3.10.0-957.el7.x86_64
Found initrd image: /boot/initramfs-3.10.0-957.el7.x86_64.img
Found linux image: /boot/vmlinuz-0-rescue-8b6f5bdbdf034bb29412116f87b4bbc7
Found initrd image: /boot/initramfs-0-rescue-8b6f5bdbdf034bb29412116f87b4bbc7.img
done
Обновим образ initrd:
[root@lesson03 /]# cd /boot ; for i in `ls initramfs-*img`; do dracut -v $i `echo $i|sed "s/initramfs-//g;
> s/.img//g"` --force; done
Kernel version 0-rescue-8b6f5bdbdf034bb29412116f87b4bbc7 has no module directory /lib/modules/0-rescue-8b6f5bdbdf034bb29412116f87b4bbc7
Executing: /usr/sbin/dracut -v initramfs-0-rescue-8b6f5bdbdf034bb29412116f87b4bbc7.img 0-rescue-8b6f5bdbdf034bb29412116f87b4bbc7 --force
...
*** Including module: shutdown ***
*** Including modules done ***
*** Installing kernel module dependencies and firmware ***
*** Installing kernel module dependencies and firmware done ***
*** Resolving executable dependencies ***
*** Resolving executable dependencies done***
*** Hardlinking files ***
*** Hardlinking files done ***
*** Stripping files ***
*** Stripping files done ***
*** Generating early-microcode cpio image contents ***
*** No early-microcode cpio image needed ***
*** Store current command line parameters ***
*** Creating image file ***
*** Creating image file done ***
*** Creating initramfs image file '/boot/initramfs-3.10.0-957.el7.x86_64kdump.img' done ***
[root@lesson03 boot]# nano /etc/fstab
 заменитм rd.lvm.lv на rd.lvm.lv=vg_root/lv_root
[root@lesson03 boot]# nano /boot/grub2/grub.cfg
[root@lesson03 boot]# grub2-mkconfig -o /boot/grub2/grub.cfg
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-3.10.0-1062.9.1.el7.x86_64
Found initrd image: /boot/initramfs-3.10.0-1062.9.1.el7.x86_64.img
Found linux image: /boot/vmlinuz-3.10.0-957.el7.x86_64
Found initrd image: /boot/initramfs-3.10.0-957.el7.x86_64.img
Found linux image: /boot/vmlinuz-0-rescue-8b6f5bdbdf034bb29412116f87b4bbc7
Found initrd image: /boot/initramfs-0-rescue-8b6f5bdbdf034bb29412116f87b4bbc7.img
done
Перезагружаемся:
[root@lesson03 ~]# reboot
Проверяем:
[root@lesson03 ~]# lsblk
NAME              MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                 8:0    0   40G  0 disk
├─sda1              8:1    0    1G  0 part /boot
└─sda2              8:2    0   39G  0 part
  ├─centos-swap   253:1    0    2G  0 lvm  [SWAP]
  └─centos-root   253:2    0   37G  0 lvm
sdb                 8:16   0   10G  0 disk
└─vg_root-lv_root 253:0    0   10G  0 lvm  /
sr0                11:0    1 1024M  0 rom
Удадяем старый LV и создаём новый на 8G:
[root@lesson03 ~]# lvremove /dev/centos/root
Do you really want to remove active logical volume centos/root? [y/n]: y
  Logical volume "root" successfully removed
[root@lesson03 ~]# lvcreate -n centos/root -L 8G /dev/centos
WARNING: xfs signature detected on /dev/centos/root at offset 0. Wipe it? [y/n]: y
  Wiping xfs signature on /dev/centos/root.
  Logical volume "root" created.
[root@lesson03 ~]# mkfs.xfs /dev/centos/root
meta-data=/dev/centos/root       isize=512    agcount=4, agsize=524288 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=0, sparse=0
data     =                       bsize=4096   blocks=2097152, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
[root@lesson03 ~]# mount /dev/centos/root /mnt
[root@lesson03 ~]# xfsdump -J - /dev/vg_root/lv_root | xfsrestore -J - /mnt
xfsrestore: using file dump (drive_simple) strategy
xfsdump: using file dump (drive_simple) strategy
xfsrestore: version 3.1.7 (dump format 3.0)
xfsdump: version 3.1.7 (dump format 3.0)
xfsrestore: searching media for dump
xfsdump: level 0 dump of lesson03:/
xfsdump: dump date: Mon Jan 13 14:39:19 2020
xfsdump: session id: e7ad7cae-ede5-4cf2-beaf-3ad007674f62
xfsdump: session label: ""
xfsdump: ino map phase 1: constructing initial dump list
xfsdump: ino map phase 2: skipping (no pruning necessary)
xfsdump: ino map phase 3: skipping (only one dump stream)
xfsdump: ino map construction complete
xfsdump: estimated dump size: 1400356544 bytes
xfsdump: creating dump session media file 0 (media 0, file 0)
xfsdump: dumping ino map
xfsdump: dumping directories
xfsrestore: examining media file 0
xfsrestore: dump description:
xfsrestore: hostname: lesson03
xfsrestore: mount point: /
xfsrestore: volume: /dev/mapper/vg_root-lv_root
xfsrestore: session time: Mon Jan 13 14:39:19 2020
xfsrestore: level: 0
xfsrestore: session label: ""
xfsrestore: media label: ""
xfsrestore: file system id: f6f80598-ee95-4f7f-ac47-098ed800ebd3
xfsrestore: session id: e7ad7cae-ede5-4cf2-beaf-3ad007674f62
xfsrestore: media id: 40daa94d-1195-47c4-bd0d-9b2bfe26f94b
xfsrestore: searching media for directory dump
xfsrestore: reading directories
xfsdump: dumping non-directory files
xfsrestore: 4969 directories and 35313 entries processed
xfsrestore: directory post-processing
xfsrestore: restoring non-directory files
xfsdump: ending media file
xfsdump: media file size 1366041920 bytes
xfsdump: dump size (non-dir files) : 1345450128 bytes
xfsdump: dump complete: 72 seconds elapsed
xfsdump: Dump Status: SUCCESS
xfsrestore: restore complete: 72 seconds elapsed
xfsrestore: Restore Status: SUCCESS
[root@lesson03 ~]# for i in /proc/ /sys/ /dev/ /run/ /boot/; do mount --bind $i /mnt/$i; done
[root@lesson03 ~]# chroot /mnt/
[root@lesson03 /]# nano /etc/fstab
[root@lesson03 /]# grub2-mkconfig -o /boot/grub2/grub.cfg
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-3.10.0-1062.9.1.el7.x86_64
Found initrd image: /boot/initramfs-3.10.0-1062.9.1.el7.x86_64.img
Found linux image: /boot/vmlinuz-3.10.0-957.el7.x86_64
Found initrd image: /boot/initramfs-3.10.0-957.el7.x86_64.img
Found linux image: /boot/vmlinuz-0-rescue-8b6f5bdbdf034bb29412116f87b4bbc7
Found initrd image: /boot/initramfs-0-rescue-8b6f5bdbdf034bb29412116f87b4bbc7.img
done
[root@lesson03 /]# cd /boot ; for i in `ls initramfs-*img`; do dracut -v $i `echo $i|sed "s/initramfs-//g;
> s/.img//g"` --force; done
Kernel version 0-rescue-8b6f5bdbdf034bb29412116f87b4bbc7 has no module directory /lib/modules/0-rescue-8b6f5bdbdf034bb29412116f87b4bbc7
Executing: /usr/sbin/dracut -v initramfs-0-rescue-8b6f5bdbdf034bb29412116f87b4bbc7.img 0-rescue-8b6f5bdbdf034bb29412116f87b4bbc7 --force
...
*** Resolving executable dependencies ***
*** Resolving executable dependencies done***
*** Hardlinking files ***
*** Hardlinking files done ***
*** Stripping files ***
*** Stripping files done ***
*** Generating early-microcode cpio image contents ***
*** No early-microcode cpio image needed ***
*** Store current command line parameters ***
*** Creating image file ***
*** Creating image file done ***
*** Creating initramfs image file '/boot/initramfs-3.10.0-957.el7.x86_64kdump.img' done ***


Выделить том под /var в зеркало.


Создаем зеркало на свободных дисках, создаём на нём фс и перемещаем туда /var:
[root@lesson03 boot]# pvcreate /dev/sdc /dev/sdd
  Physical volume "/dev/sdc" successfully created.
  Physical volume "/dev/sdd" successfully created.
[root@lesson03 boot]# vgcreate vg_var /dev/sdc /dev/sdd
  Volume group "vg_var" successfully created
[root@lesson03 boot]# cd /boot ; for i in `ls initramfs-*img`; do dracut -v $i `echo $i|sed "s/initramfs-//g;
> ^C
[root@lesson03 boot]# lvcreate -L 950M -m1 -n lv_var vg_var
  Rounding up size to full physical extent 952.00 MiB
  Logical volume "lv_var" created.
[root@lesson03 boot]# mkfs.ext4 /dev/vg_var/lv_var
mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
60928 inodes, 243712 blocks
12185 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=249561088
8 block groups
32768 blocks per group, 32768 fragments per group
7616 inodes per group
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376

Allocating group tables: done
Writing inode tables: done
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done
[root@lesson03 boot]# mount /dev/vg_var/lv_var /mnt
[root@lesson03 boot]# cp -aR /var/* /mnt/

Проверяем:
[root@lesson03 boot]# ls -l /mnt/
total 84
drwxr-xr-x.  2 root root  4096 Apr 11  2018 adm
drwxr-xr-x.  5 root root  4096 Jan 13 12:51 cache
drwxr-xr-x.  2 root root  4096 Aug  8 14:41 crash
drwxr-xr-x.  3 root root  4096 Jan 13 12:56 db
drwxr-xr-x.  3 root root  4096 Jan 13 12:51 empty
drwxr-xr-x.  2 root root  4096 Apr 11  2018 games
drwxr-xr-x.  2 root root  4096 Apr 11  2018 gopher
drwxr-xr-x.  3 root root  4096 Sep 13 21:05 kerberos
drwxr-xr-x. 24 root root  4096 Jan 13 14:39 lib
drwxr-xr-x.  2 root root  4096 Apr 11  2018 local
lrwxrwxrwx.  1 root root    11 Jan 13 14:40 lock -> ../run/lock
drwxr-xr-x.  6 root root  4096 Jan 13 14:35 log
drwx------.  2 root root 16384 Jan 13 14:47 lost+found
lrwxrwxrwx.  1 root root    10 Jan 13 14:40 mail -> spool/mail
drwxr-xr-x.  2 root root  4096 Apr 11  2018 nis
drwxr-xr-x.  2 root root  4096 Apr 11  2018 opt
drwxr-xr-x.  2 root root  4096 Apr 11  2018 preserve
lrwxrwxrwx.  1 root root     6 Jan 13 14:40 run -> ../run
drwxr-xr-x.  8 root root  4096 Jan 13 12:51 spool
drwxrwxrwt.  2 root root  4096 Jan 13 14:45 tmp
drwxr-xr-x.  2 root root  4096 Apr 11  2018 yp

Удаляем старое содержимое и добавляем запись в fstab:
[root@lesson03 boot]# rm -rf /var/*
[root@lesson03 boot]# umount /mnt
[root@lesson03 boot]# mount /dev/vg_var/lv_var /var
[root@lesson03 boot]# echo "`blkid | grep var: | awk '{print $2}'` /var ext4 defaults 0 0" >> /etc/fstab
[root@lesson03 boot]# exit
exit
[root@lesson03 ~]# reboot
Проверяем:
[root@lesson03 ~]# df -h
Filesystem                 Size  Used Avail Use% Mounted on
devtmpfs                   1.9G     0  1.9G   0% /dev
tmpfs                      1.9G     0  1.9G   0% /dev/shm
tmpfs                      1.9G  8.8M  1.9G   1% /run
tmpfs                      1.9G     0  1.9G   0% /sys/fs/cgroup
/dev/mapper/centos-root    8.0G  1.2G  6.9G  15% /
/dev/sda1                 1014M  158M  857M  16% /boot
/dev/mapper/vg_var-lv_var  922M  179M  679M  21% /var


Выделить том под /home


Создаём раздел, на нём фс и перемещаем туда /home:
[root@lesson03 ~]# lvcreate -n lv_home -L 2G /dev/centos
  Logical volume "lv_home" created.
[root@lesson03 ~]# lvs
  LV      VG     Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  lv_home centos -wi-a-----   2.00g
  root    centos -wi-ao----   8.00g
  swap    centos -wi-ao----  <2.00g
  lv_var  vg_var rwi-aor--- 952.00m                                    100.00
[root@lesson03 ~]# vgs
  VG     #PV #LV #SN Attr   VSize   VFree
  centos   1   3   0 wz--n- <39.00g 27.00g
  vg_var   2   1   0 wz--n-   2.99g  1.12g
[root@lesson03 ~]# mkfs.xfs /dev/centos/lv_home
meta-data=/dev/centos/lv_home    isize=512    agcount=4, agsize=131072 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=0, sparse=0
data     =                       bsize=4096   blocks=524288, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
[root@lesson03 ~]# mount /dev/centos/lv_home /mnt/
[root@lesson03 ~]# cp -aR /home/* /mnt/
[root@lesson03 ~]# rm -rf /home/*
[root@lesson03 ~]# umount /mnt
[root@lesson03 ~]# mount /dev/centos/lv_home /home/
[root@lesson03 ~]# echo "`blkid | grep home | awk '{print $2}'` /home xfs defaults 0 0" >> /etc/fstab
Сгенерируем файлы в /home/:
[root@lesson03 ~]# touch /home/file{1..20}
Сделаем снапшот:
[root@lesson03 ~]# lvcreate -L 100MB -s -n home_snap /dev/centos/lv_home
  Logical volume "home_snap" created.
Удалим часть файлов:
[root@lesson03 ~]# rm -f /home/file{11..20}
[root@lesson03 ~]# ls /home/
file1  file10  file2  file3  file4  file5  file6  file7  file8  file9
Восстановим файлы со снапшота:
[root@lesson03 ~]# umount /home
[root@lesson03 ~]# lvconvert --merge /dev/centos/home_snap
  Merging of volume centos/home_snap started.
  centos/lv_home: Merged: 100.00%
[root@lesson03 ~]# mount /home
[root@lesson03 ~]# ls /home/
file1  file10  file11  file12  file13  file14  file15  file16  file17  file18  file19  file2  file20  file3  file4  file5  file6  file7  file8  file9

### Попасть в систему без пароля несколькими способами

Для получения доступа необходимо запустить виртуальную машину и при выборе ядра для загрузки нажать e. После этого мы попадаем в окно, где мы можем изменить параметры загрузки:

##### Способ 1:

В конце строки начинающейся с linux16 добавляем init=/bin/sh и нажимаем сtrl-x для загрузки системы. Корневая файловая система будет смонтирована в режиме Read-Only.

##### Способ 2:

В конце строки начинающейся с linux16 добавляем  rd.break  и нажимаем сtrl-x для загрузки системы и попадаем в emergency mode. Корневая файловая система будет смонтирована в режиме Read-Only. С помощью следующих команд можно перемонтировать систему в режим rw и поменять пароль администратора.

```bash
mount -o remount,rw /sysroot
chroot /sysroot
passwd root
touch /.autorelabel
```

### Переименовать vg

##### Проверим текущее состояние:

```bash
[root@lesson07 ~]# vgs
  VG     #PV #LV #SN Attr   VSize   VFree
  centos   1   2   0 wz--n- <39.00g    0
```

##### Переименуем vg:
```bash
[root@lesson07 ~]# vgrename centos otus
  Volume group "centos" successfully renamed to "otus"
```

##### Правим файлы /etc/fstab, /etc/default/grub, /boot/grub2/grub.cfg меняем старое название на новое.
Пересоздаем initrd image, чтобы он знал новое название:
```bash
[root@lesson07 ~]# mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)
Executing: /usr/sbin/dracut -f -v /boot/initramfs-3.10.0-1062.9.1.el7.x86_64.img 3.10.0-1062.9.1.el7.x86_64
dracut module 'modsign' will not be installed, because command 'keyctl' could not be found!
dracut module 'busybox' will not be installed, because command 'busybox' could not be found!
dracut module 'crypt' will not be installed, because command 'cryptsetup' could not be found!
dracut module 'dmraid' will not be installed, because command 'dmraid' could not be found!
dracut module 'dmsquash-live-ntfs' will not be installed, because command 'ntfs-3g' could not be found!
dracut module 'mdraid' will not be installed, because command 'mdadm' could not be found!
dracut module 'multipath' will not be installed, because command 'multipath' could not be found!
dracut module 'cifs' will not be installed, because command 'mount.cifs' could not be found!
dracut module 'iscsi' will not be installed, because command 'iscsistart' could not be found!
dracut module 'iscsi' will not be installed, because command 'iscsi-iname' could not be found!
95nfs: Could not find any command of 'rpcbind portmap'!
dracut module 'modsign' will not be installed, because command 'keyctl' could not be found!
dracut module 'busybox' will not be installed, because command 'busybox' could not be found!
dracut module 'crypt' will not be installed, because command 'cryptsetup' could not be found!
dracut module 'dmraid' will not be installed, because command 'dmraid' could not be found!
dracut module 'dmsquash-live-ntfs' will not be installed, because command 'ntfs-3g' could not be found!
dracut module 'mdraid' will not be installed, because command 'mdadm' could not be found!
dracut module 'multipath' will not be installed, because command 'multipath' could not be found!
dracut module 'cifs' will not be installed, because command 'mount.cifs' could not be found!
dracut module 'iscsi' will not be installed, because command 'iscsistart' could not be found!
dracut module 'iscsi' will not be installed, because command 'iscsi-iname' could not be found!
95nfs: Could not find any command of 'rpcbind portmap'!
*** Including module: bash ***
*** Including module: nss-softokn ***
*** Including module: i18n ***
*** Including module: network ***
*** Including module: ifcfg ***
*** Including module: drm ***
*** Including module: plymouth ***
*** Including module: dm ***
Skipping udev rule: 64-device-mapper.rules
Skipping udev rule: 60-persistent-storage-dm.rules
Skipping udev rule: 55-dm.rules
*** Including module: kernel-modules ***
*** Including module: lvm ***
Skipping udev rule: 64-device-mapper.rules
Skipping udev rule: 56-lvm.rules
Skipping udev rule: 60-persistent-storage-lvm.rules
*** Including module: resume ***
*** Including module: rootfs-block ***
*** Including module: terminfo ***
*** Including module: udev-rules ***
Skipping udev rule: 40-redhat-cpu-hotplug.rules
Skipping udev rule: 91-permissions.rules
*** Including module: biosdevname ***
*** Including module: systemd ***
*** Including module: usrmount ***
*** Including module: base ***
*** Including module: fs-lib ***
*** Including module: microcode_ctl-fw_dir_override ***
  microcode_ctl module: mangling fw_dir
    microcode_ctl: reset fw_dir to "/lib/firmware/updates /lib/firmware"
    microcode_ctl: processing data directory  "/usr/share/microcode_ctl/ucode_with_caveats/intel"...
intel: model '', path ' intel-ucode/*', kvers ''
intel: blacklist ''
    microcode_ctl: intel: Host-Only mode is enabled and ucode name does not match the expected one, skipping caveat ("06-4f-01" not in " intel-ucode/*")
    microcode_ctl: processing data directory  "/usr/share/microcode_ctl/ucode_with_caveats/intel-06-2d-07"...
intel-06-2d-07: model 'GenuineIntel 06-2d-07', path ' intel-ucode/06-2d-07', kvers ''
intel-06-2d-07: blacklist ''
intel-06-2d-07: caveat is disabled in configuration
    microcode_ctl: kernel version "3.10.0-1062.9.1.el7.x86_64" failed early load check for "intel-06-2d-07", skipping
    microcode_ctl: processing data directory  "/usr/share/microcode_ctl/ucode_with_caveats/intel-06-4f-01"...
intel-06-4f-01: model 'GenuineIntel 06-4f-01', path ' intel-ucode/06-4f-01', kvers ' 4.17.0 3.10.0-894 3.10.0-862.6.1 3.10.0-693.35.1 3.10.0-514.52.1 3.10.0-327.70.1 2.6.32-754.1.1 2.6.32-573.58.1 2.6.32-504.71.1 2.6.32-431.90.1 2.6.32-358.90.1'
intel-06-4f-01: blacklist ''
intel-06-4f-01: caveat is disabled in configuration
    microcode_ctl: kernel version "3.10.0-1062.9.1.el7.x86_64" failed early load check for "intel-06-4f-01", skipping
    microcode_ctl: processing data directory  "/usr/share/microcode_ctl/ucode_with_caveats/intel-06-55-04"...
intel-06-55-04: model 'GenuineIntel 06-55-04', path ' intel-ucode/06-55-04', kvers ''
intel-06-55-04: blacklist ''
intel-06-55-04: caveat is disabled in configuration
    microcode_ctl: kernel version "3.10.0-1062.9.1.el7.x86_64" failed early load check for "intel-06-55-04", skipping
    microcode_ctl: final fw_dir: "/lib/firmware/updates /lib/firmware"
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
*** Creating initramfs image file '/boot/initramfs-3.10.0-1062.9.1.el7.x86_64.img' done ***
[root@lesson07 ~]# reboot
```

##### Перезагружаемся и проверяем:

```bash
[root@lesson07 ~]# vgs
  VG   #PV #LV #SN Attr   VSize   VFree
  otus   1   2   0 wz--n- <39.00g    0
```

### Добавить модуль в initrd

##### Создаем папку с именем 01test в директории /usr/lib/dracut/modules.d/:
```bash
[root@lesson07 ~]# mkdir /usr/lib/dracut/modules.d/01test
```

##### Поместим туда два скрипта:
- module_setup.sh
- test.sh

##### Пересобираем образ initrd:
```bash
 dracut -f -v
```

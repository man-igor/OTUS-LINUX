Работа с mdadm.

Vagrantfile запускает ВМ с подключёнными 4 дополнительными дисками.

Собираем raid5:
[vagrant@lesson2 ~]$ sudo mdadm --create --verbose /dev/md0 -l 5 -n 4 /dev/vd{b,c,d,e}

[vagrant@lesson2 ~]$ sudo mdadm -D /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Thu Oct  3 21:06:57 2019
        Raid Level : raid5
        Array Size : 3139584 (2.99 GiB 3.21 GB)
     Used Dev Size : 1046528 (1022.00 MiB 1071.64 MB)
      Raid Devices : 4
     Total Devices : 4
       Persistence : Superblock is persistent

       Update Time : Thu Oct  3 21:07:38 2019
             State : clean 
    Active Devices : 4
   Working Devices : 4
    Failed Devices : 0
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : resync

              Name : lesson2:0  (local to host lesson2)
              UUID : 5e22eb7c:ae9f529a:b69634ac:15fae299
            Events : 64

    Number   Major   Minor   RaidDevice State
       0     253       16        0      active sync   /dev/vdb
       1     253       32        1      active sync   /dev/vdc
       2     253       48        2      active sync   /dev/vdd
       4     253       64        3      active sync   /dev/vde


Пометим один диск как сбойный:
[vagrant@lesson2 ~]$ sudo mdadm /dev/md0 --fail /dev/vde 
mdadm: set /dev/vde faulty in /dev/md0

[vagrant@lesson2 ~]$ cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] 
md0 : active raid5 vde[4](F) vdd[2] vdc[1] vdb[0]
      3139584 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3] [UUU_]

Удалим сбойный диск из массива:
[vagrant@lesson2 ~]$ sudo mdadm /dev/md0 --remove /dev/vde
mdadm: hot removed /dev/vde from /dev/md0

Добавим диск заново:
[vagrant@lesson2 ~]$ sudo  mdadm /dev/md0 --add /dev/vde
mdadm: added /dev/vde
Проверим статус восстановления массива:
[vagrant@lesson2 ~]$ cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] 
md0 : active raid5 vde[4] vdd[2] vdc[1] vdb[0]
      3139584 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3] [UUU_]
      [======>..............]  recovery = 31.1% (327060/1046528) finish=0.2min speed=46722K/sec


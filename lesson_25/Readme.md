На сервере запускаем iperf3:
```bash
iperf3 -s
```
На клиенте:
```bash
iperf3 -c 10.10.10.1 -t 40 -i 5
```

Результаты:
<p>dev tap:</p>

```bash
[vagrant@client ~]$ iperf3 -c 10.10.10.1 -t 40 -i 5
Connecting to host 10.10.10.1, port 5201
[  4] local 10.10.10.2 port 40060 connected to 10.10.10.1 port 5201
[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
[  4]   0.00-5.00   sec   167 MBytes   280 Mbits/sec  508   89.0 KBytes       
[  4]   5.00-10.00  sec   148 MBytes   248 Mbits/sec  439   90.3 KBytes       
[  4]  10.00-15.00  sec   144 MBytes   241 Mbits/sec  354    103 KBytes       
[  4]  15.00-20.00  sec   133 MBytes   223 Mbits/sec  453   99.3 KBytes       
[  4]  20.00-25.00  sec   134 MBytes   225 Mbits/sec  461   90.3 KBytes       
[  4]  25.00-30.00  sec   112 MBytes   188 Mbits/sec  334    110 KBytes       
[  4]  30.00-35.00  sec   103 MBytes   174 Mbits/sec  360    125 KBytes       
[  4]  35.00-40.01  sec   127 MBytes   214 Mbits/sec  460   87.7 KBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-40.01  sec  1.04 GBytes   224 Mbits/sec  3369             sender
[  4]   0.00-40.01  sec  1.04 GBytes   224 Mbits/sec                  receiver

iperf Done.
```

<p>dev tun:</p>

```bash
[vagrant@client ~]$ iperf3 -c 10.10.10.1 -t 40 -i 5
Connecting to host 10.10.10.1, port 5201
[  4] local 10.10.10.2 port 40064 connected to 10.10.10.1 port 5201
[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
[  4]   0.00-5.00   sec   171 MBytes   287 Mbits/sec  406    115 KBytes       
[  4]   5.00-10.00  sec   155 MBytes   261 Mbits/sec  448   51.5 KBytes       
[  4]  10.00-15.00  sec   106 MBytes   178 Mbits/sec  337    143 KBytes       
[  4]  15.00-20.00  sec   110 MBytes   184 Mbits/sec  417    111 KBytes       
[  4]  20.00-25.01  sec   135 MBytes   227 Mbits/sec  423    140 KBytes       
[  4]  25.01-30.01  sec   144 MBytes   242 Mbits/sec  484   89.8 KBytes       
[  4]  30.01-35.00  sec   107 MBytes   180 Mbits/sec  298   95.1 KBytes       
[  4]  35.00-40.00  sec   107 MBytes   180 Mbits/sec  202    122 KBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-40.00  sec  1.01 GBytes   217 Mbits/sec  3015             sender
[  4]   0.00-40.00  sec  1.01 GBytes   217 Mbits/sec                  receiver

iperf Done.
```

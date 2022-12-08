---
TocOpen: true
title: "新硬盘挂载后发现 df 查询大小和实际大小不一致--Linux的保留空间"
tags: ['linux']
date: 2022-12-08T19:29:17+08:00
draft: false
---
# 前言
在 Linux 上安装一块新硬盘后，发现硬盘大小和挂载后查询到的大小不一致，大概差了 5% 左右，一种可能就是硬盘分区是留下的保留空间造成的。

## 细节
mkfs.ext4 的`man page`提供了一部分的解释。

> Specify the percentage of the filesystem blocks reserved for the super-user. This avoids fragmentation, and allows root-owned daemons, such as syslogd(8), to continue to function correctly after non-privileged processes are prevented from writing to the filesystem. The default percentage is 5%.

简单来说，ext文件系统为了保证在硬盘百分百利用下还能够写入 root 用户的关键日志等信息，默认预留了5%的磁盘空间。

但我们可以发现，这部分空间很多时候是不需要预留的，尤其是在大的磁盘分区下（例如NAS），可能会导致大量空间的浪费。

## 解决
针对这个问题，也已经有了解决方案。可以通过`tune2fs`命令查看保留空间大小和设置保留空间。

```bash
tune2fs -l /dev/sde1 | egrep "Block size:|Reserved block count"
# Reserved block count:  36628312
# Block size:            4096
```

```bash 
# set the reserved space 1%
tune2fs -m 1 /dev/sde1
```

## Reference
[Decrease Reserve Space](https://docs.cloudera.com/cloudera-manager/7.4.2/managing-clusters/topics/cm-decrease-reserved-space.html) 

[Reserved space for root on a filesystem - why?](https://unix.stackexchange.com/questions/7950/reserved-space-for-root-on-a-filesystem-why) 

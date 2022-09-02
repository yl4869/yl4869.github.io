---
tags: ["linux"]
TocOpen: true
title: "Linux小tip------tar与gz"
date: 2022-02-14T21:15:57+08:00
draft: false
---
# 简介  
你可能经常看到.tar与.tar.gz文件，但你可能很少思考过他们的用法。下面将介绍他们的区别  
## tar  
tar是打包命令，可以把一大堆的文件和目录打包成一个文件，方便文件的备份和文件在网络中的传输。
>弄清打包和压缩的概念，打包并不会减小文件的大小。  

当我们想要将多个文件压缩成一个压缩包时，我们需要先对这些文件进行打包，然后再用压缩程序进行压缩。  

## gz(误)  
gz并不是一个正确的说法，事实上你可以单独使用gzip等压缩程序对文件进行压缩，常见的.tar.gz是直接用tar打包并通过应用程序进行压缩的一种方式。  
>永远记得一个事实：linux当中后缀名不是必须的，更多是为了便于区别。  

## 从例子学习使用  

### tar进行文件打包  
1.打包文件

```bash
tar -cf file.tar file1 file2
```

将file1和file2进行打包。-c表示进行打包，-f指定打包文档(file.tar)  

2.解包文件

```bash
tar -xf file.tar
```  
-x表示解包，-f指定解包文档(file.tar)

### 压缩文件进行文件压缩
这里只介绍利用gzip压缩软件，事实上还有其他的压缩软件可以使用
1.压缩文件

```bash
gzip file.tar
```

2.解压文件

```bash
gunzip file.tar.gz
```

### 直接利用tar进行打包与解压
1.压缩文件

```bash
tar -czvf file.tar.gz file1 file2
```
-c,-f已经介绍过。-z表示使用的压缩是gzip压缩，-v表示显示所有过程  

2.解压文件

```bash
tar -xzvf file.tar.gz
```
现在你应该理解了压缩与解压阶段各种参数的意义。  
>注意：-f后面必须接文档名，所以作为最后一个参数  

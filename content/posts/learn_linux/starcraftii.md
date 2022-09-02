---
tags: ["games","linux"]
title: "在linux上游玩星际争霸2"
date: 2022-01-23T23:42:33+08:00
draft: false
---
# 简介
限制想要将工作从windows迁移到linux上的一个方面就是游戏。Steam已经通过proton给到了游戏玩家更多的选择。暴雪尚未出现linux版本，但好在还有wine的存在。通过lutris，现在你可以更轻松地在linux上享受游戏。  
我会尽量给出官方文档，以便于不同时间的不同用户进行操作时可以减少错误。  
操作系统：manjaro  
显卡：Nvidia no-free驱动

# 步骤
## 1.安装合适的Gpu驱动
https://github.com/lutris/docs/blob/master/InstallingDrivers.md  
lutris为我们创建了一个良好的文档说明。你可以选择与你电脑相符的介绍并继续操作。对我的系统manjaro而言，我已经在安装时选择了no-free驱动，因此已经有了一套正确的驱动支持。  

## 安装wine
https://github.com/lutris/docs/blob/master/WineDependencies.md  
同样，选择你的发行版并按步骤进行操作,这里以我的系统manjaro为例。  
修改```/etc/pacman.conf```,添加```[multilib]```启动multilib仓库，在文件中添加以下内容：

![](/image/starcraftii/1.png)

```plain
/etc/pacman.conf
--------------------------------------------------------------------------------------
[multilib]
Include = /etc/pacman.d/mirrorlist
```

更新pacman仓库

```bash
sudo pacman -Syu
```

安装wine，要安装的包有点多，但其实很多你已经安装过了，全部的依赖安装可以避免之后出现奇奇怪怪的问题。

```bash
sudo pacman -S --needed wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls \
mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error \
lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo \
sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama \
ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 \
lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader
```

以上，wine安装完成。

## 安装暴雪战网所需的特殊依赖
暴雪战网是暴雪游戏的启动器，为了成功启动需要安装部分依赖。  

```bash
sudo pacman -S lib32-gnutls lib32-libldap lib32-libgpg-error lib32-sqlite lib32-libpulse lib32-alsa-plugins
```

## 安装lutris
https://lutris.net/downloads/  
lutris让你安装与启动游戏更加简单（非广告）

![](/image/starcraftii/2.png)

```bash 
sudo pacman -S lutris
```  

## 下载星际争霸2安装脚本
https://lutris.net/games/starcraft-ii/  
你可以通过脚本实现游戏的安装,安装成功后进入暴雪战网安装游戏。


![](/image/starcraftii/3.png)
![](/image/starcraftii/4.png)

## 开始游戏
安装完成后，你可以开始游戏了，我在游戏启动时会自动识别独显并启动，游戏一局开始2分钟会有小卡顿，但随后十分流畅，整体体验感很不错。  


![](/image/starcraftii/5.png)
![](/image/starcraftii/6.png)
![](/image/starcraftii/7.png)


# 鸣谢
感谢 https://www.youtube.com/watch?v=Fyjc-c5oN4k  
在我开始时看到了这个视频，并通过视频完成了游戏的安装，使我走了很少的弯路。  

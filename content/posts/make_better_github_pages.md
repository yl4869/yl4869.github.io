---
TocOpen: true
title: "利用分支完成 github pages 博客内容存放和页面部署"
date: 2022-09-02T16:21:09+08:00
draft: false
---

# 前言

我利用github pages作为平台搭建我的博客，我开始选择将博客内容和部署分成两个仓库存放，但这显然造成了复杂性的提升。在阅读 mdbook 的官方文档时，我发现他部署 book 的一个方式是利用一个新的分支进行部署，这样可以将内容和页面放在不同的分支上共同保存，同时有好的规整感。      

## 原理
在 github 仓库的 Settings/Pages 下可以选择利用哪一个分支进行部署。

利用 `github worktree` 可以将当前分支绑定到一个新建的 worktree 目录上，并通过新的目录进行分支操作。

## 使用
1. 新建分支 deploy 和 /tmp/blog 目录，利用github worktree 将目录 deploy 分支绑定到目录下。
2. 将生成的页面文件（我这里在public文件夹中），拷贝到 /tmp/blog 目录下
3. 在 /tmp/blog 下利用 git 操作，添加并提交到远程 deploy 分支中。
4. 设置 github pages，用 deploy 分支作为 github pages 部署分支。

现在你可以将内容提交到 main 分支，而将部署提交到 deploy分支。

## 为什么使用临时目录
使用临时目录的样例来自 mdbook 的[文档](https://github.com/rust-lang/mdBook/wiki/Automated-Deployment%3A-GitHub-Pages)。因此我只是当一个黑盒来使用。我的想法是为了不破坏其他数据，不过有了解的朋友也欢迎来给我答疑解惑。     

## 我的 Makefile 文件

```Makefile
.PHONY: deploy
.PHONY: clean
.PHONY: build
.PHONY: commit

clean: 
	rm -rf public

deploy: public
	@echo "====> deploying to github"
	-mkdir /tmp/blog
	git worktree prune
	-git worktree add /tmp/blog deploy
	rm -rf /tmp/blog/*
	cp -rp public/* /tmp/blog/
	cd /tmp/blog && \
	git add -A && \
	git commit -m "deployed on $(shell date) by ${USER}" && \
	git push origin deploy
	cd -

build:
	hugo

commit:
	git add Makefile config.yml assets static content layouts archetypes
	git commit -m "commit on $(shell date) by ${USER}" && \
	git push origin main
```

---
TocOpen: true
title: "Linux小tip-rsync"
tags: ["linux"]
date: 2024-02-28T23:12:49+08:00
draft: false
---
# 简介
rsync 是一个用于文件同步和传输的命令行工具。它可以在本地系统之间或者通过SSH等安全通道在本地和远程系统之间同步文件和目录。

你可能听过 scp，scp 主要通过 SSH 进行加密传输，只能用于本地和远程系统之间的文件拷贝。而 rsync 提供了更多的功能，如**增量传输**、删除目标端不存在的文件、排除特定文件等。

# 常见选项
- `-a, --archive`: 归档模式，保留文件的所有元数据，包括权限、所有者、组、时间等。
- `-v, --verbose`: 输出详细信息，显示正在执行的操作。
- `-r, --recursive`: 递归地同步子目录。
- `-z, --compress`: 在传输时压缩数据，可以节省带宽。
- `-u, --update`: 仅传输源目录中更新的文件。
- `-n, --dry-run`: 模拟执行同步操作，显示将要发生的改变但不实际指令同步。
- `-e, --rsh=COMMAND`: 选择在传输时使用的远程 shell 程序，通常是 rsh 或 ssh。
- `--delete`: 删除目标目录中源目录没有的文件。
- `--exclude=PATTERN`: 排除匹配指定模式的文件或目录。

# 示例
```bash
# 本地同步，如果是目录需要 -r 选项
rsync -av /path/to/source /path/to/destination

# 本地到远程
rsync -av /path/to/source user@remote_host:/path/to/destination

# 远程到本地
rsync -av user@remote_host:/path/to/source/ /path/to/destination/

# 同步并删除目标目录中不存在的文件
rsync -av --delete /path/to/source/ /path/to/destination/

# 排除特定文件或目录的同步
rsync -av --exclude='*.log' /path/to/source/ /path/to/destination/

# 模拟同步操作，显示将要发生的改变但不实际执行同步
rsync -av --dry-run /path/to/source/ /path/to/destination/
```


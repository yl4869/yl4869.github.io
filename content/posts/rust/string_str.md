---
TocOpen: true
title: "如何理解字符串，字符串字面量和字符串切片"
tags: []
date: 2023-03-26T22:37:14+08:00
draft: false
---

# 如何理解String，str与&str
字符串，字符串字面量和字符串切片是初学 rust 最困惑的一点，一部分是因为它的各种用法繁杂，经常使用；另一部分也是因为它们所提供的方法繁多，并且有着令人疑惑的相互转换。虽然常读常新，但还是想写一篇博客，分享之外也可以让自己在困惑时快速找到参考而不用翻阅大量网页。
## 从内存开始
通过了解字符串在内存中的表示，我们可以最直观的了解到他们的不同之处，考虑下面的代码和他们创建的布局。

```rust 
let s1 = String::from("Hello");
let s2 = &s1[1..];
let s3 = "Hello";
```

他们的内存布局如下
```
                  my_name:s1(String)  my_name: s2(&str)       my_name:s3(&str)
                  [----------------]  [–––––––––––]           [--------------]
                  +---+---+---+       +–––+–––+                +---+---+
stack frame       | • | 6 | 5 |       │ • │ 4 │                | • | 4 |
                  +-|-+---+---+       │–+–+–--+                +-|-+---+
                    |                 |                          |
                    |   +-------------+                          |
                    |   |                                        |
                  +-V-+-V-+---+---+---+---+                      |
heap frame        | H | e | l | l | o |   |                      |
                  +---+---+---+---+---+---+                      |
                                                                 |
                                                                 |
                                                                 |
                                                                 |
                                             preallocated  +–-–+–V–+–––+–––+–––+–––+
                                             read-only     │ H │ e │ l │ l │ o │   │ 
                                             memory        +–––+–––+–––+–––+–––+–––+
```
我们可以发现下面几条事实:
1. String 在堆上作为可伸缩缓存区存储文本，可以按需要调整大小。
2. &str 在栈上，作为“胖指针”，包含了实际数据的地址和长度，**我们无法修改&str**。
3. 字符串字面量存在于预定义的只读内存中，我们无法进行修改。

> 由于切片无法重新分配它引用的缓冲区，因此我们除了`make_ascii_uppercase`与`make_ascii_lowercase`外没有需要使用`&mut str`的地方。

记住以上的内容已经能够让你区分String与&str了，另外对于有过C/C++底子的人来说，还需要记得**Rust的字符串是Unicode**，因此不要通过下标的方式进行单个字符操作，你应该依赖方法，大量的方法。

## 字符串方法
在这里我们以string代指String类型，slice则代指&str类型。

当你想要修改字符串，即伸缩堆缓冲区时，请使用String的处理方法；当你想要就地操作文本时，还可以使用str提供的处理方法。

> 因为String解引用为&str，因此str上定义的所有方法也都可以在String上直接调用。

下面介绍常用的字符串方法

## 创建字符串值
| 方法名   | 介绍    |
|--------------- | --------------- |
| String::new()   | 创建一个空的String类型   |
| String::with_capacity(n)   | 创建一个初始缓冲区为n的String类型   |
| slice.to_string()   | 创建一个全新的String类型，其初始内容是slice的副本   |
| slice.to_owned()   | 专为字符串字面量设计，而to_string()还可以用在实现了ToString trait的其他类型中   |

## 追加和插入文本
| 方法名   | 介绍   |
|--------------- | --------------- |
| String.push(ch)   | 添加单个字符   |
| String.push_str(slice)   | 添加字符串   |
| String.insert(i, ch)   | 在字节偏移i的位置插入字符，i后内容移位（性能问题）   |
| String.insert_str(i, slice)   | 插入字符串（性能问题）   |

## 获取字符串基本信息
| 方法名  | 介绍   |
|-------------- | -------------- |
| slice.len()    | 返回slice的长度（字节计） |
| slice.is_empty()    | slice.len() == 0 返回true  |
| slice[range]    | 返回切片的部分切片，由于UTF-8的问题，取得一个字符很麻烦 |

更多内容请参考标准库[String](https://doc.rust-lang.org/std/string/struct.String.html)和标准库[str](https://doc.rust-lang.org/std/primitive.str.html) 


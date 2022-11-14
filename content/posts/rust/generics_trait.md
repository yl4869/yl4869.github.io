---
TocOpen: true
title: "Rust: 泛型，特征与特征对象"
tags: ["Rust"]
date: 2022-11-14T10:05:15+08:00
draft: false
---
# Rust: 泛型，特征与特征对象
最近在学习 Rust 的一些概念思想，记录一下自己对 Rust 中泛型，特征与特征对象的理解。

## 泛型
泛型与 CPP 中的模版类似，可以减少代码的重复。泛型会在编译时实现**单态化**（monomorphization），会将通用代码转换为特定代码，因此不会出现运行时开销。

> 可以理解为编译器帮你把写的泛型代码重新转换为写了具体类型的代码。

泛型可以用在结构体，枚举，函数乃至方法中，其中枚举和方法可以多讲一下。

### 泛型在枚举中的实现
泛型在枚举中的实现本身没有要讲的，不过标准库实现的`Option<T>`和`Result<T, E>`很想讲一下。

#### Option<T>
标准库中的泛型定义
```rust
pub enum Option<T> {
    None,
    Some(T),
}
```
简约而又简单，rust 中并不存在空指针，通过 None 进行替代，`Option`常使用在返回值中。当返回值可能为一个结果，也有可能失败或缺值时，可以通过模式匹配进行处理。**这里的 T 就是泛型说明**

#### Result<T, E> 
标准库中的泛型定义
```rust
pub enum Result<T, E> {
    Ok(T),
    Err(E),
}
```
除了`Option`可以在结果失败时传递 None，但有时我们想要知道具体的失败信息，`Result` 实现了这一点。`Result<T, E>`  拥有两个泛型 T 和 E，在不同的场景下你可以将他们作为不同的类型。

#### 泛型在方法中
泛型在方法中需要在`impl`后面声明`<T>`，这里是为了告诉 Rust **类型后面的 T 是一个泛型而不是具体类型**，注意这里`impl`后面提供的泛型声明只与后面具体类型要实现的泛型有关。

与之相应的，你也可以为一个泛型实现他**具体类型**的方法。

```rust
// 对一个泛型实现具体方法，其中方法中又提供了更多的泛型声明
struct Mix<T, U> {
    x: T,
    y: U,
}

impl<T, U> Mix<T, U> {
    fn mixup<V, W>(self, other: Mix<V, W>) -> Mix<T, W> {
        //这里提供了另外两个泛型: V和W, 代表other的类型参数
        Mix {
            x: self.x,
            y: other.y,
        }
    }
}

fn main() {
    let x = Mix { x: 1, y: 2.0 };
    let y = Mix {
        x: "hello",
        y: '🐺',
    };

    let z = x.mixup(y);
    assert_eq!(z.x, 1);
    assert_eq!(z.y, '🐺');
}
```

同时我们还可以实现对**泛型的具体类型**方法
```rust
struct Point<T> {
    x: T,
    y: T,
}

impl<T> Point<T> {
    fn x(&self) -> &T {
        &self.x
    }
}

impl Point<f32> {
    fn distance_from_origin(&self) -> f32 {
        (self.x.powi(2) + self.y.powi(2)).sqrt()
    }
}

fn main() {
    let p = Point { x: 5, y: 10 };

    println!("p.x = {}", p.x());
}
```

## 特征（Trait）
特征的功能：**实现一个共同行为**

你可能听说过接口的概念，特征与接口很类似，特征告诉编译器：**我有一个共享行为，不同类型都可以实现这个行为**

> 与C++中的抽象类的继承很类似，但注意特征并非**面向对象**

关于特征我想思考的是，孤儿规则与特征约束

### 孤儿规则
孤儿规则要求类型和你要为他实现的特征，**必须保证他们中有一个在你的定义域内**。换言之你无法为`String`类型实现`Display`特征，因为他们的定义都在标准库内，你只能进行使用而不能进行修改。

孤儿规则有效保证了你的代码不会破坏引入的代码，引入的代码也不会破坏你的代码。

### 特征约束
`impl Trair`实际上是一个语法糖，而你想要在复杂场景则可以使用他的完整版：特征约束（trait bound）
```rust
//语法糖版
pub fn notify(item: &impl Summary) {
    println!("Breaking news! {}", item.summarize());
}

//特征约束（trait bound）
pub fn notify<T: Summary>(item: &T) {
    println!("Breaking news! {}", item.summarize());
}
```

你也可以指定多个特征约束，特征约束十分灵活，你也可以通过特征约束有条件的实现方法。

### 为泛型实现特征
下面是标准库中 Add 特征的实现,这里我们想要为泛型实现
```rust
pub trait Add<Rhs = Self> {
    type Output;

    fn add(self, rhs: Rhs) -> Self::Output;
}
```

```rust
//实现两个Point<T>类型的相加
use std::ops::Add;

#[derive(Debug, Copy, Clone, PartialEq)]
struct Point<T> {
    x: T,
    y: T,
}

// Notice that the implementation uses the associated type `Output`.
// 要求 T 类型已经实现了Add trait, 这里使用了特征
impl<T: Add<Output = T>> Add for Point<T> {
    type Output = Self;

    fn add(self, other: Self) -> Self::Output {
        Self {
            x: self.x + other.x,
            y: self.y + other.y,
        }
    }
}

assert_eq!(Point { x: 1, y: 0 } + Point { x: 2, y: 3 },
           Point { x: 3, y: 3 });
```

这里多了一部分没有介绍到的内容`type Output = Self`，关联类型（associated types）是指关联到了某个 trait 上的类型。

#### 关联类型
我们指定`Output = Self`，又将其作为返回值，同时需要注意，在返回值时我们需要使用`Self::Output`这种不怎么直观的语法。

在这里我们直接让返回值为`Point<T>`而不是`Self::Output`也没有问题(你可以尝试一下)，那么泛型和关联类型该如何选择。

简单来说，如果你想对一个类型A对一个 trait 有多种实现，那么使用泛型。   
如果你想对类型A仅实现 trait 一次，那么使用关联类型。

> 有关一个类型A多种实现，可以参考From<T>

## 特征对象
### 已经有特征了，为什么还要有特征对象？
当函数返回值的类型不唯一时（如下面的代码），我们在编译器只能知道返回值的类型满足了某种特征，但无法确定返回值的具体类型，这个时候我们无法进行返回值的使用。
```rust
struct Sheep {}
struct Cow {}

trait Animal {
    fn noise(&self) -> String;
}

impl Animal for Sheep {
    fn noise(&self) -> String {
        "baaaaah!".to_string()
    }
}

impl Animal for Cow {
    fn noise(&self) -> String {
        "moooooo!".to_string()
    }
}

// 返回一个类型，该类型实现了 Animal 特征，但是我们并不能在编译期获知具体返回了哪个类型
// 修复这里的错误，你可以使用虚假的随机，也可以使用特征对象
fn random_animal(random_number: f64) -> impl Animal {
    if random_number < 0.5 {
        Sheep {}
    } else {
        Cow {}
    }
}

fn main() {
    let random_number = 0.234;
    let animal = random_animal(random_number);
    println!("You've randomly chosen an animal, and it says {}", animal.noise());
}
```

现在，可以考虑特征对象了。

### 静态分发与动态分发
特征对象无法使用**静态分发**，因为我们只能在运行时才知道具体的类型，才能确定会调用什么方法。

由于类型的大小和方法不确定，所以动态分发提供了指针的方式指向相应的类型和方法，我们通过使用**特征对象的引用**实现内存的分配。

有关静态分发与动态分发的区别见下图。
![内存分配](/image/rust/1.jpeg) 

静态分发由于我们在编译器已知类型，因此我们会指向具体的类型实例，但动态分发无法确定类型，因此我们使用内存空间确定的引用类型，包含 ptr 和 vptr 两个指针，分别指向特征对象实例方法的虚表（vtable）我们通过这个虚表可以找到这个实例实现的具体方法。

这里需要注意的是，当我们选择特征对象时，类型原有的类型被**剥夺**了，此时 vtable 中**只有他作为具体特征的方法，而没有了具体类型实现的方法**。

### 对象安全
- 方法的返回类型不能是 Self
- 方法不能使用泛型参数

因为特征对象已经失去了具体类型，因此我们如果我们返回了具体的`Self`类型，无法确定这个类型是什么。同样，对于泛型类型参数，我们会在编译器放入具体参数，当特征对象会导致具体类型被丢弃，我们也无法得知放入的泛型参数类型是什么。

### 特征对象的使用
一句话：特征对象有两种使用方式`&dyn A`和`Box<dyn A>`，区别上面也讲过了。

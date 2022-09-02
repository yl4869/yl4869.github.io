---
tags: ["C/C++"]
title: "C++下的四种cast转换方法"
date: 2021-12-08T19:36:06+08:00
draft: false
---

# 前言
C++有四种显式类型转换方法，分别是**dynamic_cast**, **reinterpret_cast**, **static_cast**, **const_cast**。  
他们的使用方法为  
```cpp
dynamic_cast <new_type> (expression)  
reinterpret_cast <new_type> (expression)  
static_cast <new_type> (expression)
const_cast <new_type> (expression)
```

与之相对，我们也回忆一下传统的类型转换方法  

```cpp
(new_type) expression
new_type (expression)
```

下面就四种类型转换进行简单介绍。

## dynamic_cast 

有需要提前指出的是，*dynamic_cast*运算符更多是用来实现**RTTI**（运行时类型识别 *run-time type identification*） 功能,其中*dynamic_cast*用来将基类的指针或引用安全地转移成派生类的指针或引用。

>使用RTTI时必须加倍小心，更多时候最好定义虚函数，使用时程序员必须清楚地知道转换的目标模型并且必须检查类型转换是否被成功执行。  

*dynamic_cast*只用在指向类的指针，引用（或void *)上。这种转换允许upcast（从派生类向基类的转换）也能downcast（从基类向派生类的转换），这时需要转过去的指针所指向的目标有效且完整。  
举例说明

```cpp
#include<iostream>
#include<exception>
using namespace std;

class Base {virtual void dummy() {} };
class Derived : public Base { int a; };

int main()
{
    try
    {
        Base * pba = new Derived;
        Base * pbb = new Base;
        Derived * pd;

        pd = dynamic_cast<Derived*>(pba);
        if( pd == 0 ) cout << "Null pointer on first type-case.\n";

        pd = dynamic_cast<Derived*>(pbb);
        if( pd == 0 ) cout << "Null pointer on second type-cast.\n";

    } catch ( exception& e ) { cout << "Exception: " << e.what(); }
    return 0;
}
```
输出：

```textplain
Null Pointer on second type-cast
```

这里做一个解释，当*dynamic_cast*语句的转换目标为指针并且失败时，结果为0，如果转换目标是引用并且失败了，则*dynamic_cast*会抛出一个*bad_cast*异常。  
类型转换可以成功的要求：被转换类型是目标*new type*的公有派生类，公有基类或者就是目标类型*new type*的类型,同时保证被转换类型具有目标类型的完整信息（父类到子类时，父类指针真实的指向了对应的子类类型，则转换可以成功。否则，转换失败。   
可见第二次转换无法成功的原因时pbb指向了基类Base，对派生类Derived而言是不完整的。    

## static_cast

*static_cast*可以用作普通类型转换以及类的upcast，downcast转换，值得注意的是它并不会有运行时检查来保证转换的有效和完整，这完全依靠程序员来确保，因此有可能发生*running error*

## reinterpret_cast
正如名字所说，*reinterpret_cast*对指针指向的二进制块进行一个重新解释，也并不会考虑安全性的问题，下面以代码为例。
```cpp
#include<iostream>
using namespace std;
int main()
{
    int num = 0x00646566;
    int * pnum = &num;
    char * pstr = reinterpret_cast<char *>(pnum);
    cout <<  pnum << endl;
    cout <<  static_cast<void *>(pstr) << endl;
    cout <<  hex << *pnum << endl;
    cout <<  pstr << endl;
    return 0;
}
```

输出：

```textplain
0x7ffc0fce6224
0x7ffc0fce6224
646566
fed
```
可见*reinterpret_cast*改变了解释文件的方式，但并没有改变其他的东西，但要注意这可能是危险的。
关于为什么会反向输出fed而不是def，挖个坑下次填。

## const_cast

*const_cast*用于取出对变量的const或volatile限定，转换后指针指向原来的变量，指针地址不改变。  
也就是说，我们可以利用这种方式通过转换去除const进行对const变量的修改。  
>注意，这是十分危险的行为，我们不建议这样做，只有当你真的需要用到去除const这种要求的时候才能这样。

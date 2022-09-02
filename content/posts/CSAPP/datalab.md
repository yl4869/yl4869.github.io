---
tags: ["CSAPP"]
title: "Datalab实验记录"
date: 2021-12-17T11:14:14+08:00
draft: false
---

# CSAPP:Data Lab 记录

1. bitXor(x,y)

   使用两种运算实现异或操作（&与～），要求指令数最多为14

   ```c
    //1
    /* 
     * bitXor - x^y using only ~ and & 
     *   Example: bitXor(4, 5) = 1
     *   Legal ops: ~ &
     *   Max ops: 14
     *   Rating: 1
     */
    int bitXor(int x, int y) {
        int nx = ~x;
        int ny = ~y;
        int fx = x & ny;
        int fy = nx & y;
        return ~( (~fx) & (~fy) );
    }
   ```

   > 采用的是离散数学中亦或的另一种定义方式,$$P \oplus Q = (P \wedge \neg Q) \vee (\neg P \vee Q)$$.由于本题中不能直接实现或运算，所以通过非和与实现

2. tmin(void)

   返回二进制补码integer的最小值，允许使用！，～，&，^,|,+操作符

   ```c
     /* 
     * tmin - return minimum two's complement integer 
     *   Legal ops: ! ~ & ^ | + << >>
     *   Max ops: 4
     *   Rating: 1
     */
    int tmin(void) {
    
      return 1 << 31;
    
    }
   ```

   > 本题实现十分简单，int型本身以补码32位形式表示，所以只要将1移动到最高位就可以（左移31）

3. isTmax(int x)

   给定一个数，如果是maxium，返回1，否则返回0，允许使用！，～，&，^,|,+运算符

   ```c
    //2
    /*
     * isTmax - returns 1 if x is the maximum, two's complement number,
     *     and 0 otherwise 
     *   Legal ops: ! ~ & ^ | +
     *   Max ops: 10
     *   Rating: 1
     */
    int isTmax(int x) {
    
        int a = x + 1;
        int b = ~a;
        return !(b ^ x) & !!a;
    }
   ```

   > 本题实现用了些小技巧，考虑到补码的不对称性与异或运算的逆元特性。Tmax+1 = Tmin; ~Tmin = Tmax;
   >
   > 同时还要考虑ｘ的特殊情况：x为-1时(a为０时)。

4. allOddBits(int x)

   如果x的奇数位上全为1，则返回1，否则返回0，允许使用！，～，&,^,|,+,|,<<,>>

   ```c
    /* 
     * allOddBits - return 1 if all odd-numbered bits in word set to 1
     *   where bits are numbered from 0 (least significant) to 31 (most significant)
     *   Examples allOddBits(0xFFFFFFFD) = 0, allOddBits(0xAAAAAAAA) = 1
     *   Legal ops: ! ~ & ^ | + << >>
     *   Max ops: 12
     *   Rating: 2
     */
    int allOddBits(int x) {
        int a = (0xAA << 24) + (0xAA << 16) + (0xAA << 8) + 0xAA;
        int b = a & x;
        return !(b ^ a);
    }
   ```

   > 这些问题首先要确定最后需要返回的是1，所以我倾向于用！运算完成（只会有0，1两种取值，而位运算可能有多种结果），由由我们只可以使用最大0xff的常数，但我们可以移位啊！所以我们可以构造一个0xAAAAAAAA，并且与x相与（完成一个掩码的运算，只留下奇数位）。这个时候得到的值要么是可以判断的0xAAAAAAAA，要么是其他不满足条件的值，通过与我们构造的0xAAAAAAAA进行异或运算，我们可以完成对x的奇数位上是否全为1的判断。

5. negate(int x)

   返回一个数的相反数，允许使用！，～，&,^,|,+,<<,>>

   ```c
    /* 
     * negate - return -x 
     *   Example: negate(1) = -1.
     *   Legal ops: ! ~ & ^ | + << >>
     *   Max ops: 5
     *   Rating: 2
     */
    int negate(int x) {
        return ~x + 1;
    }
   ```

   > 这道题就十分简单了，运用取反加1的操作可以直接得到结果

6. isAsciiDigit(int x)

   判断x是否在ASCII码范围内（0x30 - 0x39） 允许使用 ！，～，&，^,|,+,<<,>>

   ```c
   int isAsciiDigit(int x) {
        int a = x | 0x30;
        int b = ( (x + 0x6) & 0xf ) | 0x30;
        return !(b^(x+0x6)) & !(a^x);
    }
   ```

   > 本题给出了十六进制，我们也可以直接用十六进制进行比较。利用布尔代数中的逆元（a^a = 0)。
   >
   > 首先判断下界：通过a ^ x:  a由x|0x30完成，此时a满足a >= 0x30
   >
   > 之后考虑上界，运用类似的思想，我们可以利用进位，当x+0x6发生进位时，我们可以认为x的第一位（右数）是大于0x9的或者第二位是大于0x3的，通过与和或运算，我们将b变回一个发生溢出时成为0x3？的状态。此时与（x+0x6）相异或，就可以判断出是否满足上界了。

7. conditional( int x, int y, int z )

    实现三目运算符，x ? y : z;  允许使用!,~,$,^,|,+,<<,>>
    ```c
    int conditional(int x, int y, int z) {
        int a = !!x + ~1 + 1;
        int b = !!!x + ~1 + 1;
        int zz = a & z;
        int yy = b & y;
        return zz | yy;
    }
    ```
    > 通过两次!运算，我们可以将一个int型转换成布尔型（伪），-1 & x = x    利用这个特性我们可以判断ｘ为１时，选择ｙ&-1,x为０时，选择ｚ& -1.

8. isLessOrEqual(int x,int y)

    判断x是否小于等于y，满足返回1，否则返回0.允许使用!,~,&,^,|,+,<<,>>
    ```c
    int isLessOrEqual(int x, int y) {
        int a = ( x >> 31 ) & 0x1;
        int b = ( y >> 31 ) & 0x1;
        int c = a ^ b;
        int d = c & a;
        int ll = ~(1 << 31) ;
        int m  = x & ll;
        int n  = y & ll;
        int k = m + ~n + 1;
        int s = ( k >> 31 ) & 0x1;
        int ans =  !!k  & !s ;
        return d | ( !c & !ans ) ; 
    }
    ```
    > 简单思考，我们将符号位与后31位进行分离。d决定是否异号并且x小于0，c为0时说明同号，c为1时说明异号。s判断m-n时的正负。这样我们可以知道。ans为1时，m-n大于等于0.判定小于等于零的两个方式，第一种时异号a小于零。第二种是同号m-n大于等于0.

9. logicalNeg(int x)    

实现!运算符，允许使用~,&,^,|,+,<<,>>
```c
int logicalNeg(int x) {
    int a = x >> 31;
    int b = (~x + 1) >> 31;
    int c = a | b;
    int d = c + 1;
    return d & 0x1;
}
```
> 利用了0的特点，除了+0和-0都是0，而对于其他值，通过两种异号数的移位可以得到c为-1，则d为0.

10. howManyBits(int x)

计算至少需要多少位才能表达x。允许使用!,~,&,^,|,+,<<,>>
```c
int howManyBits(int x) {
    int b16,b8,b4,b2,b1,b0;
    int sign = x >> 31;
    x = (~sign & x) | (sign & ~x);

    b16 = !!(x >> 16) << 4;
    x = x >> b16;
    b8 = !!(x >> 8) << 3;
    x = x >> b8;
    b4 = !!(x >> 4) << 2;
    x = x >> b4;
    b2 = !!(x >> 2) << 1;
    x = x >> b2;
    b1 = !!(x >> 1);
    x = x >> b1;
    b0 = x;
    return b16 + b8 + b4 + b2 + b1 + b0 + 1;
}
```
> 注意是补码表示，所以需要一位补码的符号位存在，即便是正数。之后就可以考虑用多少位表示。x为正数的话，直接进行计数，x为负数的话，需要计算的就是最靠近符号位的第一个0开始的位数（回忆补码的算数右移）。因此通过对x进行取反可以找到那个1，然后再通过16，8，4，2，1，的方式进行计数。

11. floatScale2(signed uf)  
返回2*f的位表示，算是啥都允许使用了注意NaN是直接返回的  
```c
unsigned floatScale2(unsigned uf) {
    int sign = (uf >> 31) << 31;
    int exp = (uf >> 23) & 0xff;
    if(exp == 0) return sign | (uf << 1);
    if(exp == 255) return uf;
    if(exp + 1 == 255) return sign | 0x7f800000;
    exp = exp + 1;
    return ( uf & 0x007fffff) | (exp << 23) | sign;
}
```
> 将sign，exp分离出来，（frac直接在后面可以直接操作）；exp为0时，直接uf左移一位完成运算（添加符号位）。exp为255则为，Inf和NaN都返回本身，因此exp全为1时直接返回，同样，如果乘2后exp全为1时，返回Inf。之后就正常进行运算和exp+1后进行组合就好。

12. floatFloat2Int(unsigned uf)  
将浮点数转换为整数
```c
int floatFloat2Int(unsigned uf) {
    int sign = uf >> 31;
    int exp = (uf >> 23) & 0xff;
    int frac = uf & 0x7fffff;
    int e_b = exp - 127;
    if(e_b < 0) return 0;
    if(e_b > 31) return 0x80000000u;

    int a = 1 << e_b;
    int b = frac >> (23 - e_b);
    int ans = a + b;
    if(sign == 1) return ~ans + 1;
    else return ans;
}
```
> 当溢出时返回给定的溢出值0x80000000u,这里需要考虑exp位进行bias偏移后的值，当e_b < 0时，就是0，当e_b大于31时，说明溢出。浮点的计算方式是通过2^e * M,而本身就是整数，所以对小数部分计算的是反向移位。

13. floatPower2(int x)   
求2.0^x
```c
unsigned floatPower2(int x) {
    int INF = 0xff << 23;
    int exp = x + 127;
    if(exp <= 0) return 0;
    if(exp >= 255) return INF;
    return exp << 23;
}
```
> 2.0的位级表示是（1.0 * 2^1):可以考虑到符号位是0，指数为1+127=128;frac=1.0-1=0; 这样这道题就显而易见了。依旧考虑exp+bias的情况。
## 总结
>1. 一定要自己亲自做一次  
>2. 多反思，多总结  
>3. 多翻书，知识点很多都在书里  

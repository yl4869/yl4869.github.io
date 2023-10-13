---
TocOpen: true
title: "仲裁器"
tags: ["digital_design"]
date: 2023-10-13T14:06:24+08:00
draft: false
---
仲裁器是数字设计中常见的模块，应用广泛。仲裁器往往和其他组件使用在一起以组成仲裁电路。如仲裁器+编码器可以实现优先编码器。

## 逻辑图
下面是一位仲裁器的逻辑图k

![一位仲裁器逻辑图](/image/digital_design/one_arb.png)

只有当输入为1且当前仍未找到1时输出为真，如果之前已经找到1，输出信号会通知其他阶段已经找到了1。

仲裁器可以实现为迭代电路，我们可以先设计1位逻辑电路，然后逐级连接组成多位的仲裁器:

![多位仲裁器迭代电路](/image/digital_design/more_bit_arb.png)

也可以使用超前进位的方式实现：

![超前进位的仲裁器实现](/image/digital_design/Lookahead_arb.png)

## verilog 实现
我们可以使用 `casex` 语句很方便的实现仲裁器：
```verilog
module Arb_4b(r, g);
  input [3:0] r;
  output [3:0] g;
  reg [3:0]  g;
  always @(*) begin 
    casex(r) 
      4'b0000: g = 4'b0000;
      4'bxxx1: g = 4'b0001;
      4'bxx10: g = 4'b0010;
      4'bx100: g = 4'b0100;
      4'b1000: g = 4'b1000;
      default: g = 4'hx;
    endcase
  end
endmodule
```

当我们想要任意宽度的仲裁器时，可以用下面的实现：
```verilog
module Arb(r, g);
// LSB 优先级最高
  parameter n=8;
  input [n-1:0] r;
  output [n-1:0] g;
  wire [n-1:0] c = {(~r[n-2:0] & c[n-2:0]), 1'b1};
  assign g = r & c; 
endmodule

module Arb(r, g);
// MSB 优先级最高
  input [n-1:0] r;
  output [n-1:0] g;
  wire [n-1:0] c = {1'b1, (~r[n-1:1] & c[n-1:1])};
  assign g = r & c;
endmodule
```
## 可编程优先级仲裁器
使用位片式标记法可以编写优先级可编程的仲裁器，这里使用独热码负责指示标记，功能的实现为下面的语句：
```verilog
wire [n-1:0] c = ({~r[n-2:0], ~r[n-1]} & {c[n-2:0], c[n-1]}) | p;
assign g = r & c;
```
这里的直观理解为我们将最后一级的输出连接到第一级的输出，同时使用独热码作为起始的输出，但这样会产生组合环路的问题。

为了使逻辑无环，我们可以复制进位链的方式进行实现：
```verilog
wire [2*n-1:0] c = ({~r[n-2:0], ~r, ~r[n-1]} & {c[2*n-2:0], 1'b0}) | {{n{1'b0}}, p};
assign g = r & (c[2*n-1:0] | c[n-1:0]);
```

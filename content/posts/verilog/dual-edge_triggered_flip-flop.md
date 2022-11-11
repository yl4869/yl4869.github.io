---
TocOpen: true
title: "Verilog 实现双边沿触发器Dual Edge_triggered_flip Flop"
date: 2022-11-11T19:10:13+08:00
draft: false
---

# Verilog 实现双边沿触发器Dual Edge_triggered_flip Flop
在做HDLbits时，有一道很有趣的[双边沿触发器问题](https://hdlbits.01xz.net/wiki/Dualedge) ，这里记录一下相关内容和解答方式。

## 问题描述
实现一个双边沿触发器，即在时钟的上升沿和下降沿都被触发。

```verilog
module top_module (
    input clk,
    input d,
    output q
);
```

## 问题
无法直接通过`always @(posedge clk or negedge clk)`直接创建双边沿触发器，FPGA 中只能存在单边沿触发器。

> 但是你可以创建两个触发器，分别是上升沿和下降沿。

## 解决方案（1）
虽然我们无法直接创建双边沿触发器，但是可以通过使用两个触发器和一个多路选择器实现相同的功能。

```verilog
module top_module (
    input clk,
    input d,
    output q
);
    reg q1;
    reg q2;
    always @(posedge clk) begin
        q1 <= d;
    end
    always @(negedge clk) begin 
        q2 <= d;
    end
    assign q = clk ? q1 : q2;
endmodule
```

> 注意，你可能想要两个触发器内都填写`q <= d`，这在思维上是合理的，但是在实现中会引入多驱问题。

但这又引入了另一个问题：毛刺（[glitch](https://zh.wikipedia.org/wiki/小故障)）的出现，因为触发器的输出会存在一个延迟。

![glitch 的产生](/image/verilog/1.png) 

## 解决方案（2）
解决毛刺的一种方案，也是HDLbits给出的答案：通过异或门消除毛刺

```verilog 
module top_module(
    input clk,
    input d,
    output q);
    
    reg p, n;
    
    always @(posedge clk)
        p <= d ^ n;
        
    always @(negedge clk)
        n <= d ^ p;
    
    assign q = p ^ n;
endmodule
```

通过上面的方案，对于上升沿的选择`p ^ n = d ^ n ^ n = d`，对于下降沿`p ^ n = n ^ d ^ n = d`。由于 p 和 n 都通过触发器产生，因此可以消除毛刺。

## 总结
由于硬件的限制，手动实现双边沿触发器需要一些'小技巧'，同时也要注意毛刺的消除。

## 附页
[[Synth 8-91]相关问题的解释，Xilinx社区](https://support.xilinx.com/s/question/0D52E00006hpXVVSA2/synth-891-ambiguous-clock-in-event-control?language=en_US) 

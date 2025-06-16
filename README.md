# 2025年北京科技大学计算机与通信工程学院计算机组成原理实验

根据实验要求使用 LoongArch32R 架构实现了一个五级单周期流水线 cpu，并完成了扩展指令。

已支持的指令如下：

* `lu12i`
* `addw`
* `addiw`
* `subw`
* `slt`
* `sltu`
* `and`
* `or`
* `xor`
* `nor`
* `slliw`
* `srliw`
* `sraiw`
* `ldw`
* `stw`
* `jirl`
* `b`
* `bne`
* `bl`
* `beq`
* `ori`
* `xori`
* `andi`
* `pcaddu12i`（扩展）
* `slti`（扩展）
* `sra`（扩展）
* `srl`（扩展）
* `sll`（扩展）
* `sltui`（扩展）

此外，考试的时候要求扩展了另外三个指令，包括 `mului`，`div`，`sll`，同时 `alu.v`也做了相应扩展以满足乘法和除法的需要。

ps：考试代码在压缩包 `sll_w, mul_wu, div_w.zip`，这里面的实现不包括上面标记扩展的部分。

rust文件

## Rust 文件（.rs 文件）完全指南

Rust 源代码文件的后缀是 **`.rs`** ，是编写 Rust 程序的核心文件，我给你整理了最实用、开箱即用的知识点。

## 1\. 基础概念

- 文件名： **小写 + 下划线** （Rust 规范）例： `main.rs` 、 `hello_world.rs` 、 `my_module.rs`
- 编码：必须是 **UTF-8**
- 编译：用 `rustc` 直接编译，或用 `cargo` 管理项目

## 2\. 最简单的 Rust 文件（可直接运行）

创建 `main.rs` ：

```rust
// main.rs —— Rust 程序入口文件
fn main() {
    // 主函数：程序从这里开始执行
    println!("你好，Rust！");
}
```

### 编译 + 运行

```bash
# 编译
rustc main.rs

# 运行（Windows）
main.exe

# 运行（macOS/Linux）
./main
```

## 3\. Rust 文件的核心结构

```rust
// 1. 导入库（外部/标准库）
use std::io;

// 2. 主函数（必须有，可执行程序入口）
fn main() {
    println!("Hello from Rust!");
    
    // 调用自定义函数
    let sum = add(2, 3);
    println!("2 + 3 = {}", sum);
}

// 3. 自定义函数
fn add(a: i32, b: i32) -> i32 {
    a + b
}
```

## 4\. 两种 Rust 文件用途

### A. 可执行文件（生成二进制程序）

必须包含 **`main()` 函数** ，例如：

- `main.rs`
- `cli.rs`

### B. 库文件（供其他代码调用）

没有 `main()` ，只提供函数 / 结构体，例如：

## 5\. Cargo 项目中的 Rust 文件

用 Cargo 管理时，结构固定：

```
你的项目/
├── src/
│   ├── main.rs    # 可执行程序入口
│   └── lib.rs     # 库文件（可选）
└── Cargo.toml     # 配置文件
```

运行项目：

```bash
cargo run
```

## 6\. 常见 Rust 文件小知识

- 注释：
	- 单行： `// 注释`
		- 文档注释： `/// 生成文档`
- 语句必须以分号 `;` 结尾（表达式除外）
- 严格区分大小写
- 一个 `.rs` 文件可以包含：函数、结构体、枚举、 trait、常量等

---

### 总结

1. Rust 源码文件后缀是 **`.rs`**
2. 可执行程序必须有 **`fn main()`**
3. 直接运行： `rustc 文件名.rs` + 执行二进制
4. 项目开发用 **Cargo** ，默认入口是 `src/main.rs`

你需要我帮你 **创建一个完整的 Rust 项目模板** ，或者 **解释某个具体的.rs 文件代码** 吗？

如何在 Rust 文件中使用外部库？

如何在 Rust 中编写测试文件？

如何在 Rust 中处理错误？
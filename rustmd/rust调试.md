rust调试

## Rust 调试完全指南

Rust 调试主要分 **轻量打印调试** （快速定位）和 **专业调试器调试** （断点 / 单步 / 查看内存）两种方式，我会给你最实用、开箱即用的方案。

## 一、最简单：打印调试（快速排查）

适合小问题、快速验证变量，无需任何配置：

```rust
fn main() {
    let num = 10;
    let arr = [1, 2, 3];

    // 基础打印
    println!("数字: {}", num);
    // 调试打印（支持几乎所有 Rust 类型）
    dbg!(num);
    // 打印复杂类型
    dbg!(&arr);
}
```

### 核心：dbg! 宏（Rust 专属神器）

- 自动输出 **文件名 + 行号 + 变量值**
- 支持结构体、枚举、集合等所有可调试类型
- 不影响原代码逻辑，调试完直接删除即可

运行： `cargo run`

---

## 二、专业调试：VS Code + 调试器（推荐）

这是最常用、最舒服的 Rust 调试方案，支持 **断点、单步执行、查看变量、调用栈** 。

### 1\. 必备环境安装

1. 安装 [VS Code](https://code.visualstudio.com/)
2. 安装 Rust 插件：搜索 **rust-analyzer** （必装）
3. 安装调试插件：搜索 **CodeLLDB** （核心调试器）
4. 确保安装了调试工具：
	```bash
	# Windows/Linux/macOS 通用
	rustup component add llvm-tools-preview
	```

### 2\. 一键配置调试文件

在你的 Rust 项目根目录创建：`.vscode/launch.json` 内容直接复制粘贴：

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "type": "lldb",
            "request": "launch",
            "name": "Debug Rust",
            "cargo": {
                "args": ["build"]
            },
            "cwd": "${workspaceFolder}",
            "stopOnEntry": false,
            "sourceLanguages": ["rust"]
        }
    ]
}
```

### 3\. 开始调试

1. 在代码行号左侧 **点击添加断点** （出现红点）
2. 按 `F5` 启动调试
3. 调试快捷键：
	- `F5` ：继续执行
		- `F10` ：单步跳过（不进入函数）
		- `F11` ：单步进入（进入函数内部）
		- `Shift+F5` ：停止调试

---

## 三、命令行调试（lldb 终端调试）

不使用 IDE，直接在终端调试：

```bash
# 1. 编译带调试信息的程序
cargo build

# 2. 启动调试器（macOS/Linux）
lldb ./target/debug/你的项目名

# 常用命令
b main      # 在 main 函数打断点
run         # 运行
n           # 单步执行
p 变量名    # 打印变量
q           # 退出调试
```

Windows 对应工具： `cdb` 或 `gdb`

---

## 四、常见调试问题与解决方案

1. **断点不生效**
	- 必须用 `cargo build` / `cargo run` （默认带调试信息）
		- 不要用 `cargo build --release` （发布版无调试信息）
2. **结构体无法打印** 给结构体加 `#[derive(Debug)]` ：
	```rust
	#[derive(Debug)]
	struct User {
	    name: String,
	    age: u32,
	}
	```
3. **查看变量详情**
	- VS Code 调试面板直接看
		- 终端： `dbg!(&变量)` 或 `println!("{:?}", 变量)`

---

### 总结

1. **快速调试** ：用 `dbg!` 宏，零配置
2. **日常开发** ：VS Code + rust-analyzer + CodeLLDB，按 F5 调试
3. **命令行** ： `cargo build` + `lldb` 调试
4. 所有调试都必须使用 **Debug 构建** （默认），不能用 Release 版

需要我根据你的 **操作系统** （Windows/macOS/Linux）给你定制专属调试步骤吗？

除了 VS Code，还有哪些常用的 Rust 调试工具？

如何在 Rust 中设置断点？

如何使用 Rust 调试器进行单步调试？
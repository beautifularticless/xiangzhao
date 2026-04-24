rust进程

Rust 标准库通过 `std::process` 模块提供 **创建、控制、等待子进程** 以及 **管理自身进程** 的能力，跨平台（Windows/macOS/Linux）且安全易用。下面从核心类型、常用用法、进程间通信、异步进程与注意事项五方面说明。

---

### 一、核心类型概览

- **`Command`** ：进程构建器，配置程序路径、参数、环境、工作目录、标准流等。
- **`Child`** ：代表已启动的子进程，可等待、终止、获取 PID。
- **`ExitStatus`** ：子进程退出状态（成功 / 失败、退出码、信号）。
- **`Output`** ：子进程完整输出（stdout/stderr/ 退出状态），由 `output()` 返回。
- **`Stdio`** ：标准流重定向配置（继承 / 管道 / 空 / 文件）。

---

### 二、基础用法（同步）

#### 1\. 简单执行并获取输出（阻塞）

```rust
use std::process::Command;

fn main() {
    // 执行 echo "Hello Rust"，等待结束并捕获输出
    let output = Command::new("echo")
        .arg("Hello Rust")
        .output()
        .expect("执行失败");

    // 打印标准输出
    println!("stdout: {}", String::from_utf8_lossy(&output.stdout));
    // 打印标准错误
    println!("stderr: {}", String::from_utf8_lossy(&output.stderr));
    // 退出状态
    println!("status: {}", output.status);
}
```

#### 2\. 启动子进程并异步控制（spawn）

```rust
use std::process::{Command, Stdio};

fn main() {
    // 启动 sleep 5，不阻塞当前线程
    let mut child = Command::new("sleep")
        .arg("5")
        .spawn()
        .expect("启动子进程失败");

    println!("子进程 PID: {}", child.id());

    // 等待子进程结束（阻塞）
    let status = child.wait().expect("等待失败");
    println!("子进程退出: {}", status);
}
```

#### 3\. 重定向标准流（管道通信）

```rust
use std::process::{Command, Stdio};
use std::io::{Write, Read};

fn main() {
    // 子进程：grep "rust"，stdin/stdout 管道
    let mut child = Command::new("grep")
        .arg("rust")
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .spawn()
        .unwrap();

    // 向子进程 stdin 写入数据
    let stdin = child.stdin.as_mut().unwrap();
    stdin.write_all(b"hello rust\nhello world\n").unwrap();

    // 读取子进程 stdout 输出
    let mut stdout = String::new();
    child.stdout.as_mut().unwrap().read_to_string(&mut stdout).unwrap();

    println!("子进程输出: {}", stdout);
}
```

#### 4\. 自身进程控制

```rust
use std::process;

fn main() {
    // 退出当前进程，退出码 0
    process::exit(0);

    // 异常终止（不执行析构）
    // process::abort();
}
```

---

### 三、进程间通信（IPC）常用方式

1. **标准流管道（Stdio::piped）** ：最常用，父子进程双向读写，示例见上文。
2. **文件 / 命名管道** ：跨进程读写文件，Unix 域套接字（ `tokio::net::UnixStream` ）。
3. **信号（Unix）** ： `kill` 发送信号，子进程注册信号处理（ `signal-hook` crate）。
4. **共享内存** ： `memmap2` crate 实现跨进程内存共享。

---

### 四、异步进程（Tokio）

生产环境常用 `tokio::process::Command` ，非阻塞、配合 `async/await` ：

```toml
# Cargo.toml
[dependencies]
tokio = { version = "1.0", features = ["full"] }
```

```rust
use tokio::process::Command; // 异步 Command

#[tokio::main]
async fn main() {
    // 异步执行命令，非阻塞
    let output = Command::new("echo")
        .arg("Async Rust")
        .output()
        .await
        .expect("异步执行失败");

    println!("stdout: {}", String::from_utf8_lossy(&output.stdout));
}
```

---

### 五、关键注意事项

1. **跨平台差异**
	- Windows：程序名需带 `.exe` （如 `cmd.exe` ），路径用 `\` 或原始字符串 `r"C:\\"` 。
		- Unix：可直接用 `ls` / `cat` ，路径用 `/` 。
2. **安全**
	- 避免直接拼接命令字符串（防注入），优先用 `.arg()` 逐个传参。
		- 子进程权限默认继承父进程，谨慎配置 `env` / `cwd` 。
3. **资源泄漏**
	- 必须调用 `child.wait()` / `wait_with_output()` 回收子进程，避免僵尸进程。
		- 管道流（stdin/stdout/stderr）需显式 drop 或读取完毕，防止阻塞。

---

### 六、常用 Crate 扩展

- **tokio** ：异步进程、异步 IPC。
- **command-group** ：跨平台管理子进程组，批量终止。
- **signal-hook** ：信号处理，优雅退出。
- **memmap2** ：共享内存 IPC。

需要我把这些示例整理成一个可直接运行的 **Cargo 项目模板** ，包含同步 / 异步代码和完整的 `Cargo.toml` 吗？

在Rust中如何创建一个新进程？

如何在Rust中等待子进程结束？

如何在Rust中获取子进程的退出状态？
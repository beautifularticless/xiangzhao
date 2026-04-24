rust错误处理

## Rust 错误处理：从入门到精通

Rust 的错误处理 **没有异常（Exception）** ，是 **类型安全、编译期强制检查** 的设计，核心分为两类：

1. **可恢复错误** ：程序可以处理、继续运行（如文件不存在、网络超时）→ 用 `Result<T, E>`
2. **不可恢复错误** ：程序无法修复、必须终止（如数组越界、空指针）→ 用 `panic!`

这是 Rust 最核心、最优雅的特性之一， **强制你在编码时就处理所有错误** ，杜绝运行时崩溃。

---

## 一、不可恢复错误：panic!

当出现 **严重 bug、无法修复** 的问题时，调用 `panic!` 宏，程序会：

1. 打印错误信息和调用栈
2. 终止程序

### 1\. 手动触发 panic

```rust
fn main() {
    // 直接触发 panic
    panic!("服务器连接失败，无法继续运行！");
}
```

### 2\. 自动触发 panic

Rust 内置操作会自动 panic：

```rust
let arr = [1, 2, 3];
// 数组越界 → 自动 panic
println!("{}", arr[10]);
```

### 3\. 生产环境优化

- 开发环境：默认打印完整调用栈
- 生产环境：在 `Cargo.toml` 关闭调用栈，减小二进制体积

```toml
[profile.release]
panic = "abort"
```

---

## 二、可恢复错误：Result<T, E>（核心）

这是 Rust 90% 的错误处理方式， **标准库枚举** ：

```rust
enum Result<T, E> {
    Ok(T),  // 成功：返回正常值 T
    Err(E), // 失败：返回错误信息 E
}
```

### 1\. 基础用法：match 匹配

最原始、最清晰的错误处理方式：

```rust
use std::fs::File;

fn main() {
    // 打开文件：返回 Result<File, Error>
    let file = File::open("hello.txt");

    // 必须处理成功/失败两种情况
    match file {
        Ok(_f) => println!("文件打开成功"),
        Err(e) => println!("文件打开失败：{}", e),
    }
}
```

### 2\. 简化写法：unwrap /expect

- `unwrap()` ：成功返回值，失败直接 panic
- `expect()` ：自定义 panic 信息（ **推荐** ）

```rust
// 失败直接 panic
let file = File::open("hello.txt").unwrap();

// 失败 panic + 自定义提示（调试更友好）
let file = File::open("hello.txt").expect("文件不存在，请检查路径");
```

---

## 三、传播错误：? 运算符（Rust 神器）

这是 Rust 最优雅的特性： **在函数内把错误向上抛出，交给调用者处理** 。

### 规则

1. 只能用于 **返回 Result 类型** 的函数
2. `?` 等价于：成功返回值，失败直接返回 Err 给上层

### 示例：读取文件内容

```rust
use std::fs::File;
use std::io::{self, Read};

// 函数返回 Result：成功返回 String，失败返回 io::Error
fn read_file() -> Result<String, io::Error> {
    // ?：打开失败直接返回 Err，不再执行后续代码
    let mut file = File::open("hello.txt")?;

    let mut content = String::new();
    // ?：读取失败直接向上抛出错误
    file.read_to_string(&mut content)?;

    // 成功返回内容
    Ok(content)
}

fn main() {
    match read_file() {
        Ok(s) => println!("文件内容：{}", s),
        Err(e) => println!("读取失败：{}", e),
    }
}
```

对比其他语言的 `try/catch` ，Rust 的 `?` **更简洁、类型安全、无运行时开销** 。

---

## 四、自定义错误类型（进阶）

实际项目中，需要统一管理多种错误，步骤：

1. 定义错误枚举
2. 实现 `std::error::Error` trait
3. 用 `?` 自动转换错误

### 完整示例

```rust
use std::error::Error;
use std::fmt;
use std::fs::read_to_string;
use std::num::ParseIntError;

// 1. 自定义错误枚举
#[derive(Debug)]
enum AppError {
    FileError(std::io::Error),
    ParseError(ParseIntError),
}

// 2. 实现 Display  trait（打印错误信息）
impl fmt::Display for AppError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            AppError::FileError(e) => write!(f, "文件操作失败：{}", e),
            AppError::ParseError(e) => write!(f, "数字解析失败：{}", e),
        }
    }
}

// 3. 实现 Error trait（标准错误接口）
impl Error for AppError {}

// 4. 自动转换子错误
impl From<std::io::Error> for AppError {
    fn from(e: std::io::Error) -> Self {
        AppError::FileError(e)
    }
}
impl From<ParseIntError> for AppError {
    fn from(e: ParseIntError) -> Self {
        AppError::ParseError(e)
    }
}

// 业务函数：统一返回自定义错误
fn read_and_parse() -> Result<i32, AppError> {
    // ? 自动转换为 AppError
    let content = read_to_string("number.txt")?;
    let num: i32 = content.trim().parse()?;
    Ok(num)
}

fn main() {
    match read_and_parse() {
        Ok(n) => println!("解析成功：{}", n),
        Err(e) => println!("{}", e),
    }
}
```

---

## 五、最佳实践（必看）

1. **永远不要用 panic 处理业务错误**
	- `panic` 只用于 bug、断言、不可修复的问题
		- 业务逻辑（网络、文件、参数）一律用 `Result`
2. **库代码必须返回 Result**
	- 让调用者决定如何处理错误，不要擅自 panic
3. **优先使用？简化代码**
	- 替代臃肿的 `match` ，让逻辑更清晰
4. **项目统一自定义错误**
	- 用 `thiserror` 库简化自定义错误（社区标准）
		- 用 `anyhow` 库快速处理应用错误（小项目首选）

---

## 六、常用库推荐

### 1\. anyhow（应用程序首选）

一键简化错误处理，无需自定义错误：

```toml
[dependencies]
anyhow = "1.0"
```

```rust
use anyhow::{Result, Ok};

fn main() -> Result<()> {
    let content = std::fs::read_to_string("hello.txt")?;
    println!("{}", content);
    Ok(())
}
```

### 2\. thiserror（库开发首选）

优雅定义自定义错误：

```toml
[dependencies]
thiserror = "1.0"
```

```rust
use thiserror::Error;

#[derive(Error, Debug)]
pub enum AppError {
    #[error("文件错误：{0}")]
    Io(#[from] std::io::Error),
    #[error("解析错误：{0}")]
    Parse(#[from] std::num::ParseIntError),
}
```

---

### 总结

1. **不可恢复错误** → `panic!`（程序终止）
2. **可恢复错误** → `Result<T, E>` （必须处理）
3. **简化传播** → `?` 运算符（核心神器）
4. **项目实战**

Rust 错误处理的核心思想： **编译期强制处理所有错误，杜绝运行时隐患** 。

如何在match中处理Err？

如何在函数中返回Result？

如何在多个函数调用中传递Result？
rust文件读写

## Rust 文件读写完全指南

Rust 标准库 `std::fs` 和 `std::io` 提供了完整的文件读写能力， **安全、高效** ，无需第三方库即可完成绝大多数文件操作。

下面我分 **基础读写** 、 **逐行读写** 、 **二进制文件** 、 **文件创建 / 追加** 几个常用场景，给你可直接复制运行的代码。

## 一、准备工作

所有代码都不需要额外依赖，直接在 Rust 项目的 `src/main.rs` 中使用即可。创建项目：

```bash
cargo new file_demo
cd file_demo
```

---

## 二、最常用：一次性读写文本文件（简单场景）

适合 **小文件** ，直接把文件全量读入内存、写入内存。

### 1\. 读取整个文件到字符串

```rust
use std::fs;

fn main() -> std::io::Result<()> {
    // 读取文件内容到 String
    let content = fs::read_to_string("test.txt")?;
    println!("文件内容：\n{}", content);

    Ok(())
}
```

### 2\. 写入字符串到文件（覆盖写入）

```rust
use std::fs;

fn main() -> std::io::Result<()> {
    // 覆盖写入，如果文件不存在会自动创建
    fs::write("test.txt", "Hello, Rust 文件读写！")?;
    println!("写入成功！");

    Ok(())
}
```

---

## 三、大文件 / 流式读写：逐行读取（推荐）

处理 **大文件** 时，不要一次性读入内存，用 **逐行读取** 更高效。

```rust
use std::fs::File;
use std::io::{BufRead, BufReader};

fn main() -> std::io::Result<()> {
    // 打开文件
    let file = File::open("test.txt")?;
    // 创建缓冲读取器
    let reader = BufReader::new(file);

    // 逐行遍历
    for line in reader.lines() {
        // line 是 Result<String, Error>
        let line = line?;
        println!("行：{}", line);
    }

    Ok(())
}
```

---

## 四、文件追加写入（不覆盖原有内容）

```rust
use std::fs::OpenOptions;
use std::io::Write;

fn main() -> std::io::Result<()> {
    // 打开文件：可写 + 不存在则创建 + 追加模式
    let mut file = OpenOptions::new()
        .write(true)
        .create(true)
        .append(true)
        .open("test.txt")?;

    // 写入内容
    writeln!(file, "\n这是追加的一行内容")?;
    println!("追加成功！");

    Ok(())
}
```

---

## 五、二进制文件读写（图片 / 视频 / 任意文件）

`read` 读取为字节数组 `Vec<u8>` ，适合所有类型文件。

```rust
use std::fs;

fn main() -> std::io::Result<()> {
    // 读取二进制文件到字节数组
    let bytes = fs::read("image.png")?;
    println!("文件大小：{} 字节", bytes.len());

    // 写入二进制文件
    fs::write("copy.png", &bytes)?;
    println!("复制成功！");

    Ok(())
}
```

---

## 六、常用文件操作

### 1\. 创建文件 / 覆盖文件

```rust
use std::fs::File;

// File::create 会清空已有文件，等价于覆盖写入
let mut file = File::create("new_file.txt")?;
```

### 2\. 检查文件是否存在

```rust
use std::path::Path;

let exists = Path::new("test.txt").exists();
println!("文件是否存在：{}", exists);
```

### 3\. 删除文件

```rust
std::fs::remove_file("test.txt")?;
```

---

## 七、关键概念说明

1. **`?` 运算符**
	- 自动处理错误，遇到文件不存在、权限不足等问题会直接返回错误
		- 函数返回值必须是 `Result<(), E>`
2. **`BufReader` / `BufWriter`**
	- 带缓冲的读写， **性能远高于直接操作文件**
		- 处理大文件必须用
3. **`OpenOptions`**
	- 精细控制文件：读、写、追加、创建、截断等

---

### 总结

1. **小文件** ： `fs::read_to_string` / `fs::write` 最简单
2. **大文件** ： `BufReader` 逐行读取，避免内存爆炸
3. **追加内容** ：用 `OpenOptions::append(true)`
4. **二进制文件** ： `fs::read` / `fs::write` 直接操作字节
5. Rust 文件读写 **安全无野指针** ，错误处理强制规范，非常适合生产环境

需要我给你写一个 **完整的文件复制工具** 、或者 **配置文件读写示例** 吗？

如何在 Rust 中读取二进制文件？

如何在 Rust 中创建目录？

如何在 Rust 中删除文件？
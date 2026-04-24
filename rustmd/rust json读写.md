rust json读写

## Rust JSON 读写完全指南

在 Rust 中处理 JSON **最主流、最推荐** 的方案是使用 **`serde` + `serde_json`** 组合，这是 Rust 生态的事实标准，功能强大、性能优秀、使用简单。

下面我给你完整的 **读写示例 + 常用场景** ，直接复制就能用。

## 1\. 先配置依赖

在 `Cargo.toml` 中添加：

```toml
[dependencies]
serde = { version = "1.0", features = ["derive"] }  # 核心序列化库
serde_json = "1.0"                                   # JSON 具体实现
```

## 2\. 基础：结构体 <-> JSON 互转（最常用）

### 完整代码

```rust
// 导入 serde 序列化/反序列化宏
use serde::{Deserialize, Serialize};
use serde_json::{Result, Value};

// 定义一个可序列化的结构体
#[derive(Debug, Serialize, Deserialize)]
struct User {
    name: String,
    age: u32,
    hobbies: Vec<String>,
    is_student: bool,
}

fn main() -> Result<()> {
    // ==================== 1. 写入：结构体 → JSON 字符串 ====================
    let user = User {
        name: "张三".to_string(),
        age: 20,
        hobbies: vec!["编程".to_string(), "读书".to_string()],
        is_student: true,
    };

    // 结构体转 JSON（格式化输出，带缩进）
    let json_string = serde_json::to_string_pretty(&user)?;
    println!("=== 结构体转 JSON ===");
    println!("{}", json_string);

    // ==================== 2. 读取：JSON 字符串 → 结构体 ====================
    let json_str = r#"
    {
        "name": "李四",
        "age": 22,
        "hobbies": ["游戏", "运动"],
        "is_student": false
    }
    "#;

    // JSON 转结构体
    let user2: User = serde_json::from_str(json_str)?;
    println!("\n=== JSON 转结构体 ===");
    println!("姓名：{}", user2.name);
    println!("年龄：{}", user2.age);
    println!("爱好：{:?}", user2.hobbies);

    Ok(())
}
```

### 运行效果

```
=== 结构体转 JSON ===
{
  "name": "张三",
  "age": 20,
  "hobbies": [
    "编程",
    "读书"
  ],
  "is_student": true
}

=== JSON 转结构体 ===
姓名：李四
年龄：22
爱好：["游戏", "运动"]
```

## 3\. 文件读写 JSON（最实用）

直接把 JSON **写入文件 / 从文件读取** ：

```rust
use serde::{Deserialize, Serialize};
use std::fs::File;
use std::io::prelude::*;

#[derive(Debug, Serialize, Deserialize)]
struct Config {
    port: u16,
    host: String,
    max_connections: u32,
}

fn main() -> serde_json::Result<()> {
    // ==================== 写入 JSON 文件 ====================
    let config = Config {
        port: 8080,
        host: "127.0.0.1".to_string(),
        max_connections: 100,
    };

    // 打开文件
    let mut file = File::create("config.json")?;
    // 写入格式化 JSON
    serde_json::to_writer_pretty(&mut file, &config)?;
    println!("JSON 已写入 config.json");

    // ==================== 读取 JSON 文件 ====================
    let file = File::open("config.json")?;
    let config_read: Config = serde_json::from_reader(file)?;

    println!("\n=== 从文件读取的配置 ===");
    println!("端口：{}", config_read.port);
    println!("地址：{}", config_read.host);

    Ok(())
}
```

执行后会生成 `config.json` 文件：

```json
{
  "port": 8080,
  "host": "127.0.0.1",
  "max_connections": 100
}
```

## 4\. 动态 JSON（无需定义结构体）

如果不想定义结构体，可以直接用 `serde_json::Value` 处理 **任意动态 JSON** ：

```rust
use serde_json::{json, Result, Value};

fn main() -> Result<()> {
    // 直接创建动态 JSON
    let data: Value = json!({
        "name": "动态JSON",
        "score": 95.5,
        "tags": ["rust", "json"]
    });

    // 访问字段
    println!("名称：{}", data["name"].as_str().unwrap());
    println!("分数：{}", data["score"].as_f64().unwrap());

    // 转字符串
    let json_str = serde_json::to_string_pretty(&data)?;
    println!("\n动态 JSON：\n{}", json_str);

    Ok(())
}
```

## 5\. 核心 API 速查

表格

| 功能 | 函数 |
| --- | --- |
| 结构体 → JSON 字符串 | `serde_json::to_string(&obj)?` |
| 结构体 → 格式化 JSON | `serde_json::to_string_pretty(&obj)?` |
| JSON 字符串 → 结构体 | `serde_json::from_str::<T>(json)?` |
| 写入 JSON 文件 | `serde_json::to_writer_pretty(file, &obj)?` |
| 读取 JSON 文件 | `serde_json::from_reader::<T>(file)?` |

---

### 总结

1. Rust 处理 JSON **首选 `serde + serde_json`**
2. **结构体映射** 是最安全、最常用的方式
3. 支持 **文件读写、动态 JSON、格式化输出** 全场景
4. 代码简洁、编译安全、性能极高

需要我给你补充 **嵌套 JSON、可选字段、枚举序列化、JSON 合并 / 修改** 等进阶用法吗？

如何在 Rust 中使用 serde\_json 处理复杂的 JSON 数据结构？

除了 serde\_json，Rust 中还有哪些常用的 JSON 库？

在 Rust 中如何处理 JSON 中的日期和时间类型？
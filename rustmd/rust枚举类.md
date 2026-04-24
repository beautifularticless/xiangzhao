rust枚举类

## Rust 枚举（Enum）

Rust 的 **枚举（ `enum` ）** 是 Rust 中非常强大、灵活的核心特性，和很多其他语言的枚举完全不同，它不仅能定义 **一组固定取值** ，还能给每个枚举成员 **绑定不同类型的数据** ，是 Rust 实现 **类型安全、模式匹配** 的关键。

---

## 一、基础枚举（仅定义取值）

最简单的用法：定义一组有限的可选值。

### 示例

```rust
// 定义枚举
#[derive(Debug)] // 方便打印
enum Direction {
    Up,
    Down,
    Left,
    Right,
}

fn main() {
    // 创建枚举实例
    let go = Direction::Up;
    
    // 打印
    println!("方向：{:?}", go);
}
```

**特点** ：

- 成员用 `::` 访问
- 每个成员默认不带数据
- 适合表示 **状态、类型、方向** 等固定选项

---

## 二、带数据的枚举（Rust 核心特性）

**这是 Rust 枚举最强大的地方** ：每个枚举成员可以 **携带不同类型、不同数量的数据** 。

你可以把它理解成： **一个类型，多种形态** 。

### 示例

```rust
#[derive(Debug)]
enum Message {
    // 不带数据
    Quit,
    // 带一个整数
    Move(i32, i32),
    // 带字符串
    Write(String),
    // 带多个不同类型
    ChangeColor(u8, u8, u8),
}

fn main() {
    let msg1 = Message::Quit;
    let msg2 = Message::Move(10, 20);
    let msg3 = Message::Write(String::from("hello"));
    let msg4 = Message::ChangeColor(255, 0, 0);

    println!("{:?}", msg3);
}
```

**用途** ：

- 表示多种不同类型的消息 / 事件
- 替代复杂的结构体组合
- 安全表达 “多种可能类型”

---

## 三、枚举 + 方法（impl 块）

枚举可以像结构体一样 **实现方法** 。

```rust
#[derive(Debug)]
enum Message {
    Write(String),
}

// 为枚举实现方法
impl Message {
    fn call(&self) {
        println!("调用消息：{:?}", self);
    }
}

fn main() {
    let msg = Message::Write(String::from("hi"));
    msg.call(); // 调用方法
}
```

---

## 四、模式匹配 match（枚举必学）

枚举 **必须配合 `match` 使用** ，才能发挥最大威力。 `match` 会 **强制处理所有可能** ，保证代码安全。

### 示例

```rust
#[derive(Debug)]
enum Message {
    Quit,
    Move(i32, i32),
    Write(String),
}

fn print_message(msg: Message) {
    match msg {
        Message::Quit => println!("退出"),
        Message::Move(x, y) => println!("移动到 ({}, {})", x, y),
        Message::Write(s) => println!("写入：{}", s),
    }
}

fn main() {
    let msg = Message::Move(5, 8);
    print_message(msg);
}
```

**优点** ：

- 编译期检查： **漏写分支会直接报错**
- 代码清晰、无隐藏逻辑
- 类型安全

---

## 五、Rust 标准库常用枚举

Rust 内置两个超级常用枚举，你一定会用到：

### 1\. Option<T>：表示 “有值 / 空值”

Rust **没有 null** ，用 `Option` 安全表示空值。

```rust
enum Option<T> {
    Some(T),  // 有值
    None,     // 无值
}
```

使用：

```rust
fn main() {
    let x: Option<i32> = Some(5);
    let y: Option<i32> = None;

    match x {
        Some(v) => println!("值：{}", v),
        None => println!("无值"),
    }
}
```

### 2\. Result<T, E>：表示 “成功 / 错误”

用于 **错误处理** ，比异常更安全。

```rust
enum Result<T, E> {
    Ok(T),     // 成功
    Err(E),    // 失败
}
```

---

## 六、枚举内存布局（简单理解）

- 枚举大小 = **最大成员大小 + 标签大小**
- 编译器自动加 “标签” 区分当前是哪个成员
- 内存安全、紧凑高效

---

## 总结

1. **基础枚举** ：定义固定取值（方向、状态）
2. **带数据枚举** ：每个成员可携带不同类型数据（Rust 特色）
3. **impl 块** ：给枚举加方法
4. **match 匹配** ：强制处理所有情况，安全可靠
5. **标准库** ： `Option<T>` （空值）、 `Result<T, E>` （错误）是 Rust 编程基石

如果你愿意，我可以再给你：

- 枚举 vs 结构体 对比
- 实战项目中的枚举用法
- 复杂嵌套枚举示例
rust 基础语法

## Rust 基础语法速通

Rust 是一门 **安全、高性能、无 GC** 的系统编程语言，语法严谨但清晰易记。我整理了最核心的基础语法，直接上手就能用。

## 1\. 第一个 Rust 程序

```rust
// 主函数：程序入口
fn main() {
    // 打印输出（不带换行）
    print!("Hello, ");
    // 打印输出（带换行）
    println!("Rust!");
}
```

运行： `rustc 文件名.rs` 编译 → `./文件名` 执行

## 2\. 变量与常量

### 变量（默认不可变）

```rust
fn main() {
    // 不可变变量（默认）
    let a = 10;
    // 可变变量（必须加 mut）
    let mut b = 20;
    b = 30; // 合法

    // 变量遮蔽（重新定义同名变量）
    let a = a + 5;
    println!("{}", a); // 15
}
```

### 常量

```rust
// 必须指定类型，必须是编译期常量
const MAX: u32 = 100;
```

## 3\. 数据类型

### 标量类型（基础类型）

表格

| 类型 | 说明 |
| --- | --- |
| `i32` | 有符号整数（默认） |
| `u32` | 无符号整数 |
| `f64` | 浮点数（默认） |
| `bool` | 布尔值（true/false） |
| `char` | 字符（单引号，Unicode） |

```rust
let age: i32 = 18;
let pi: f64 = 3.14;
let is_ok: bool = true;
let c: char = '🦀';
```

### 复合类型

#### 元组（Tuple）：固定长度，不同类型

```rust
// 定义
let tup: (i32, f64, char) = (10, 3.14, 'a');
// 解构
let (x, y, z) = tup;
// 访问
println!("{}", tup.0); // 10
```

#### 数组（Array）：固定长度，相同类型

```rust
// 定义：[类型; 长度]
let arr: [i32; 3] = [1, 2, 3];
// 访问
println!("{}", arr[0]); // 1
```

## 4\. 函数

```rust
// 函数定义：fn 函数名(参数: 类型) -> 返回值类型
fn add(a: i32, b: i32) -> i32 {
    // 无分号 = 表达式返回值
    a + b
}

fn main() {
    let res = add(1, 2);
    println!("{}", res); // 3
}
```

## 5\. 流程控制

### 条件判断（if）

```rust
fn main() {
    let age = 18;
    if age >= 18 {
        println!("成年");
    } else {
        println!("未成年");
    }

    // if 可当表达式赋值
    let status = if age >= 18 { "adult" } else { "child" };
}
```

### 循环

1. **loop** （无限循环）

```rust
loop {
    println!("无限循环");
    break; // 退出循环
}
```

1. **while** 循环

```rust
let mut i = 0;
while i < 5 {
    println!("{}", i);
    i += 1;
}
```

1. **for** 循环（最常用）

```rust
// 遍历范围
for i in 1..5 {
    println!("{}", i); // 1 2 3 4
}

// 遍历数组
let arr = [1,2,3];
for num in arr {
    println!("{}", num);
}
```

## 6\. 模式匹配（match）

Rust 核心语法，替代 `switch` ， **必须穷尽所有情况**

```rust
fn main() {
    let num = 2;
    match num {
        1 => println!("一"),
        2 => println!("二"),
        3 => println!("三"),
        // 通配符：匹配其余所有情况
        other => println!("其他：{}", other),
    }
}
```

## 7\. 所有权（Rust 核心特性）

Rust 没有 GC，靠 **所有权规则** 管理内存：

1. 一个值同一时间 **只有一个所有者**
2. 所有者离开作用域，值自动释放

```rust
fn main() {
    let s1 = String::from("hello");
    // 所有权转移（移动）
    let s2 = s1;
    // 报错！s1 已失效
    // println!("{}", s1);
}
```

## 8\. 引用与借用

- 引用： `&` 不获取所有权，只读
- 可变引用： `&mut` 可修改，同一时间只能有一个

```rust
// 不可变引用
fn print_len(s: &String) {
    println!("{}", s.len());
}

// 可变引用
fn change(s: &mut String) {
    s.push_str(" world");
}

fn main() {
    let mut s = String::from("hello");
    change(&mut s);
    println!("{}", s); // hello world
}
```

## 9\. 结构体（Struct）

```rust
// 定义结构体
struct User {
    name: String,
    age: u32,
}

fn main() {
    // 创建实例
    let mut user = User {
        name: String::from("张三"),
        age: 18,
    };
    // 修改字段
    user.age = 19;
}
```

## 10\. 枚举（Enum）

```rust
enum Color {
    Red,
    Blue,
}

fn main() {
    let c = Color::Red;
    match c {
        Color::Red => println!("红色"),
        Color::Blue => println!("蓝色"),
    }
}
```

---

### 总结

1. **变量** ：默认不可变，可变加 `mut`
2. **类型** ：标量 + 复合，强类型无隐式转换
3. **函数** ：无分号表示返回值
4. **控制** ： `if` / `loop` / `while` / `for` + 强大 `match`
5. **核心** ：所有权、引用、借用（内存安全关键）

这些是 Rust 最基础的语法，掌握后就能写简单的 Rust 程序了！
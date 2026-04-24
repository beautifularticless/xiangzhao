rust结构体

## Rust 结构体（Struct）

结构体是 Rust 中 **自定义数据类型** 的核心，用于把多个相关的值组合在一起，是面向数据编程的基础。

## 一、结构体的三种类型

Rust 有 3 种常用结构体，满足不同场景：

### 1\. 经典结构体（命名字段）

最常用，给每个字段起名字。

```rust
// 定义结构体
struct User {
    username: String,
    age: u32,
    is_active: bool,
}

fn main() {
    // 创建实例
    let mut user1 = User {
        username: String::from("张三"),
        age: 20,
        is_active: true,
    };

    // 修改字段（必须整个实例是 mut）
    user1.age = 21;

    // 访问字段
    println!("姓名：{}，年龄：{}", user1.username, user1.age);
}
```

### 2\. 元组结构体（无字段名）

只有类型，没有字段名，像带名字的元组。

```rust
// 定义
struct Point(i32, i32, i32);
struct Color(u8, u8, u8);

fn main() {
    let p = Point(10, 20, 30);
    println!("x: {}, y: {}, z: {}", p.0, p.1, p.2); // 用 .索引 访问
}
```

### 3\. 单元结构体（无字段）

没有任何字段，通常用于 \*\* trait（特征）\*\* 相关场景。

```rust
struct Empty;

fn main() {
    let _empty = Empty;
}
```

---

## 二、结构体实例简化写法

### 1\. 变量与字段同名时简写

```rust
fn build_user(username: String, age: u32) -> User {
    User {
        username, // 等价于 username: username
        age,      // 等价于 age: age
        is_active: true,
    }
}
```

### 2\. 从其他实例更新

用 `..` 快速复用另一个实例的字段：

```rust
let user2 = User {
    username: String::from("李四"),
    ..user1 // 剩余字段全部用 user1 的值
};
```

---

## 三、结构体方法（关联函数）

Rust 用 `impl` 块给结构体定义 **方法** ，让结构体拥有行为。

### 1\. 实例方法（&self）

第一个参数必须是 `&self` （引用当前实例，不获取所有权）。

```rust
struct Rectangle {
    width: u32,
    height: u32,
}

// 实现方法
impl Rectangle {
    // 计算面积
    fn area(&self) -> u32 {
        self.width * self.height
    }

    // 判断能否容纳另一个矩形
    fn can_hold(&self, other: &Rectangle) -> bool {
        self.width > other.width && self.height > other.height
    }
}

fn main() {
    let rect = Rectangle { width: 10, height: 20 };
    println!("面积：{}", rect.area()); // 调用方法
}
```

### 2\. 关联函数（无 self）

相当于其他语言的 **静态方法** ，用 `::` 调用，常用于创建实例。

```rust
impl Rectangle {
    // 正方形
    fn square(size: u32) -> Self {
        Self {
            width: size,
            height: size,
        }
    }
}

// 调用
let square = Rectangle::square(5);
```

---

## 四、#\[derive\] 派生 trait

给结构体自动实现常用功能，不用手写代码：

```rust
// 自动实现：打印、比较、克隆
#[derive(Debug, PartialEq, Clone)]
struct Student {
    name: String,
    score: i32,
}

fn main() {
    let s = Student { name: "小明".into(), score: 90 };
    println!("{:?}", s); // Debug 支持打印
}
```

常用派生：

- `Debug` ：打印调试
- `Clone` ：克隆实例
- `Copy` ：栈上复制（仅简单类型）
- `PartialEq` ：比较相等

---

## 五、所有权说明

1. 结构体字段 **优先用 `String` 而不是 `&str`** ，因为结构体要 **拥有数据所有权** ，避免生命周期问题。
2. 如果必须用引用，需要加 **生命周期标注** （进阶知识）。

---

### 总结

1. **三种结构体** ：经典（命名字段）、元组（无名字）、单元（无字段）
2. **实例创建** ：直接赋值、同名简写、`..` 更新
3. **方法** ： `impl` 块定义， `&self` 是实例方法，`::` 调用关联函数
4. **派生宏** ： `#[derive(Debug)]` 快速实现打印等通用功能
5. **所有权** ：字段优先使用拥有所有权的类型（ `String` ）

如何在结构体中使用枚举类型？

结构体方法和普通函数有什么区别？

如何在 Rust 中实现结构体的迭代器？
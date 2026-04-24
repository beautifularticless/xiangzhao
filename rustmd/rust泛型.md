rust泛型

## Rust 泛型（Generatics）

泛型是 Rust 的核心特性之一， **作用是编写通用、可复用的代码，同时不损失类型安全和性能** 。简单说： **一套代码，支持多种类型** ，避免重复编写逻辑相同、仅类型不同的代码。

## 一、核心概念

- 泛型用 **类型参数** 表示（通常用大写字母，如 `T` 、 `U` 、 `V` ）
- Rust 泛型是 **零成本抽象** ：编译时会生成对应类型的具体代码，运行时无性能损耗
- 支持在 **函数、结构体、枚举、方法、 trait** 中使用

---

## 二、基础用法

### 1\. 泛型函数

编写一个可以接收 **任意类型参数** 的函数：

```rust
// T 是泛型类型参数，表示任意类型
fn print_value<T>(value: T) {
    println!("值: {:?}", value);
}

fn main() {
    // 自动推导类型
    print_value(123);
    print_value("Hello Rust");
    print_value(true);
}
```

- `<T>` ：声明泛型类型参数
- 函数参数 / 返回值都可以使用 `T`

### 2\. 带约束的泛型函数

如果需要对类型做操作（如打印、比较），必须给泛型加 **trait 约束** ：

```rust
// 约束 T 必须实现 Debug trait（支持打印）
fn print_value<T: std::fmt::Debug>(value: T) {
    println!("调试打印: {:?}", value);
}
```

---

### 3\. 泛型结构体

定义可以存储任意类型数据的结构体：

```rust
// 泛型结构体：存储一个 T 类型的值
struct Container<T> {
    value: T,
}

fn main() {
    // 存储整数
    let int_container = Container { value: 100 };
    // 存储字符串
    let str_container = Container { value: "泛型" };
}
```

**多个泛型参数** ：

```rust
// 两个泛型类型 T 和 U
struct Pair<T, U> {
    first: T,
    second: U,
}
```

---

### 4\. 泛型枚举

Rust 标准库的 `Option` 、 `Result` 都是泛型枚举：

```rust
// 自定义泛型枚举
enum Result<T, E> {
    Ok(T),  // 成功时返回 T 类型
    Err(E), // 失败时返回 E 类型
}
```

---

### 5\. 泛型方法

为泛型结构体实现方法：

```rust
struct Container<T> {
    value: T,
}

// 为 Container<T> 实现方法
impl<T> Container<T> {
    // 获取内部值
    fn get_value(&self) -> &T {
        &self.value
    }
}
```

**只给特定类型实现方法** （Rust 特色）：

```rust
// 仅当 T 是 i32 时，才拥有这个方法
impl Container<i32> {
    fn add(&self, num: i32) -> i32 {
        self.value + num
    }
}
```

---

## 三、常用语法糖：where 约束

当泛型约束很多时，用 `where` 更清晰：

```rust
// 复杂约束：推荐用 where
fn demo<T, U>(a: T, b: U) 
where
    T: std::fmt::Debug + Clone,
    U: std::fmt::Display,
{
    // ...
}
```

---

## 四、泛型的特性

1. **编译期单态化** 编译时，Rust 会把泛型代码生成 **具体类型的专用代码** ，例如：
	- `Container<i32>`
		- `Container<String>` 运行时和直接写具体类型 **性能完全一致** 。
2. **强类型安全** 泛型不会丢失类型检查，错误在编译期就会被发现。
3. **无运行时开销** 这是 Rust 泛型最大的优势，比 Java 泛型、Go 泛型性能更好。

---

## 五、完整示例

```rust
// 泛型结构体
#[derive(Debug)]
struct Point<T> {
    x: T,
    y: T,
}

// 泛型方法
impl<T> Point<T> {
    fn new(x: T, y: T) -> Self {
        Point { x, y }
    }
}

// 仅为数字类型实现距离计算
impl Point<f64> {
    fn distance(&self) -> f64 {
        (self.x.powi(2) + self.y.powi(2)).sqrt()
    }
}

fn main() {
    // 整数点
    let p1 = Point::new(1, 2);
    // 浮点数点
    let p2 = Point::new(3.0, 4.0);

    println!("{:?}", p1);
    println!("距离: {}", p2.distance()); // 输出 5.0
}
```

---

### 总结

1. **泛型 = 通用代码 + 类型安全 + 零性能损耗**
2. 可用于： **函数、结构体、枚举、方法、trait**
3. 语法： `<T>` 声明泛型， `T: Trait` 加约束
4. 编译期单态化，运行时无开销
5. 复杂约束用 `where` 更易读

需要我给你整理 **泛型 + trait 结合** 的实战用法（Rust 最常用组合）吗？

泛型在 Rust 中的优势是什么？

如何在 Rust 中使用泛型结构体？

泛型在 Rust 中的应用场景有哪些？
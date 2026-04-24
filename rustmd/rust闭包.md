rust闭包

下面我一次性把 Rust 闭包讲全： **定义、语法、捕获规则、三种 trait、move 闭包、常见坑、示例** ，内容偏细，适合直接上手写代码。

---

## 一、什么是闭包

**闭包 = 匿名函数 + 能捕获外部环境变量**

- 普通函数： `fn` ，必须命名，不能抓外部变量
- 闭包：匿名，可抓外部变量，可存变量、传参、返回

```rust
fn main() {
    let x = 10;

    // 闭包：捕获 x
    let add = |y| x + y;

    println!("{}", add(5)); // 15
}
```

---

## 二、基本语法

完整格式：

```rust
|参数列表| -> 返回类型 { 体 }
```

可省略的地方很多（类型推断）：

### 1）最简（无参数、单表达式）

```rust
let f = || 42;
println!("{}", f()); // 42
```

### 2）带参数，省略类型

```rust
let add = |a, b| a + b;
println!("{}", add(2, 3)); // 5
```

### 3）显式类型

```rust
let add = |a: i32, b: i32| -> i32 { a + b };
```

### 4）多行用大括号

```rust
let calc = |x| {
    let mut res = x * 2;
    res += 1;
    res
};
println!("{}", calc(3)); // 7
```

---

## 三、闭包如何捕获外部变量（核心）

Rust 闭包默认按 **最宽松、够用就行** 的原则捕获：

### 1）不可变借用（&T）—— 最常见

只读外部变量：

```rust
let s = String::from("hello");
let print_s = || println!("{}", s); // 不可变借用
print_s();
println!("{}", s); // 还能用
```

### 2）可变借用（&mut T）

要修改外部变量：

```rust
let mut s = String::from("hello");
let append = || s.push_str(" world"); // 可变借用
append();
println!("{}", s); // hello world
```

### 3）获取所有权（move）

**强制把外部变量 move 进闭包** ，用 `move` 关键字：

```rust
let s = String::from("hello");
let take = move || println!("{}", s); // s 被 move 进闭包
take();
// println!("{}", s); // 编译错误，s 已被移走
```

典型场景： **线程、返回闭包、生命周期不够长时** 。

---

## 四、闭包的三种 Trait（面试常问）

闭包本质是 **实现了 Fn / FnMut / FnOnce 之一的结构体** ：

### 1）Fn：不可变借用，可多次调用

```rust
// 捕获 &T，不修改
let f: impl Fn(i32) -> i32 = |x| x + 1;
f(1); f(2); // 随便调
```

### 2）FnMut：可变借用，可多次调用

```rust
let mut n = 0;
let mut f: impl FnMut() -> i32 = || { n += 1; n };
f(); f(); // 可多次调用，会改外部
```

### 3）FnOnce：获取所有权，只能调用一次

```rust
let s = String::from("hi");
let f: impl FnOnce() = move || { drop(s); };
f();
// f(); // 编译错误：已经被消耗
```

**规则** ：

- 只读 → `Fn`
- 要改 → `FnMut`
- move 且消耗 → `FnOnce`

---

## 五、作为参数与返回值

### 1）作为参数

```rust
fn apply<F>(f: F) where F: Fn(i32) -> i32 {
    println!("{}", f(5));
}

fn main() {
    apply(|x| x * 2); // 10
}
```

### 2）返回闭包（必须 move + 用 impl Trait）

```rust
fn make_adder(x: i32) -> impl Fn(i32) -> i32 {
    move |y| x + y
}

fn main() {
    let add5 = make_adder(5);
    println!("{}", add5(3)); // 8
}
```

---

## 六、迭代器里最常用

```rust
let nums = vec![1,2,3,4];

// filter + map
let res: Vec<i32> = nums
    .into_iter()
    .filter(|&x| x % 2 == 0)
    .map(|x| x * 10)
    .collect();

println!("{:?}", res); // [20, 40]
```

---

## 七、常见坑

1. **类型一旦锁定不能变**
	```rust
	let f = |x| x;
	f(1);
	// f("hi"); // 报错：已经推断为 i32
	```
2. **借用冲突**
	```rust
	let mut s = String::new();
	let a = || s.push('a');
	let b = || s.push('b'); // 报错：不能两个可变借用
	```
3. **返回闭包忘记 move**
	```rust
	// 错误：生命周期不够
	// fn make() -> impl Fn() { || println!("hi") }
	// 正确：move
	fn make() -> impl Fn() { move || println!("hi") }
	```

---

## 八、小结一句话

**Rust 闭包 = 匿名函数 + 自动捕获外部变量（不可变 / 可变 /move）+ 三种 Fn trait 决定调用权限与次数 + 零成本抽象** 。

---

要不要我给你一套 **可直接运行的闭包练习代码（含 Fn/FnMut/FnOnce、move、迭代器例子）** ，你直接复制到 main.rs 就能跑？

如何在闭包中修改捕获的变量？

介绍一下Rust闭包的生命周期

Rust闭包和其他编程语言的闭包有什么区别？
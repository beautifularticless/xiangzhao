rust所有权详解

Rust 所有权（Ownership）是一套 **编译期内存安全规则** ，核心是 “ **唯一所有者、离开作用域自动释放、默认移动语义** ”，在 **无 GC、无运行时开销** 的前提下杜绝空指针、悬垂引用、双重释放与数据竞争Rust。

---

### 一、所有权三大铁律（必须背熟）

1. **每个值有且仅有一个所有者** （owner）Rust。
2. **同一时刻只能有一个所有者** Rust。
3. **所有者离开作用域（scope），值自动被 drop 释放** Rust。

### 二、内存布局：栈 vs 堆

- **栈（Stack）** ：固定大小、快速、自动分配 / 释放；如 `i32` 、 `bool` 、 `f64` 、数组（固定长）、元组（全为栈类型）。
- **堆（Heap）** ：动态大小、慢、手动管理；如 `String` 、 `Vec<T>` 、 `Box<T>` 、自定义结构体（含堆数据）。
- **String 结构（栈 + 堆）**

```
栈上：s { ptr: *u8, len: usize, capacity: usize }
堆上：ptr → [h,e,l,l,o,\0]
```

![image](https://p26-flow-imagex-sign.byteimg.com/isp-i18n-media/image/56bf466e8ceec20dc12a55321838e067~tplv-a9rns2rl98-pc_smart_face_crop-v1:512:384.image?lk3s=8e244e95&rcl=20260424222721A3A56D4BED2CD617EC1E&rrcfp=cee388b0&x-expires=2092400851&x-signature=HP6HdR29jYAuSp55srQJKwKmT%2BQ%3D)

### 三、所有权转移（Move）—— 默认行为

#### 1\. 赋值转移（非 Copy 类型）

```rust
let s1 = String::from("hello");
let s2 = s1; // 所有权从s1 → s2，s1失效
// println!("{}", s1); // ❌ 编译错误：s1已被move
println!("{}", s2); // ✅ 正常
```

#### 2\. 函数传参转移

```rust
fn take(s: String) { /* s获得所有权，离开函数drop */ }
fn main() {
    let s = String::from("hi");
    take(s); // 所有权转移
    // println!("{}", s); // ❌ 错误
}
```

#### 3\. 返回值转移

```rust
fn give() -> String { String::from("hello") }
fn main() {
    let s = give(); // s获得所有权
}
```

### 四、Copy 与 Clone—— 避免转移

#### 1\. Copy trait（栈类型默认实现）

- **Copy 类型** ：赋值时 **位拷贝** ，原变量仍有效；如 `i32` 、 `bool` 、 `f64` 、 `char` 、 `[T; N]` （T: Copy）、 `(T1,T2)` （全 Copy）。

```rust
let a = 10;
let b = a; // Copy，不是move
println!("{}", a); // ✅ 正常
```

#### 2\. Clone trait（堆类型深拷贝）

- **Clone** ：手动深拷贝，生成独立堆数据；如 `String::clone()` 、 `Vec::clone()` 。

```rust
let s1 = String::from("hello");
let s2 = s1.clone(); // 深拷贝，s1仍有效
println!("{}", s1); // ✅ 正常
println!("{}", s2); // ✅ 正常
```

### 五、借用（Borrowing）—— 共享不转移

#### 1\. 不可变借用（&T）：只读、可多借

```rust
let s = String::from("hello");
let r1 = &s; // 不可变借用
let r2 = &s; // 允许多个不可变借用
println!("{} {} {}", s, r1, r2); // ✅ 正常
```

#### 2\. 可变借用（&mut T）：独写、只能一个

```rust
let mut s = String::from("hello");
let r1 = &mut s; // 可变借用
// let r2 = &mut s; // ❌ 错误：同一时间只能一个可变借用
r1.push_str(" world");
println!("{}", r1); // ✅ hello world
```

#### 3\. 借用规则（编译期检查）

- **同一时间** ： **多个不可变借用** 或 **一个可变借用** ，不能同时存在。
- **借用生命周期** ：引用不能比所有者活得久（杜绝悬垂引用）。

### 六、作用域与 Drop—— 自动内存管理

- **作用域** ：变量从声明到离开 `{}` 的有效范围。
- **Drop trait** ：所有者离开作用域时，Rust 自动调用 `drop` 释放堆内存（RAII）Rust。

```rust
{
    let s = String::from("hello"); // s有效
    println!("{}", s);
} // s离开作用域，自动drop，堆内存释放
// println!("{}", s); // ❌ 错误：s已失效
```

### 七、所有权与函数 —— 传参 / 返回值

#### 1\. 传参：转移 vs 借用

```rust
// 转移所有权
fn take(s: String) {}
// 借用（不可变）
fn borrow(s: &String) {}
// 借用（可变）
fn borrow_mut(s: &mut String) {}
```

#### 2\. 返回值：转移 vs 借用

```rust
// 转移所有权
fn give() -> String { String::from("hello") }
// 返回借用（需生命周期，后面讲）
fn borrow() -> &'static str { "hello" }
```

### 八、常见错误与解决

#### 1\. 移动后使用（Move 后借用）

```rust
let s1 = String::from("hello");
let s2 = s1;
println!("{}", s1); // ❌ 错误：s1已move
// 解决：用clone()或借用
```

#### 2\. 悬垂引用（Dangling Reference）

```rust
fn dangling() -> &String {
    let s = String::from("hello");
    &s // ❌ 错误：s离开函数被drop，引用悬垂
}
// 解决：返回所有权（String）或用'static
```

#### 3\. 同时可变与不可变借用

```rust
let mut s = String::from("hello");
let r1 = &s;
let r2 = &mut s; // ❌ 错误：不可变与可变借用共存
// 解决：缩小作用域，让不可变借用先结束
```

### 九、所有权、借用、生命周期 —— 三位一体

- **所有权** ：管 “谁拥有数据、何时释放”。
- **借用** ：管 “如何安全共享数据”（&/&mut）。
- **生命周期** ：管 “引用有效期”，确保引用不悬垂（ `'a` ）。

### 十、总结

- **所有权** ：Rust 内存安全的基石， **唯一所有者、自动释放、默认移动** 。
- **Move** ：堆数据默认转移所有权，原变量失效。
- **Copy/Clone** ：栈类型自动 Copy，堆类型用 Clone 深拷贝。
- **借用** ：&T（多只读）、&mut T（独写），编译期检查规则。
- **作用域 + Drop** ：自动管理内存，无 GC、无泄漏、无悬垂。

要不要我把以上内容浓缩成一份可直接运行的 **所有权示例代码包** ，包含所有核心场景与常见错误对比？

如何在Rust中转移所有权？

解释一下Rust中的克隆（clone）语义

详细说明Rust中所有权的概念和作用
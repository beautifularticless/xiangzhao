rust指针

Rust 的指针分为三类： **引用（&T/&mut T）、裸指针（\*const T/\*mut T）、智能指针（Box/Rc/Arc 等）** ，核心差异在安全、所有权与生命周期约束。

### 一、引用（安全指针）

- **&T（不可变引用）** ：可读、不可改，可多个共存， **Copy** ，安全Rust。
- **&mut T（可变引用）** ：可读写， **同一时间只能一个** ，非 **Copy** ，安全Rust。
- 借用规则（编译期检查）：
	1. 同一作用域， **多个 &T 或 一个 &mut T** ，不可同时存在。
		2. 引用 **不能超过** 被引用值的生命周期。

```rust
fn main() {
    let mut x = 10;
    let a = &x;       // 不可变引用
    let b = &x;       // 允许多个
    // let c = &mut x; // 报错：不能同时有 &T 和 &mut T
    println!("{} {}", a, b);

    let mut y = 20;
    let m = &mut y;   // 可变引用
    *m += 5;
    println!("{}", m);
}
```

### 二、裸指针（Raw Pointer，不安全）

- \* **const T** ：不可变裸指针， **只读** 。
- \* **mut T** ：可变裸指针， **读写** 。
- 特点：
	- 无所有权、无借用检查、 **无生命周期** 。
		- 可空、可越界、可未对齐， **解引用必须在 unsafe 块** Rust。
		- 用于：FFI、底层操作、性能极致优化。

```rust
fn main() {
    let val = 42;
    let p1: *const i32 = &val; // 不可变裸指针
    let mut mut_val = 99;
    let p2: *mut i32 = &mut mut_val; // 可变裸指针

    unsafe {
        println!("{}", *p1); // 解引用需 unsafe
        *p2 = 100;
        println!("{}", *p2);
    }
}
```

### 三、智能指针（Smart Pointer）

**带所有权、自动内存管理、安全封装** ，本质是结构体 + 指针 + 逻辑。

#### 1\. Box<T>：堆分配、单一所有权

- 把数据放在 **堆** ，栈上存指针， **独占所有权** 。
- 用途：堆分配、递归类型、大对象转移。

```rust
let b = Box::new(5); // 堆上存5，栈存指针
println!("{}", b);    // 自动解引用
```

#### 2\. Rc<T>：单线程共享所有权

- **引用计数** ，多个所有者， **单线程** 使用。
- 不可变；内部可变性需配合 `RefCell<T>` 。

```rust
use std::rc::Rc;
let a = Rc::new(10);
let b = Rc::clone(&a); // 计数+1
println!("count: {}", Rc::strong_count(&a)); // 2
```

#### 3\. Arc<T>：多线程共享所有权

- 线程安全的 `Rc` ， **原子引用计数** ，跨线程共享。

```rust
use std::sync::Arc;
use std::thread;
let a = Arc::new(20);
let b = Arc::clone(&a);
thread::spawn(move || println!("{}", b));
```

#### 4\. RefCell<T>：内部可变性

- 运行期借用检查， **打破 “不可变引用不能改”** ，配合 `Rc` 实现共享可变。

```rust
use std::rc::Rc;
use std::cell::RefCell;
let data = Rc::new(RefCell::new(vec![1,2,3]));
data.borrow_mut().push(4); // 可变借用
println!("{:?}", data.borrow());
```

### 四、三类指针对比

表格

| 类型 | 安全 | 所有权 | 借用规则 | 生命周期 | 常用场景 |
| --- | --- | --- | --- | --- | --- |
| &T/&mut T | ✅ | 借用 | 编译期 | 有 | 常规读写 |
| \*const/\*mut | ❌ | 无 | 无 | 无 | FFI、底层 |
| Box<T> | ✅ | 独占 | 有 | 有 | 堆分配 |
| Rc<T> | ✅ | 共享 | 运行期 | 有 | 单线程共享 |
| Arc<T> | ✅ | 共享 | 运行期 | 有 | 多线程共享 |

### 五、关键总结

1. **优先用引用** ：安全、无开销、编译器保障。
2. **裸指针尽量不用** ：仅 FFI / 底层，必须 `unsafe` 。
3. **智能指针按需选** ：

要不要我把以上内容浓缩成一份可直接复制的速查清单，方便你快速查阅和使用？

如何使用Rust的智能指针？

裸指针和智能指针的区别是什么？

分享一些Rust指针使用的代码示例
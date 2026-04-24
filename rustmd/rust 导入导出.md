rust 导入导出

## Rust 导入与导出（模块系统）

Rust 没有传统语言的 `import/export` 关键字， **模块可见性（ `pub` ）** 控制导出， **`use` 关键字** 控制导入，核心是 **模块系统** 管理代码组织。

下面用最清晰、最实用的方式讲清楚 **导出** 和 **导入** 。

---

## 一、导出：让代码能被外部访问

默认情况下，Rust 所有项（函数、结构体、枚举、常量、模块）都是 **私有的** ，只能在当前模块内使用。

想 **导出** （公开），必须加 `pub` 关键字。

### 1\. 导出函数

```rust
// 私有函数：外部无法访问
fn private_fn() {}

// 公共函数：导出，外部可导入使用
pub fn public_fn() {
    println!("我是导出的公共函数");
}
```

### 2\. 导出结构体 + 字段

结构体本身需要 `pub` ， **字段默认私有** ，想导出字段也要加 `pub` ：

```rust
// 导出结构体
pub struct Person {
    // 导出字段
    pub name: String,
    // 私有字段：外部无法访问
    age: u8,
}

// 导出结构体方法
impl Person {
    pub fn new(name: String) -> Self {
        Person { name, age: 18 }
    }
}
```

### 3\. 导出模块

模块也可以导出，让外部能访问子模块：

```rust
// 导出整个模块
pub mod utils {
    // 导出模块内的函数
    pub fn hello() {
        println!("Hello from utils");
    }
}
```

---

## 二、导入：使用外部代码

用 `use` 关键字 **导入** 已导出的项，简化代码书写。

### 1\. 导入标准库

```rust
// 导入标准库的 HashMap
use std::collections::HashMap;

fn main() {
    let mut map = HashMap::new();
    map.insert("key", "value");
}
```

### 2\. 导入当前项目的模块 / 函数

假设项目结构：

```
src/
├── main.rs
└── utils.rs
```

`utils.rs` （导出）：

```rust
// 导出函数
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}
```

`main.rs` （导入）：

```rust
// 导入 utils 模块（必须先声明模块）
mod utils;

// 导入 utils 里的 add 函数
use utils::add;

fn main() {
    println!("{}", add(1, 2)); // 直接使用
}
```

### 3\. 批量导入（{}）

```rust
// 同时导入多个项
use std::collections::{HashMap, HashSet};

// 导入模块下所有公共项（不推荐大型项目使用）
use utils::*;
```

### 4\. 重命名导入（as）

```rust
// 重命名避免冲突
use std::io::Result as IoResult;
use std::fmt::Result as FmtResult;
```

---

## 三、常用路径规则（绝对路径 / 相对路径）

### 1\. 绝对路径（从 crate 根开始）

以 `crate::` 开头，最稳定、推荐：

```rust
use crate::utils::add;
```

### 2\. 相对路径（从当前模块开始）

使用 `self` （当前）、 `super` （父模块）：

```rust
mod a {
    pub fn fn_a() {}

    mod b {
        // 导入父模块 a 的 fn_a
        use super::fn_a;
        // 导入当前模块自身的项
        use self::fn_b;

        pub fn fn_b() {}
    }
}
```

---

## 四、完整实战示例

### 项目结构

```
src/
├── main.rs
└── math/
    ├── mod.rs
    └── calc.rs
```

### 1\. calc.rs（导出）

```rust
// 导出加法函数
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}

// 导出减法函数
pub fn sub(a: i32, b: i32) -> i32 {
    a - b
}
```

### 2\. mod.rs（导出子模块）

```rust
// 导出 calc 子模块
pub mod calc;
```

### 3\. main.rs（导入使用）

```rust
// 声明 math 模块
mod math;

// 导入 calc 下的所有公共函数
use math::calc::*;

fn main() {
    println!("1+2={}", add(1, 2));
    println!("5-3={}", sub(5, 3));
}
```

运行输出：

```
1+2=3
5-3=2
```

---

## 五、核心规则总结

1. **导出** ：必须加 `pub` ，否则私有无法访问
	- `pub fn` / `pub struct` / `pub mod`
		- 结构体字段单独控制可见性
2. **导入** ：使用 `use` + 路径
3. 文件模块：必须先用 `mod 文件名;` 声明，再 `use`
4. 文件夹模块：必须包含 `mod.rs` 导出子模块

---

### 总结

1. **导出 = `pub`** ：给函数、结构体、模块加 `pub` 就是对外暴露
2. **导入 = `use`** ：通过路径引入已公开的代码
3. 路径分 **绝对路径（ `crate::`） **和** 相对路径（ `super/self` ）**
4. 文件 / 文件夹模块需要先声明 `mod` ，再导入使用

需要我帮你整理 Rust 模块系统的 **最佳实践清单** 吗？可以避免 90% 的导入导出错误。

如何在 Rust 中使用相对路径导入模块？

在 Rust 中，模块的可见性规则是如何工作的？

除了\`pub\`关键字，还有其他方式控制 Rust 代码的可见性吗？
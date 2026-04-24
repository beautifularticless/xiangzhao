rust 宏

Rust 宏（Macro）是一种 **编译期元编程** 工具，核心作用是 **生成或修改代码** ，以消除重复、扩展语法、实现高阶抽象。Rust 宏分为两大类： **声明式宏 (macro\_rules!)** 和 **过程宏 (Procedural Macros)** ，功能从简单到复杂。

### 一、宏 vs 函数：核心区别

- **时机** ：宏在 **编译期** 展开（代码替换）；函数在 **运行期** 执行。
- **参数** ：宏接收 **Token 树** （代码片段），可接受任意语法；函数接收 **具体值 / 引用** 。
- **能力** ：宏可 **生成代码、定义项、修改语法** ；函数仅能计算、返回值。
- **开销** ：宏无运行时开销；函数有调用开销。

---

### 二、声明式宏 (macro\_rules!)

**最常用、最简单** 的宏。通过 `macro_rules!` 定义，核心是 **模式匹配 + 代码模板替换** 。

#### 1\. 基础语法

```rust
// 定义：名字 + 多分支模式匹配
macro_rules! 宏名 {
    // 分支1：(模式) => { 代码模板 };
    (模式1) => { 生成的代码1 };
    // 分支2：(模式2) => { 代码模板 };
    (模式2) => { 生成的代码2 };
}

// 调用：名字!(参数)
宏名!(输入);
```

#### 2\. 核心：元变量与重复

- **元变量 (Fragment Specifiers)** ：捕获不同语法片段
  - `$x:expr` ：表达式
    - `$i:ident` ：标识符（变量 / 函数名）
    - `$t:ty` ：类型
    - `$s:stmt` ：语句
    - `$p:path` ：路径（如 `std::collections` ）
- **重复 `$(...),+`** ：匹配 **一个或多个** 重复项
  - `$(...),*` ：0 个或多个
    - `$(...),+` ：1 个或多个
    - `$(...);*` ：分号分隔

#### 3\. 示例：实现 vec! 宏

```rust
macro_rules! my_vec {
    // 空向量
    () => {
        Vec::new()
    };
    // 多个元素：my_vec!(1, 2, 3)
    // $( $x:expr ),+ 匹配多个表达式
    ( $( $x:expr ),+ $(,)? ) => {
        {
            let mut temp_vec = Vec::new();
            // 循环生成 push 代码
            $(
                temp_vec.push($x);
            )+
            temp_vec
        }
    };
}

fn main() {
    let v = my_vec!(1, 2, 3);
    println!("{:?}", v); // [1, 2, 3]
}
```

#### 4\. 卫生性 (Hygiene)

Rust 宏是 **卫生的** ：宏内部变量不会污染外部作用域，编译器自动重命名，避免命名冲突。

---

### 三、过程宏 (Procedural Macros)

**更强大、更灵活** ，本质是 **编译期运行的 Rust 函数** ：接收代码（TokenStream）→ 分析 / 修改 → 输出新代码。

必须在 **独立的 proc-macro crate** 中开发，依赖 `syn` （解析代码）、 `quote` （生成代码）。

#### 1\. 三类过程宏

表格

| 类型                      | 语法                   | 用途                  | 示例                 |
| ----------------------- | -------------------- | ------------------- | ------------------ |
| **派生宏 (Derive)**        | `#[derive(MyTrait)]` | 为结构体 / 枚举自动实现 Trait | `#[derive(Debug)]` |
| **属性宏 (Attribute)**     | `#[my_attr(...)]`    | 给任意项（函数 / 结构体）加注解   | `#[route("/api")]` |
| **函数宏 (Function-like)** | `my_macro!(...)`     | 类函数调用，生成复杂代码        | `sql!("SELECT *")` |

#### 2\. 示例：派生宏 (Builder 模式)

**目标** ：为结构体自动生成 `builder()` 链式调用。

**步骤** ：

1. 新建库 `cargo new --lib my_builder`

2. `Cargo.toml`
   
   ```toml
   [lib]
   proc-macro = true # 声明为过程宏
   [dependencies]
   syn = { version = "2.0", features = ["full"] }
   quote = "1.0"
   proc-macro2 = "1.0"
   ```

3. `src/lib.rs`
   
   ```rust
   use proc_macro::TokenStream;
   use quote::quote;
   use syn::{parse_macro_input, DeriveInput, Fields};
   // 定义派生宏 Builder
   #[proc_macro_derive(Builder)]
   pub fn derive_builder(input: TokenStream) -> TokenStream {
       // 1. 解析输入代码为语法树
       let ast = parse_macro_input!(input as DeriveInput);
       let name = ast.ident; // 结构体名
       let builder_name = format!("{}Builder", name);
       let builder_ident = syn::Ident::new(&builder_name, name.span());
       // 2. 提取字段（仅支持普通结构体）
       let fields = match ast.data {
           syn::Data::Struct(s) => s.fields,
           _ => panic!("Builder 仅支持结构体"),
       };
       // 3. 生成 Builder 代码
       let expanded = quote! {
           // 生成 Builder 结构体
           pub struct #builder_ident {
               // 复制原结构体字段
               #fields
           }
           // 为原结构体实现 builder()
           impl #name {
               pub fn builder() -> #builder_ident {
                   #builder_ident {
                       // 初始化字段（简化示例）
                       // ...
                   }
               }
           }
           // 为 Builder 生成链式 setter
           impl #builder_ident {
               // 自动生成每个字段的方法
               // ...
               pub fn build(self) -> #name {
                   #name {
                       // 从 Builder 赋值
                       // ...
                   }
               }
           }
       };
       // 4. 返回生成的代码
       TokenStream::from(expanded)
   }
   ```

4. **使用**
   
   ```rust
   use my_builder::Builder;
   #[derive(Builder)]
   struct User {
       name: String,
       age: u32,
   }
   fn main() {
       // 自动生成链式调用
       let user = User::builder()
           .name("Alice")
           .age(25)
           .build();
   }
   ```

---

### 四、常用内置宏

- `println!("{}", x)` ：打印
- `vec![1,2,3]` ：创建向量
- `cfg!(windows)` ：条件编译
- `assert_eq!(a, b)` ：断言
- `concat!("a", "b")` ：字符串拼接
- `stringify!(x)` ：将表达式转为字符串

---

### 五、调试宏

- **`cargo expand`** ：查看宏展开后的完整代码（安装 `cargo install cargo-expand` ）
  
  ```bash
  cargo expand
  ```

### 总结

- **声明式宏 (`macro_rules!`)** ：简单、模式匹配、适合代码模板。
- **过程宏** ：强大、可编程、适合复杂代码生成（派生 / 属性 / 函数宏）。
- **核心价值** ： **零成本抽象** ，消除重复，编译期安全，极大提升 Rust 表达力。

需要我帮你写一个可直接运行的 **声明式宏完整示例** （如 `hashmap!` 或 `log!`）吗？
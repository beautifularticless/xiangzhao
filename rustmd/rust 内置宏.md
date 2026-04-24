rust 内置宏

Rust 内置宏（Built-in Macros）是编译器直接支持、无需引入任何 crate 即可使用的宏，覆盖 **打印格式化、断言调试、编译期信息、文件 / 环境读取、容器创建** 等高频场景。下面按类别整理核心内置宏、用途与示例。

---

### 一、打印与格式化宏

- **print!**：标准输出（无换行）
	```rust
	print!("Hello ");
	```
- **println!**：标准输出（带换行）
	```rust
	println!("Hello, {}!", "Rust");
	```
- **eprint!**：标准错误输出（无换行）
	```rust
	eprint!("Error: ");
	```
- **eprintln!**：标准错误输出（带换行）
	```rust
	eprintln!("Something wrong!");
	```
- **format!**：生成格式化字符串（不打印）
	```rust
	let s = format!("Age: {}", 18);
	```
- **format\_args!**：构造格式化参数（底层用）
	```rust
	let args = format_args!("{} {}", 1, 2);
	```

---

### 二、断言与调试宏

- **assert!(expr, msg?)** ：运行时断言，expr 为 false 则 panic
	```rust
	assert!(2 + 2 == 4, "Math error");
	```
- **assert\_eq!(a, b, msg?)** ：断言 a == b，不等则 panic 并显示差异
	```rust
	assert_eq!(1 + 1, 2);
	```
- **assert\_ne!(a, b, msg?)** ：断言 a!= b，相等则 panic
	```rust
	assert_ne!(5, 3);
	```
- **debug\_assert! / debug\_assert\_eq! / debug\_assert\_ne!**：仅在 debug 模式生效
	```rust
	debug_assert!(x > 0);
	```
- **dbg!(expr)** ：调试打印（位置 + 值），返回原值
	```rust
	let x = dbg!(1 + 2); // 输出 [src/main.rs:4] 1 + 2 = 3，x=3
	```
- **panic!(msg)** ：主动触发程序崩溃
	```rust
	panic!("Fatal error");
	```
- **todo!(msg?)** ：标记未实现（运行时 panic）
	```rust
	todo!("Implement later");
	```
- **unimplemented!(msg?)** ：同上，语义更偏向 “未实现”
	```rust
	unimplemented!();
	```

---

### 三、编译期信息宏

- **file!()** ：当前文件名（&'static str）
	```rust
	println!("File: {}", file!());
	```
- **line!()** ：当前行号（u32）
	```rust
	println!("Line: {}", line!());
	```
- **column!()** ：当前列号（u32）
	```rust
	println!("Column: {}", column!());
	```
- **module\_path!()** ：当前模块路径（&'static str）
	```rust
	println!("Module: {}", module_path!());
	```
- **stringify!(expr)** ：表达式转字符串字面量
	```rust
	let s = stringify!(1 + 2); // "1 + 2"
	```
- **concat!(...)** ：连接字符串字面量（编译期）
	```rust
	let s = concat!("Hello", ", ", "World");
	```
- **concat\_bytes!(...)** ：连接字节字面量（实验性）

---

### 四、编译控制与条件宏

- **cfg!(cond)** ：编译时判断配置，返回 bool
	```rust
	if cfg!(target_os = "linux") {
	    println!("Linux");
	}
	```
- **compile\_error!(msg)** ：编译时报错并终止
	```rust
	compile_error!("This feature is disabled");
	```

---

### 五、环境与文件读取宏

- **env!("VAR")** ：编译期读环境变量，不存在则编译失败
	```rust
	let ver = env!("CARGO_PKG_VERSION");
	```
- **option\_env!("VAR")** ：编译期读环境变量，返回 Option<&'static str>
	```rust
	let path = option_env!("PATH");
	```
- **include\_str!("path")** ：编译期读文件为 &'static str
	```rust
	let text = include_str!("config.txt");
	```
- **include\_bytes!("path")** ：编译期读文件为 &'static \[u8\]
	```rust
	let data = include_bytes!("data.bin");
	```

---

### 六、容器初始化宏

- **vec!\[...\]** ：快速创建 Vec<T>
	```rust
	let v1 = vec![1, 2, 3];
	let v2 = vec![0; 5]; // [0,0,0,0,0]
	```

---

### 七、其他实验性 / 底层宏

- **concat\_idents!(...)** ：连接标识符（实验性）
- **log\_syntax!(...)** ：打印宏输入 tokens（调试用）
- **trace\_macros!(bool)** ：启用 / 禁用宏跟踪（调试用）

---

### 关键特点

1. **编译期处理** ：内置宏在编译期展开，无运行时开销。
2. **安全校验** ：如 format! 检查格式串与参数匹配。
3. **无需导入** ：默认在 prelude 中，直接使用。

---

需要我把这些宏整理成一份 **可直接复制的速查表** ，并标注稳定 / 实验性状态与常用场景吗？

介绍一下Rust内置宏的特点

如何在Rust中使用内置宏？

除了内置宏，Rust还有哪些常用的宏？
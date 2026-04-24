rust字符串

## Rust 字符串完全指南

Rust 的字符串 **和其他语言很不一样** ，是新手最容易困惑的点之一。我用最清晰、最实用的方式给你讲透。

---

## 一、核心结论（先记住这个）

Rust 有 **两种最常用字符串** ：

1. **`String`** —— 可修改、可增长、拥有所有权的字符串（最常用）
2. **`&str`** —— 不可修改、只读、字符串切片（借用）

简单记忆：

- 要 **修改、拼接、存储** → 用 `String`
- 要 **只读、传参、高效读取** → 用 `&str`

---

## 二、基础用法

### 1\. 创建字符串

```rust
// 1. 创建空 String
let mut s = String::new();

// 2. 从字符串字面量创建 String
let s = String::from("hello rust");

// 3. 字符串字面量（&str）
let s = "hello rust";
```

### 2\. String 常用操作

```rust
let mut s = String::from("hello");

// 追加字符
s.push(' ');

// 追加字符串
s.push_str("rust"); 

// 拼接字符串
let s2 = s + "!!!";

// 替换内容
s.replace("rust", "RUST");

// 清空字符串
s.clear();

// 转 &str
let slice: &str = &s;
```

### 3\. &str 只读字符串

```rust
let s = "hello world"; // 类型是 &str

// 不能修改！下面会报错
// s.push_str("abc");
```

---

## 三、String 和 &str 的区别

表格

| 特性 | String | &str |
| --- | --- | --- |
| 可修改 | ✅ 可变 | ❌ 不可变 |
| 所有权 | 拥有数据 | 借用数据 |
| 内存 | 堆内存 | 栈 / 只读数据 |
| 性能 | 灵活但有开销 | 高效、零开销 |
| 使用场景 | 存储、修改、传递所有权 | 函数参数、只读访问、切片 |

**最常用转换：**

```rust
// &str → String
let s = "hello".to_string();
let s = String::from("hello");

// String → &str
let s = String::from("hello");
let slice = &s[..];
let slice = s.as_str();
```

---

## 四、字符串切片（重要）

Rust 字符串 **不支持按索引访问** （因为 UTF-8 变长），但支持 **切片** ：

```rust
let s = "hello rust";
let part = &s[0..5]; // "hello"
let all = &s[..];    // 全部
```

---

## 五、遍历字符串

### 1\. 按字符遍历

```rust
let s = "hello";
for c in s.chars() {
    println!("{}", c);
}
```

### 2\. 按字节遍历

```rust
for b in s.bytes() {
    println!("{}", b);
}
```

---

## 六、函数参数最佳实践

写函数时， **用 &str 作为参数** ，可以同时接收 String 和 &str：

```rust
fn print(s: &str) {
    println!("{}", s);
}

let a = "hello";    // &str
let b = String::from("hello"); // String

print(a);  // ✅
print(&b); // ✅
```

---

## 七、常见坑（新手必看）

1. **不能用 s \[i\] 访问字符** 因为 UTF-8 是变长编码，Rust 不保证索引对应字符
2. **字符串拼接时，左边必须是 String**
	```rust
	let a = "a".to_string();
	let b = a + "b"; // 正确
	// let c = "a" + "b"; // 错误
	```
3. **String 可以修改，&str 不行**

---

### 总结

1. Rust 字符串分 **`String` （可变）** 和 **`&str` （不可变切片）**
2. 存储、修改用 `String` ，只读、传参用 `&str`
3. 不支持 `s[i]` 取字符，要用 `.chars()` 遍历
4. 函数参数优先用 `&str`

需要我给你写一段 **完整可运行的 Rust 字符串示例代码** 吗？

如何在Rust中高效地处理字符串？

如何在Rust中进行字符串的格式化？

如何在Rust中进行字符串的比较？
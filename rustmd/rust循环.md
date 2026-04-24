rust循环

## Rust 循环

Rust 提供了 **三种循环** ，满足不同场景需求，还有强大的 **循环标签** 和 **控制关键字** ，用法清晰且安全：

## 1\. 无限循环 loop

无条件一直循环，必须手动用 `break` 退出，是 Rust 最基础的无限循环。

```rust
fn main() {
    let mut count = 0;

    // 无限循环
    loop {
        count += 1;
        println!("计数: {}", count);

        // 满足条件退出循环
        if count == 5 {
            break; // 退出 loop 循环
        }
    }
}
```

✅ 特点：

- 纯无限循环， **必须手动终止**
- 可以用 `break` **返回值** （Rust 独有特性）

### loop 带返回值（常用）

```rust
fn main() {
    let mut x = 1;
    // 循环结果赋值给 result
    let result = loop {
        x *= 2;
        if x == 8 {
            break x; // break 后的值就是循环的返回值
        }
    };
    println!("循环返回值: {}", result); // 输出 8
}
```

---

## 2\. 条件循环 while

满足条件就执行循环，不满足就退出，和其他语言用法一致。

```rust
fn main() {
    let mut num = 0;

    // 条件为 true 时循环
    while num < 3 {
        println!("while: {}", num);
        num += 1;
    }
}
```

输出：

```
while: 0
while: 1
while: 2
```

---

## 3\. 遍历循环 for

Rust **最常用** 的循环，专门用来遍历集合、范围等。

### ① 遍历数字范围

```rust
fn main() {
    // 1..=5 表示 1 到 5（包含5）
    for i in 1..=5 {
        println!("for: {}", i);
    }
}
```

### ② 遍历数组 / 集合

```rust
fn main() {
    let arr = ["苹果", "香蕉", "橙子"];

    for fruit in arr {
        println!("水果: {}", fruit);
    }
}
```

---

## 循环控制关键字

Rust 有两个关键字控制循环：

- `break` ： **立即退出整个循环**
- `continue` ： **跳过本次循环剩余代码，直接进入下一次循环**

### 示例

```rust
fn main() {
    for i in 1..=5 {
        if i == 3 {
            continue; // 跳过 3，不打印
        }
        if i == 5 {
            break; // 到 5 直接退出循环
        }
        println!("i: {}", i);
    }
}
```

输出：

```
i: 1
i: 2
i: 4
```

---

## 循环标签（多层循环控制）

多层嵌套循环时，用 **标签** 指定要 break/continue 哪一层循环，非常实用。

语法： `'标签名` （以单引号开头）

```rust
fn main() {
    // 给外层循环贴标签 'outer
    'outer: for i in 1..=3 {
        // 给内层循环贴标签 'inner
        'inner: for j in 1..=3 {
            if i == 2 && j == 2 {
                break 'outer; // 直接退出外层循环
            }
            println!("i={}, j={}", i, j);
        }
    }
}
```

---

## 三种循环对比总结

表格

| 循环类型 | 适用场景 |
| --- | --- |
| `loop` | 无限循环、需要循环返回值 |
| `while` | 条件不确定、需要动态判断 |
| `for` | 遍历范围、数组、集合（ **推荐优先使用** ） |

### 总结

1. **无限循环** 用 `loop` ，配合 `break` 退出，还能返回值
2. **条件循环** 用 `while` ，满足条件才执行
3. **遍历数据** 用 `for` ，Rust 最常用、最安全
4. 控制循环： `break` 退出， `continue` 跳过
5. 多层循环用 **标签** 精准控制

如何在循环中使用 continue 关键字？

除了循环，Rust 还有哪些控制流语句？

如何在循环中使用模式匹配？
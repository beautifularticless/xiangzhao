rust 循环

## Rust 循环基础

Rust 提供了 **3 种循环** ，满足不同场景需求，语法简洁且安全：

1. `loop` ：无限循环（手动终止）
2. `while` ：条件循环（条件为真时执行）
3. `for` ：遍历循环（遍历集合 / 范围，最常用）

下面用简单示例带你快速掌握。


## 1\. loop 无限循环

默认无限执行，必须用 `break` 终止； `continue` 跳过当前轮次。

```rust
fn main() {
    let mut count = 0;

    loop {
        count += 1;

        // 跳过 count=2 的循环
        if count == 2 {
            println!("跳过 count = {}", count);
            continue;
        }

        println!("loop 循环：count = {}", count);

        // 满足条件终止循环
        if count == 3 {
            println!("循环结束！");
            break; // 终止循环
        }
    }
}
```

✅ 核心用法： `break` 还能 **返回值** （Rust 独有特性）：

```rust
fn main() {
    let mut num = 1;
    // 用 loop 计算结果并赋值给 result
    let result = loop {
        num *= 2;
        if num > 5 {
            break num; // break 后的值作为循环的返回值
        }
    };
    println!("循环返回值：{}", result); // 输出 8
}
```

---

## 2\. while 条件循环

每次执行前检查条件，条件为 `true` 就执行，为 `false` 自动退出。

```rust
fn main() {
    let mut count = 1;

    // 条件：count <= 3
    while count <= 3 {
        println!("while 循环：count = {}", count);
        count += 1; // 必须更新条件，否则死循环
    }
    println!("while 循环结束");
}
```

---

## 3\. for 遍历循环（最常用）

专门用来 **遍历范围、数组、向量等集合** ，代码简洁且安全。

### 示例 1：遍历数字范围 1..=5（包含 5）

```rust
fn main() {
    // 遍历 1 到 5（闭区间）
    for num in 1..=5 {
        println!("for 循环：num = {}", num);
    }
}
```

### 示例 2：遍历数组 / 向量

```rust
fn main() {
    let fruits = ["苹果", "香蕉", "橙子"];

    // 遍历数组元素
    for fruit in fruits {
        println!("水果：{}", fruit);
    }
}
```

---

## 循环标签（嵌套循环控制）

嵌套循环时，用 **标签** 指定 `break/continue` 作用于哪一层循环：

```rust
fn main() {
    // 外层循环标签：'outer
    'outer: for i in 1..=3 {
        // 内层循环
        for j in 1..=3 {
            if i == 2 && j == 2 {
                println!("跳出外层循环！");
                break 'outer; // 直接终止外层循环
            }
            println!("i={}, j={}", i, j);
        }
    }
}
```

---

### 总结

1. **`loop`** ：无限循环，需手动 `break` ，可返回值
2. **`while`** ：条件循环，适合「不确定循环次数」的场景
3. **`for`** ：遍历循环，适合「遍历集合 / 确定范围」的场景（优先使用）
4. 关键字： `break` 终止循环， `continue` 跳过当前轮次，标签控制嵌套循环
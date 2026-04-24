rust迭代器

Rust 迭代器核心要点： **Iterator trait、惰性求值、三种迭代方式、适配器 / 消费者、自定义迭代器** 。下面一次性讲全、附可运行示例。

---

### 一、迭代器核心：Iterator trait

所有迭代器都实现 `std::iter::Iterator` ，核心仅一个方法：

```rust
trait Iterator {
    type Item; // 迭代元素类型
    fn next(&mut self) -> Option<Self::Item>;
}
```

- 每次 `next()` 返回 `Some(元素)` ，结束返回 `None` Rust。
- **惰性** ：迭代器本身不计算，只有调用 `next()` （或消费者方法）才真正执行。

---

### 二、三种迭代方式（所有权规则）

集合提供三种创建迭代器的方法，对应不同所有权：

表格

| 方法 | 元素类型 | 所有权影响 | 场景 |  |
| --- | --- | --- | --- | --- |
| `.iter()` | `&T` | 借用，不修改原集合 | 只读遍历 |  |
| `.iter_mut()` | `&mut T` | 可变借用 | 遍历中修改元素 |  |
| `.into_iter()` | `T` | 转移所有权，原集合失效 | 转移元素、消耗集合 | Rust |

示例：

```rust
let v = vec![1,2,3];
// 1. 不可变借用
for x in v.iter() { println!("{}", x); }

// 2. 可变借用
let mut v = vec![1,2,3];
for x in v.iter_mut() { *x *= 2; }

// 3. 所有权转移
let v = vec![1,2,3];
for x in v.into_iter() { println!("{}", x); }
// 此处 v 已失效，不能再用
```

---

### 三、迭代器适配器（链式操作）

**适配器** ：返回新迭代器，惰性，可链式调用。

#### 常用适配器

- `map(f)` ：元素映射
- `filter(f)` ：过滤元素
- `flat_map(f)` ：展平嵌套迭代器
- `take(n)` ：取前 n 个
- `skip(n)` ：跳过前 n 个
- `zip(other)` ：与另一个迭代器配对
- `enumerate()` ：返回 (索引，元素)

示例：

```rust
let v = vec![1,2,3,4,5];
let res: Vec<_> = v.iter()
    .filter(|&&x| x % 2 == 0) // 保留偶数
    .map(|&x| x * 10)          // ×10
    .collect();
assert_eq!(res, vec![20,40]);
```

---

### 四、消费者方法（触发执行）

**消费者** ：消耗迭代器，执行遍历并返回结果。

#### 常用消费者

- `collect::<C>()` ：收集到集合（Vec/HashSet 等）
- `sum()` ：求和
- `fold(init, f)` ：累加 / 归约
- `any(f)` ：任意元素满足条件则 true
- `all(f)` ：所有元素满足条件则 true
- `count()` ：计数
- `max()` / `min()` ：最值

示例：

```rust
let v = vec![1,2,3,4,5];
let sum: i32 = v.iter().sum();
let cnt = v.iter().count();
let max = v.iter().max();
```

---

### 五、for 循环与迭代器

Rust 的 `for` 是迭代器语法糖：

```rust
for x in iter { ... }
// 等价于：
let mut iter = ...;
while let Some(x) = iter.next() { ... }
```

---

### 六、自定义迭代器

只需实现 `Iterator` trait。示例：计数器迭代器

```rust
struct Counter {
    current: u32,
    max: u32,
}

impl Counter {
    fn new(max: u32) -> Self {
        Counter { current: 0, max }
    }
}

impl Iterator for Counter {
    type Item = u32;
    fn next(&mut self) -> Option<Self::Item> {
        if self.current < self.max {
            let res = Some(self.current);
            self.current += 1;
            res
        } else {
            None
        }
    }
}

// 使用
let cnt: Vec<_> = Counter::new(5).collect();
assert_eq!(cnt, vec![0,1,2,3,4]);
```

---

### 七、迭代器性能要点

1. **零成本抽象** ：迭代器无运行时开销，与手写循环等价。
2. **size\_hint** ：迭代器可返回 `(min, max)` ，帮助 `collect` 预分配内存。
	```rust
	fn size_hint(&self) -> (usize, Option<usize>) {
	    (0, Some(self.max as usize))
	}
	```
3. **避免不必要的分配** ：优先用迭代器链式处理，减少中间集合。

---

### 八、常见坑

- **迭代器只能遍历一次** ：消费后不能复用。
- **所有权** ： `into_iter` 会消耗原集合。
- **惰性陷阱** ：适配器不执行，必须调用消费者（如 `collect` ）。

---

要不要我给你一份可直接运行的迭代器常用方法速查表（含示例与注释），方便你随时查阅？

如何在Rust中使用迭代器？

惰性求值在Rust中有哪些应用场景？

如何在Rust中自定义迭代器？
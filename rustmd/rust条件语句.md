rust条件语句

## Rust 条件语句

Rust 的条件语句核心是 **`if` / `else if` / `else`** ，语法简洁， **没有三元运算符** ，且条件必须是 **布尔值（ `true` / `false` ）** ，不会自动类型转换。

## 一、基础 if 语句

语法： `if 条件 { 代码块 }`

- 条件 **不需要加括号**
- 代码块必须用 `{}` 包裹（即使只有一行）

```rust
fn main() {
    let age = 18;
    
    // 基础条件判断
    if age >= 18 {
        println!("已成年");
    }
}
```

## 二、if + else 语句

二选一判断：

```rust
fn main() {
    let score = 60;
    
    if score >= 60 {
        println!("及格");
    } else {
        println!("不及格");
    }
}
```

## 三、if + else if + else 语句

多条件分支判断（支持任意多个 `else if` ）：

```rust
fn main() {
    let score = 85;
    
    if score >= 90 {
        println!("优秀");
    } else if score >= 80 {
        println!("良好");
    } else if score >= 60 {
        println!("及格");
    } else {
        println!("不及格");
    }
}
```

## 四、Rust 特色：if 作为表达式

Rust 中 `if` 是 **表达式** ，可以直接赋值给变量（替代其他语言的三元运算符）。规则：所有分支返回的值 **类型必须一致** 。

```rust
fn main() {
    let age = 20;
    // 用 if 表达式直接赋值
    let is_adult = if age >= 18 { true } else { false };
    println!("是否成年：{}", is_adult); // 输出：是否成年：true

    // 也可以返回字符串
    let status = if age >= 18 { "成年" } else { "未成年" };
    println!("状态：{}", status);
}
```

## 五、嵌套 if 语句

条件内嵌套条件，逻辑更复杂：

```rust
fn main() {
    let age = 20;
    let has_id = true;
    
    if age >= 18 {
        if has_id {
            println!("可以进入");
        } else {
            println!("需要携带身份证");
        }
    } else {
        println!("禁止进入");
    }
}
```

## 六、逻辑运算符（多条件组合）

配合逻辑运算符实现复杂条件：

- `&&` ：逻辑与（同时满足）
- `||` ：逻辑或（满足其一）
- `!`：逻辑非（取反）

```rust
fn main() {
    let a = true;
    let b = false;
    
    if a && !b {
        println!("a 为真且 b 为假");
    }
    
    if a || b {
        println!("至少一个为真");
    }
}
```

## 七、注意事项

1. **条件必须是布尔值** ：Rust 不允许 `if 1` 、 `if "hello"` 这种非布尔条件，会直接报错。
2. **代码块不可省略 `{}`** ：即使只有一行代码，也必须写大括号。
3. **表达式返回值类型统一** ：用 `if` 赋值时，所有分支的返回类型必须一致。

---

### 总结

1. 核心语法： `if` / `else if` / `else` ，条件无括号、代码块必加 `{}`
2. 特色用法： `if` 是表达式，可直接赋值给变量
3. 严格类型：条件只能是 `bool` 类型，无自动类型转换
4. 支持嵌套、多条件、逻辑运算符组合使用

在 Rust 中，if 作为表达式时，是否支持嵌套使用？

除了 if 语句，Rust 还有哪些控制流语句？

如何在 Rust 中使用 match 表达式进行模式匹配？
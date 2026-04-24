rust面向对象

Rust 没有 `class` 和继承，但可以用 **struct + impl 做封装、用 trait 做接口 / 多态、用组合代替继承** ，写出安全又接近 OOP 的代码。

---

### 一、封装：struct + impl + pub

用 struct 存数据，impl 写方法，pub 控制可见性，默认私有。

```rust
// 结构体（类比“类”）
pub struct User {
    name: String, // 私有字段
    age: u32,
}

// 方法实现块
impl User {
    // 构造函数（关联方法，无 self）
    pub fn new(name: String, age: u32) -> Self {
        Self { name, age }
    }

    // 实例方法（&self：只读）
    pub fn greet(&self) {
        println!("Hi, I'm {} (age {})", self.name, self.age);
    }

    // 实例方法（&mut self：可修改）
    pub fn birthday(&mut self) {
        self.age += 1;
    }

    // 私有方法（外部不可见）
    fn secret(&self) {}
}

fn main() {
    let mut u = User::new("Alice".into(), 20);
    u.greet();
    u.birthday();
    // u.secret(); // 编译错误：私有方法
}
```

关键点：

- 字段默认私有， **pub 才对外可见** 。
- 方法按 `self` / `&self` / `&mut self` 区分所有权与借用。

---

### 二、继承：用组合代替 extends

Rust **没有继承** ，推荐用 “组合”（把一个 struct 嵌到另一个里）复用数据与行为。

```rust
// 基础“父类”
struct Person {
    name: String,
    age: u32,
}
impl Person {
    fn new(name: String, age: u32) -> Self { Self { name, age } }
    fn greet(&self) { println!("I'm {}", self.name); }
}

// 组合：包含 Person，而非继承
struct Student {
    person: Person, // 嵌入
    school: String,
}
impl Student {
    fn new(name: String, age: u32, school: String) -> Self {
        Self {
            person: Person::new(name, age),
            school,
        }
    }

    // 转发方法（类似“继承”父类方法）
    fn greet(&self) {
        self.person.greet();
        println!("I study at {}", self.school);
    }
}

fn main() {
    let s = Student::new("Bob".into(), 18, "MIT".into());
    s.greet();
}
```

对比传统继承：

- ✅ 无继承链、无菱形问题、更安全。
- ✅ 按需嵌入，灵活组合多个 “父对象”。

---

### 三、接口与多态：trait

trait 类似接口，定义行为，不存数据；多态分 **静态（泛型） **和** 动态（trait 对象）** 。

#### 1）定义 trait

```rust
trait Animal {
    // 必须实现的方法
    fn speak(&self);

    // 默认实现（可选重写）
    fn sleep(&self) {
        println!("Zzz...");
    }
}
```

#### 2）为 struct 实现 trait

```rust
struct Dog;
impl Animal for Dog {
    fn speak(&self) { println!("Woof!"); }
    // 不重写 sleep，用默认
}

struct Cat;
impl Animal for Cat {
    fn speak(&self) { println!("Meow!"); }
    fn sleep(&self) { println!("Cat napping..."); }
}
```

#### 3）静态多态（泛型，零成本）

```rust
fn let_speak<T: Animal>(a: &T) {
    a.speak();
    a.sleep();
}

fn main() {
    let_speak(&Dog);
    let_speak(&Cat);
}
```

#### 4）动态多态（trait 对象，运行时派发）

用 `&dyn Trait` 或 `Box<dyn Trait>` ，适合异构集合。

```rust
fn let_speak_dyn(a: &dyn Animal) {
    a.speak();
}

fn main() {
    let animals: Vec<Box<dyn Animal>> = vec![Box::new(Dog), Box::new(Cat)];
    for a in animals {
        a.speak();
    }
}
```

---

### 四、子类化与代码复用：trait + 默认方法

用 trait 默认实现复用代码，类似 “父类方法”Rust。

```rust
trait Shape {
    fn area(&self) -> f64;

    // 默认方法：所有实现者自动获得
    fn print_area(&self) {
        println!("Area: {}", self.area());
    }
}

struct Circle { r: f64 }
impl Shape for Circle {
    fn area(&self) -> f64 { std::f64::consts::PI * self.r * self.r }
}

struct Square { s: f64 }
impl Shape for Square {
    fn area(&self) -> f64 { self.s * self.s }
}

fn main() {
    Circle { r: 5.0 }.print_area();
    Square { s: 4.0 }.print_area();
}
```

---

### 五、对比：Rust vs 传统 OOP

表格

| 特性 | Java/C++ | Rust |
| --- | --- | --- |
| 类 | `class` | `struct + impl` |
| 继承 | `extends` /`: Base` | **无** ，用 **组合** |
| 接口 | `interface` | `trait` |
| 多态 | 虚函数 | 泛型（静态）/ `dyn` （动态） |
| 封装 | `private` / `public` | `pub` + 所有权系统 |

---

### 六、常见 OOP 模式在 Rust 中的替代

- **继承 → 组合 + trait** ：嵌入 struct 复用数据，trait 复用行为。
- **接口 → trait** ：无数据，仅行为契约。
- **单例 → 静态变量 + 懒初始化** （ `lazy_static` ）。
- **工厂 → 关联方法或 trait** 。

---

### 小结

Rust 用 **struct+impl 做封装、组合代替继承、trait 做接口与多态** ，既保留 OOP 的核心能力，又避免继承的复杂性与安全隐患。

要不要我把上面内容浓缩成一份可直接复制的 **常用 OOP 代码模板** （封装 / 组合 /trait/ 静态 / 动态多态），方便你直接套用？
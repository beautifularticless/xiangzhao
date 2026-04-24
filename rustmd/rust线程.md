rust线程

Rust 线程基于 OS 原生线程、通过所有权 + 类型系统在编译期杜绝数据竞争，核心是： **spawn 创建、JoinHandle 等待、move 转移所有权、Channel/Arc+Mutex 通信共享** Rust。下面从基础、所有权、通信、共享、实践与常见坑逐一讲清楚。

---

### 一、基础：创建与等待线程

#### 1\. 最简创建：thread::spawn

```rust
use std::thread;

fn main() {
    // 创建线程，返回 JoinHandle
    let handle = thread::spawn(|| {
        println!("子线程：hello");
        42 // 子线程返回值
    });

    // 等待子线程结束并获取结果（Result<T>）
    let res = handle.join().unwrap();
    println!("主线程：子线程返回 {}", res);
}
```

- `spawn` ：接收 **无参闭包** ，创建 OS 线程，返回 `JoinHandle<T>` Rust。
- `join()` ：阻塞等待线程结束，返回 `Result<T>` ，可捕获 panic。
- 主线程退出时，所有子线程会被 **强制终止** ，务必 `join` 。

#### 2\. 线程构建器（自定义属性）

用 `Builder` 设置 **线程名、栈大小** ：

```rust
use std::thread;

fn main() {
    let handle = thread::Builder::new()
        .name("worker-1".into())
        .stack_size(4 * 1024 * 1024) // 4MB 栈
        .spawn(|| {
            println!("线程名：{:?}", thread::current().name());
        })
        .unwrap();
    handle.join().unwrap();
}
```

---

### 二、所有权：线程安全的核心（move 必懂）

Rust 禁止线程间 **非法共享栈数据** ，必须用 `move` 转移所有权：

```rust
use std::thread;

fn main() {
    let s = String::from("hello");

    // 错误：不写 move，闭包借用 s，生命周期不匹配
    // let h = thread::spawn(|| println!("{}", s));

    // 正确：move 把 s 所有权移到子线程
    let h = thread::spawn(move || println!("{}", s));

    h.join().unwrap();
    // println!("{}", s); // 错误：s 已被 move，主线程不再拥有
}
```

- 规则： **子线程闭包用到主线程变量 → 必须 move** ，否则编译报错。
- 本质：所有权转移，保证 **一个变量同一时间只属于一个线程** ，从根源消除数据竞争。

---

### 三、线程间通信：Channel（消息传递）

Rust 推荐 **通过通信共享内存，而非共享内存通信** ，标准库用 `mpsc` （多生产者单消费者）通道。

#### 1\. 基础用法（单发单收）

```rust
use std::sync::mpsc;
use std::thread;

fn main() {
    // 创建通道：(发送端tx, 接收端rx)
    let (tx, rx) = mpsc::channel();

    // 子线程：发送消息
    thread::spawn(move || {
        tx.send("hello from thread").unwrap();
    });

    // 主线程：接收消息
    let msg = rx.recv().unwrap();
    println!("收到：{}", msg);
}
\`\`\`{insert\_element\_2\_}

#### 2. 多生产者（多个线程发）
\`\`\`rust
use std::sync::mpsc;
use std::thread;

fn main() {
    let (tx, rx) = mpsc::channel();
    let tx1 = tx.clone(); // 克隆发送端，给第二个线程

    // 线程1
    thread::spawn(move || {
        tx.send(String::from("hi")).unwrap();
    });

    // 线程2
    thread::spawn(move || {
        tx1.send(String::from("hello")).unwrap();
    });

    // 循环接收所有消息
    for msg in rx {
        println!("收到：{}", msg);
    }
}
\`\`\`{insert\_element\_3\_}

- \`send\`：发送数据，所有权转移，**不可重复发送同一数据**。
- \`recv\`：阻塞接收，通道关闭且无数据时返回 \`Err\`。

---

### 四、共享内存：Arc + Mutex（多线程共享数据）
若必须**多线程读写同一数据**，用 \`Arc\`（原子引用计数）+ \`Mutex\`（互斥锁）组合：
\`\`\`rust
use std::sync::{Arc, Mutex};
use std::thread;

fn main() {
    // Arc 包装 Mutex 包裹的 i32
    let counter = Arc::new(Mutex::new(0));
    let mut handles = vec![];

    for _ in 0..10 {
        // 克隆 Arc，所有权+1，各线程共享
        let counter = Arc::clone(&counter);
        let h = thread::spawn(move || {
            // 加锁：同一时间只有一个线程能访问
            let mut num = counter.lock().unwrap();
            *num += 1;
        });
        handles.push(h);
    }

    // 等待所有线程完成
    for h in handles {
        h.join().unwrap();
    }

    // 最终结果：10
    println!("结果：{}", *counter.lock().unwrap());
}
\`\`\`{insert\_element\_4\_}

- \`Arc<T>\`：**线程安全的引用计数指针**，多线程只读共享，\`clone\` 增加计数。
- \`Mutex<T>\`：**互斥锁**，保证同一时间只有一个线程能修改数据，\`lock()\` 阻塞加锁。
- 组合：\`Arc<Mutex<T>>\` → 多线程**读写共享**的标准方案。

---

### 五、线程休眠与让步
- \`thread::sleep\`：休眠指定时间（阻塞当前线程）
\`\`\`rust
use std::thread;
use std::time::Duration;

fn main() {
    println!("开始");
    thread::sleep(Duration::from_secs(2)); // 休眠2秒
    println!("结束");
}
```

- `thread::yield_now` ：主动让出 CPU，让其他线程先执行（非阻塞）

```rust
thread::yield_now();
```

---

### 六、常见坑与最佳实践

1. **忘记 move → 编译失败** ：子线程用主线程变量， **必须 move** 。
2. **主线程不 join → 子线程被强杀** ：主线程退出会终止所有子线程， **务必 join 所有 handle** 。
3. **数据竞争 → 编译期阻止** ：Rust 所有权系统 **杜绝数据竞争** ，不用像 C++/Java 那样手动加锁防竞争。
4. **死锁（Arc+Mutex）** ：避免 **循环锁、嵌套锁** ，按固定顺序加锁。
5. **线程数量不是越多越好** ：OS 线程有栈开销（默认 8MB），超 CPU 核心数后 **上下文切换变慢** ，优先用 **线程池** （如 `rayon` 库）。

---

### 七、扩展：Rayon 线程池（简化并行）

实际开发中，直接用 `rayon` 库的 **并行迭代器** ，不用手动管理线程：

```rust
// Cargo.toml 加：rayon = "1.7"
use rayon::prelude::*;

fn main() {
    let nums: Vec<i32> = (1..=100).collect();
    // 并行求和（自动线程池）
    let sum: i32 = nums.par_iter().sum();
    println!("和：{}", sum);
}
```

要不要我把以上内容浓缩成一份可直接复制的 **常用线程代码模板** （含 spawn、join、channel、Arc+Mutex、rayon 示例），方便你直接套用？

在Rust中，如何在多个线程之间安全地共享数据？

详细介绍一下Rust中线程的所有权和生命周期

如何在Rust中使用线程池来管理线程？
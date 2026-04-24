rust log

`log` 是 Rust 的 **日志门面（logging facade）** ，只提供统一的日志宏与级别，实际输出要搭配一个 **后端实现** （最常见： `env_logger` 、 `fern` 、 `tracing` ）。

---

### 一、日志级别（从低到高）

```rust
trace!("[TRACE] 最细粒度调试");
debug!("[DEBUG] 调试信息");
info!("[INFO] 常规运行信息");
warn!("[WARN] 警告（不影响主流程）");
error!("[ERROR] 错误（影响功能）");
```

默认启用： **info 及以上** 。

---

### 二、快速上手：log + env\_logger

#### 1\. 加依赖（Cargo.toml）

```toml
[dependencies]
log = "0.4"
env_logger = "0.10"
```

#### 2\. 写代码（main.rs）

```rust
use log::{debug, info, warn, error};

fn main() {
    // 初始化：读取 RUST_LOG 环境变量
    env_logger::init();

    trace!("不会显示（默认级别 info）");
    debug!("调试信息（默认不显示）");
    info!("应用启动");
    warn!("空输入");
    error!("IO 失败");
}
```

#### 3\. 运行与控制级别

```bash
# 只看 info+（默认）
cargo run

# 开启 debug
RUST_LOG=debug cargo run

# 只看错误
RUST_LOG=error cargo run

# 模块粒度：my_crate=debug, 其他info
RUST_LOG=info,my_crate=debug cargo run
```

---

### 三、自定义格式（env\_logger Builder）

```rust
use env_logger::Builder;
use log::LevelFilter;
use std::io::Write;

fn main() {
    Builder::new()
        .format(|buf, record| {
            writeln!(
                buf,
                "[{} {}:{}] {} - {}",
                record.level(),
                record.file().unwrap_or("unknown"),
                record.line().unwrap_or(0),
                chrono::Local::now().format("%Y-%m-%d %H:%M:%S"),
                record.args()
            )
        })
        .filter_level(LevelFilter::Debug)
        .filter_module("my_mod", LevelFilter::Trace)
        .init();

    info!("自定义格式生效");
}
```

---

### 四、常用后端对比

表格

| 后端 | 特点 | 适用场景 |
| --- | --- | --- |
| env\_logger | 轻量、环境变量驱动、终端友好 | 命令行工具、简单服务 |
| fern | 可文件输出、轮换、彩色 | 需持久化日志的服务 |
| tracing | 结构化、异步、跨线程、生态强 | 中大型服务、可观测性 |

---

### 五、库 vs 应用的最佳实践

- **库** ：只依赖 `log` ，用宏打日志， **不初始化后端** ，由应用决定输出。
- **应用** ：选一个后端（如 `env_logger` ），在 `main` 初始化。

---

### 六、常见坑

1. **没初始化后端** ：日志静默丢弃，无输出。
2. **release 无 debug** ：release 默认关闭 debug/trace，可通过 `RUST_LOG=debug` 或编译参数开启。
3. **性能** ：宏在编译期判断级别， **无级别日志是零开销** 。

---

要不要我给你一个可直接复制的 **fern 文件日志 + 按天轮转** 完整示例？

在代码中使用log模块打印日志信息

除了env\_logger，还有哪些常用的Rust日志后端实现？

如何配置Rust的日志级别？
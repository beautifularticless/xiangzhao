rust cargo

**Cargo 是 Rust 的官方构建系统 + 包管理器 + 项目管理器** ，随 Rust 一起安装，是写 Rust 必备工具。

---

### 一、核心作用

- 创建标准项目骨架
- 管理依赖（自动下载、版本解析、锁定）
- 编译、运行、测试、基准测试
- 生成文档、格式化代码、静态检查
- 发布库到 crates.io

### 二、安装与版本

安装 Rust 后自带：

```bash
rustup install stable   # 安装稳定版
cargo --version          # 查看版本
```

### 三、快速上手（最小示例）

#### 1）创建项目

```bash
cargo new hello_demo
cd hello_demo
```

目录结构：

```
hello_demo/
├── Cargo.toml   # 配置与依赖
└── src/
    └── main.rs  # 入口
```

#### 2）运行

```bash
cargo run
# 等价于：cargo build + 运行 target/debug/hello_demo
```

#### 3）发布构建（优化）

```bash
cargo build --release
# 产物：target/release/hello_demo
```

### 四、Cargo.toml 核心配置

```toml
[package]
name = "hello_demo"
version = "0.1.0"
edition = "2021"   # Rust 版本

[dependencies]
# 从 crates.io 引入
serde = "1.0"
tokio = { version = "1.0", features = ["full"] }

# 本地路径
my_lib = { path = "../my_lib" }

# Git 依赖
some_git_lib = { git = "https://xxx.git", branch = "main" }
```

- `Cargo.lock` ： **自动生成并提交** ，锁定所有依赖 **确切版本** 。

### 五、常用命令（速查表）

#### 项目创建

```bash
cargo new <name>          # 新建二进制项目
cargo new <name> --lib    # 新建库项目
cargo init                 # 当前目录初始化
```

#### 构建 / 运行

```bash
cargo build                # 调试构建（debug）
cargo build --release      # 发布构建（release）
cargo run                  # 构建并运行
cargo check                # 只检查，不生成二进制（快）
cargo clean                # 清理 target
```

#### 依赖管理

```bash
cargo add serde            # 添加依赖（Rust 1.62+）
cargo rm serde             # 移除依赖
cargo update                # 更新所有依赖（按 SemVer）
cargo tree                  # 查看依赖树
```

#### 质量与文档

```bash
cargo test                 # 运行测试
cargo fmt                  # 自动格式化代码
cargo clippy               # 静态检查（常见错误/优化建议）
cargo doc --open           # 生成并打开文档
```

#### 安装 / 发布

```bash
cargo install <crate>      # 安装二进制工具
cargo publish               # 发布到 crates.io
```

### 六、关键概念

- **Crate** ：Rust 的包 / 库单元（二进制 crate 或库 crate）。
- **crates.io** ：官方公共包仓库。
- **SemVer** ：语义化版本（ `主.次.修订` ）。
- **Workspace** ：多包大项目管理（ `[workspace]` ）。

### 七、典型工作流

1. `cargo new` 创建项目
2. `Cargo.toml` 添加依赖
3. `cargo check` 频繁检查
4. `cargo test` 写测试
5. `cargo fmt` + `cargo clippy` 保证质量
6. `cargo build --release` 发布

---

要不要我给你一个可直接复制的 **Cargo.toml 模板（含常用依赖与注释）** ，并附上国内镜像加速配置？

如何使用Cargo发布一个库到crates.io？

如何使用Cargo管理项目依赖？

Cargo和npm、pip有什么区别？
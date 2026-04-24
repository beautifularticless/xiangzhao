rust命令

下面把 Rust 开发最常用的 **rustup / cargo / rustc** 命令整理成一份可直接复制的速查清单，按场景分组，便于日常开发和部署。

---

## 一、rustup：版本管理与安装

### 安装 & 版本

```bash
# 安装 Rust (Linux/macOS)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# 安装 Rust (Windows)
# 访问 https://www.rust-lang.org/tools/install 下载安装程序

# 查看版本
rustup --version
rustc --version
cargo --version

# 更新工具链
rustup update

# 查看已安装工具链
rustup toolchain list

# 安装指定版本
rustup toolchain install 1.70.0

# 切换默认工具链
rustup default 1.70.0

# 临时使用某版本
rustup override set 1.70.0   # 当前目录生效
rustup override unset
```

### 组件管理（标准库、文档、工具）

```bash
# 查看组件
rustup component list

# 安装组件（常用）
rustup component add rust-src      # 标准库源码
rustup component add rust-docs     # 官方文档
rustup component add clippy        # 代码检查
rustup component add rustfmt        # 代码格式化

# 卸载组件
rustup component remove clippy
```

---

## 二、cargo：项目管理与构建（日常最常用）

### 项目创建

```bash
# 创建二进制项目（默认）
cargo new my_project
cd my_project

# 创建库项目
cargo new my_lib --lib

# 在当前目录初始化项目
cargo init
cargo init --lib
```

### 构建 & 运行

```bash
# 开发模式（debug，快、未优化）
cargo build                      # 编译，产物 target/debug/
cargo run                        # 编译+运行

# 发布模式（release，慢、高度优化）
cargo build --release            # 产物 target/release/
cargo run --release

# 快速检查（只报错，不生成二进制）
cargo check
```

### 依赖管理（Cargo.toml）

```bash
# 添加依赖（自动写入 Cargo.toml）
cargo add serde
cargo add tokio --features full

# 移除依赖
cargo remove serde

# 更新所有依赖到兼容最新版
cargo update

# 更新指定依赖
cargo update -p serde

# 查看依赖树
cargo tree
cargo tree -d   # 只看开发依赖
```

### 测试 & 质量

```bash
# 运行所有测试
cargo test

# 代码格式化（rustfmt）
cargo fmt

# 代码静态检查（clippy，强推荐）
cargo clippy
cargo clippy --all-targets -- -D warnings   # 严格模式

# 自动修复可修复的警告
cargo fix
```

### 文档 & 发布

```bash
# 生成本地文档（打开浏览器）
cargo doc --open

# 打包发布（crates.io）
cargo login       # 先登录（API Token）
cargo publish
```

### 清理 & 工具安装

```bash
# 清空 target/ 编译产物
cargo clean

# 安装第三方二进制工具（全局）
cargo install exa
cargo install du-dust

# 卸载全局工具
cargo uninstall exa
```

---

## 三、rustc：直接调用编译器（底层，偶尔用）

```bash
# 直接编译单个文件
rustc main.rs

# 编译并指定输出文件名
rustc main.rs -o my_app

# 发布模式优化
rustc -O main.rs

# 查看帮助
rustc -h
```

---

## 四、常用组合（日常开发高频）

```bash
# 新建项目 → 运行
cargo new demo && cd demo && cargo run

# 写代码 → 检查 → 格式化 → 提交
cargo check
cargo fmt
cargo clippy

# 发布前构建
cargo build --release
```

---

如果你愿意，我可以把这些命令整理成一份 **可直接复制的 Cheat Sheet（纯文本）** ，方便你保存到本地或编辑器。需要吗？

如何使用rustup安装特定版本的Rust？

如何使用rustup安装特定版本的Rust？

如何使用rustup安装特定版本的Rust？
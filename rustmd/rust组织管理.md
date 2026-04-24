rust组织管理

Rust 的 “组织管理” 通常分两层：

- **代码组织** ：用 **Package / Crate / Module / Workspace** 做模块化与工程结构。
- **项目治理** ：Rust 官方项目的团队结构、决策流程（RFC）与基金会分工。

下面分别讲清楚，附可直接套用的目录结构与示例。

---

## 一、代码组织（日常开发最常用）

### 1\. 核心概念

- **Package（包）** ： `Cargo.toml` 所在目录，是 Cargo 管理的最小单元。
	```bash
	cargo new myproj
	```
- **Crate（箱）** ：编译单元，一个 Package 可含：
	- 二进制 Crate： `src/main.rs` → 生成可执行文件。
		- 库 Crate： `src/lib.rs` → 供其他项目调用。
- **Module（模块）** ：用 `mod` 划分命名空间、控制可见性（ `pub` ）。
- **Workspace（工作空间）** ：管理多个关联 Package，共享依赖与构建配置。

### 2\. 单包项目结构（小 / 中型项目）

```
myproj/
├── Cargo.toml
└── src/
    ├── main.rs       # 二进制入口（fn main）
    ├── lib.rs         # 库入口（可选，供内部/外部调用）
    ├── api/
    │   ├── mod.rs
    │   └── v1.rs
    ├── service/
    │   ├── mod.rs
    │   └── user.rs
    └── utils/
        ├── mod.rs
        └── crypto.rs
```

- `mod.rs` ：目录模块的 “入口”，用于 `pub mod` 导出子模块。
- 引用规则：
	```rust
	// src/service/user.rs
	pub fn get_user() { ... }
	// src/api/v1.rs
	use crate::service::user; // 绝对路径（crate 根）
	// 或
	use super::service::user; // 相对路径
	```

### 3\. 模块可见性（pub 控制）

- 默认： **私有** （仅同模块 / 子模块可见）。
- `pub` ：对外公开（跨模块、跨 Crate 可见）。
- `pub(crate)` ：仅当前 Crate 内可见（常用）。

```rust
// src/lib.rs
pub mod api;          // 公开模块
mod internal;          // 私有模块
pub use api::v1::*;    // 重新导出，简化外部引用
```

### 4\. 多包 Workspace（大型项目 /monorepo）

**顶层 Cargo.toml** （ `workspace = true` ）：

```toml
[workspace]
members = [
  "crates/core",
  "crates/api",
  "crates/cli",
]
```

**目录结构** ：

```
myworkspace/
├── Cargo.toml       # 工作空间根
├── crates/
│   ├── core/        # 基础库（lib）
│   │   ├── Cargo.toml
│   │   └── src/lib.rs
│   ├── api/         # HTTP 服务（lib）
│   └── cli/         # 命令行工具（bin）
├── examples/
└── tests/
```

- 子包互引用：
	```toml
	# crates/api/Cargo.toml
	[dependencies]
	core = { path = "../core" }
	```

### 5\. 最佳实践（社区约定）

1. **按职责拆分模块** ： `api/` 、 `service/` 、 `data/` 、 `utils/` ，避免大文件。
2. **mod.rs 瘦身** ：只放 `pub mod` 、 `pub use` ，不要写业务逻辑。
3. **统一导出（prelude）** ：
	```rust
	// src/prelude.rs
	pub use crate::api::*;
	pub use crate::service::*;
	```
4. **测试目录** ：
	- 单元测试：与源码同文件（ `#[cfg(test)] mod tests` ）。
		- 集成测试：放在 `tests/` 目录。

---

## 二、Rust 官方项目治理（了解即可）

### 1\. 治理结构（2023 年后新模型）

- **Rust 项目（Project）** ：负责技术决策、开发、发布Rust。
- **Rust 基金会（Foundation）** ：负责资金、商标、社区运营，与项目独立。
- **领导委员会（Leadership Council）** ：协调各团队，对项目整体负责Rust。

### 2\. 核心团队（Teams）

- **Language Team** ：设计语言特性、语法、语义Rust。
- **Compiler Team** ：维护 `rustc` 、优化、LLVM 集成Rust。
- **Library Team** ：标准库（ `std` ）、官方 crate（如 `serde` ）Rust。
- **DevTools Team** ：Cargo、rustfmt、clippy、IDE 支持Rust。
- **Infrastructure Team** ：CI、发布、服务器、安全Rust。

### 3\. 决策流程（RFC）

1. 重大变更先写 **RFC（Request for Comments）** ，公开讨论Rust。
2. 社区评审 → 团队投票 → 合并 → 实现 → 稳定发布。
3. 小改动可直接提 PR，无需 RFC。

---

## 三、快速示例：从 0 建一个规范项目

```bash
# 1. 创建工作空间
mkdir myws && cd myws
echo '[workspace]
members = ["crates/core", "crates/cli"]' > Cargo.toml

# 2. 创建子包
cargo new --lib crates/core
cargo new crates/cli

# 3. 互引用
echo '[dependencies]
core = { path = "../core" }' >> crates/cli/Cargo.toml
```

写代码：

```rust
// crates/core/src/lib.rs
pub fn greet(name: &str) -> String {
    format!("Hello, {}!", name)
}

// crates/cli/src/main.rs
use core::greet;
fn main() {
    println!("{}", greet("Rust"));
}
```

运行：

```bash
cargo run -p cli
```

---

## 四、常见误区

- ❌ 所有代码堆在 `src/` 根目录 → 模块拆分。
- ❌ `mod.rs` 写大量逻辑 → 只做导出。
- ❌ 跨目录滥用 `pub` → 优先 `pub(crate)` 。
- ❌ 不用 Workspace 管理多包 → 中型项目就开始用。

---

需要我把这些整理成一份可直接复制的 **Rust 项目模板（含完整目录、Cargo.toml 与示例代码）** 吗？

如何在Rust中使用模块来组织代码？

如何在Rust中使用包来管理项目依赖？

在Rust中，如何使用Cargo来构建和管理项目？
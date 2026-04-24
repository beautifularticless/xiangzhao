rust开发环境搭建

下面按 **Windows（MSVC 原生）、Windows（WSL2）、macOS/Linux** 三种场景，一步到位搭建 Rust 开发环境，含工具链、国内镜像、VSCode 插件、Hello World 验证。

---

## 一、Windows 原生环境（MSVC，推荐）

### 1\. 安装 C++ 构建工具（必须）

Rust 链接需要 MSVC 工具链：

1. 下载 **Microsoft C++ 生成工具** ： [https://visualstudio.microsoft.com/zh-hans/downloads/#build-tools-for-visual-studio-2022](https://visualstudio.microsoft.com/zh-hans/downloads/#build-tools-for-visual-studio-2022)
2. 运行安装程序，勾选：
	- ✅ 使用 C++ 的桌面开发
		- ✅ Windows SDK（默认勾选）
		- ✅ MSVC v143 生成工具 ![image](https://p26-flow-imagex-sign.byteimg.com/labis/image/b64d815153152f96bdd80a193d7e84b5~tplv-a9rns2rl98-pc_smart_face_crop-v1:512:384.image?lk3s=8e244e95&rcl=202604242238422AAA3E20EF0C23E8E89B&rrcfp=cee388b0&x-expires=2092401531&x-signature=swvwWhTWULuGHm2qp4KfiuCODDM%3D)
3. 点击「安装」，完成后重启电脑。

### 2\. 安装 Rust（rustup + cargo）

打开 **PowerShell** （管理员 / 普通均可）：

```powershell
# 方式1：用 winget（推荐，Windows 11 自带）
winget install --id=Rustlang.Rustup

# 方式2：手动下载（备用）
# 64位：https://static.rust-lang.org/rustup/dist/x86_64-pc-windows-msvc/rustup-init.exe
# 双击运行，输入 1 回车（默认安装）
```

安装完成后， **重启终端** ，验证：

```powershell
rustc --version   # 编译器版本
cargo --version   # 包管理器版本
rustup --version  # 版本管理工具
```

### 3\. 配置国内镜像（加速）

新建 / 编辑 `~/.cargo/config.toml` （资源管理器地址栏输入 `%USERPROFILE%\.cargo` ）：

```toml
[source.crates-io]
registry = "https://github.com/rust-lang/crates.io-index"
replace-with = 'ustc'

[source.ustc]
registry = "git://mirrors.ustc.edu.cn/crates.io-index"

# 或用清华源
# [source.tuna]
# registry = "https://mirrors.tuna.tsinghua.edu.cn/git/crates.io-index.git"
```

---

## 二、Windows WSL2 环境（类 Linux，推荐跨平台）

### 1\. 安装 WSL2

PowerShell（管理员）：

```powershell
wsl --install
```

重启后按提示安装 Ubuntu，设置用户名密码。

### 2\. 在 WSL 内安装 Rust

打开 Ubuntu 终端：

```bash
sudo apt update && sudo apt install -y curl build-essential
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# 输入 1 回车，完成后重载环境
source $HOME/.cargo/env
```

验证：

```bash
rustc --version
cargo --version
```

镜像配置同 Windows，路径为 `~/.cargo/config.toml` 。

---

## 三、macOS / Linux

### 1\. 安装依赖

```bash
# macOS（先装 Xcode 命令行工具）
xcode-select --install

# Debian/Ubuntu
sudo apt update && sudo apt install -y curl build-essential

# CentOS/RHEL
sudo dnf install -y curl gcc
```

### 2\. 安装 Rust

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
```

验证同上。

---

## 四、VSCode 配置（推荐 IDE）

### 1\. 安装 VSCode

[https://code.visualstudio.com/](https://code.visualstudio.com/)

### 2\. 安装核心插件

- **rust-analyzer** （官方智能提示、补全、诊断）
- **CodeLLDB** （调试支持）
- **crates** （Cargo.toml 依赖管理）

### 3\. 常用设置（settings.json）

```json
{
  "rust-analyzer.checkOnSave.command": "clippy", // 保存时检查
  "rust-analyzer.cargo.allFeatures": true,       // 启用所有特性
  "editor.formatOnSave": true                      // 自动格式化
}
```

---

## 五、Hello World 验证

### 1\. 创建项目

```bash
cargo new hello-rust
cd hello-rust
```

### 2\. 编写代码（src/main.rs）

```rust
fn main() {
    println!("Hello, Rust! 🦀");
}
```

### 3\. 运行

```bash
cargo run
# 输出：Hello, Rust! 🦀
```

---

## 六、常用命令速查

```bash
rustup update          # 升级工具链
rustup target list      # 查看已安装编译目标
rustup target add x86_64-unknown-linux-gnu # 添加跨平台目标
cargo build             # 编译
cargo build --release   # 发布编译
cargo test              # 测试
cargo doc --open        # 生成并打开文档
```

---

## 七、常见问题

1. **linker 错误（Windows）** ：未安装 MSVC 构建工具，回到第一步安装。
2. **下载慢 / 超时** ：配置国内镜像（见上文）。
3. **rustup 命令找不到** ：重启终端，或手动添加 `~/.cargo/bin` 到环境变量。

---

需要我把上述步骤整理成一份可直接复制执行的 **一键安装脚本** （Windows PowerShell / WSL&macOS/Linux 两个版本）吗？

安装Rust时，选择64位还是32位？

如何配置Rust国内镜像？

如何使用Rust语言编写一个简单的“Hello World”程序？
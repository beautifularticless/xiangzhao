React Tauri项目创建

下面用 **Windows + PowerShell**、**Tauri 2.x + React + TypeScript** 给出从零到运行的完整步骤（含环境准备、创建、启动、目录说明）。
---

## 一、环境准备（必须先装）

### 1. 安装 Node.js（推荐 20+）

官网：https://nodejs.org/ 
安装后验证：

```powershell
node -v
npm -v
```

### 2. 安装 Rust（Tauri 后端依赖）

PowerShell 执行：

```powershell
winget install Rustlang.Rustup
# 或官方脚本（PowerShell）
irm https://sh.rustup.rs | iex
```

安装后**重启终端**，验证：

```powershell
rustc --version
cargo --version
```

### 3. Windows 额外依赖（VS Build Tools + WebView2）

- 安装 **Microsoft Visual Studio C++ Build Tools**（勾选“使用C++的桌面开发”）
- 安装 **WebView2 运行时**（一般系统已自带）

---

## 二、创建 React + Tauri 项目（官方脚手架）

### 1. 执行创建命令（任选其一）

```powershell
# npm（最通用）
npm create tauri-app@latest
# pnpm（推荐，更快）
pnpm create tauri-app
# yarn
yarn create tauri-app
```

### 2. 交互式配置（按下面选）

```
✔ Project name: my-tauri-react
✔ Identifier: com.example.myapp （发版后不可改，建议规范）
✔ Choose frontend: TypeScript / JavaScript
✔ Choose package manager: npm （或 pnpm）
✔ Choose UI template: React
✔ Choose UI flavor: TypeScript
```

等待依赖下载完成。
---

## 三、进入项目并安装依赖

```powershell
cd my-tauri-react
npm install
```

---

## 四、项目结构（关键目录）

```
my-tauri-react/
├── src/ # React 前端（TSX）
│ ├── App.tsx
│ └── main.tsx
├── src-tauri/ # Tauri 后端（Rust）
│ ├── src/
│ │ ├── main.rs # 入口
│ │ └── lib.rs # 核心逻辑
│ ├── Cargo.toml # Rust 依赖
│ └── tauri.conf.json # Tauri 配置（窗口、权限等）
└── package.json
```

---

## 五、启动开发环境

```powershell
npm run tauri dev
# 或
npx tauri dev
```

- 首次会编译 Rust（较慢）
- 成功后弹出桌面窗口，显示 React 页面
- 支持**热更新**：改 React 代码自动刷新；改 Rust 代码自动重编

---

## 六、构建生产安装包

```powershell
npm run tauri build
```

产物在 `src-tauri/target/release/bundle/`：

- Windows：`.msi` 安装包 + `.exe` 便携版

---

## 七、常用命令汇总

```powershell
# 开发
npm run tauri dev
# 构建
npm run tauri build
# 仅启动前端（单独调试 React）
npm run dev
```

---

## 八、常见问题

1. **Rust 下载慢**：换国内源（清华/中科大）
2. **Windows 编译报错**：确认已装 VS Build Tools
3. **端口占用**：改 `vite.config.ts` 或 `tauri.conf.json` 端口

---

要不要我把上述步骤整理成一份可直接复制执行的 **PowerShell 一键脚本**，并附上国内镜像配置，解决下载慢的问题？

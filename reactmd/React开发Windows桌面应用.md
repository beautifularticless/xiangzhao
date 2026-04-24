react Windows应用开发

在 Windows 平台上使用 React 开发应用，主流方案有两种： **React + Electron** （跨平台桌面应用）和 **React Native for Windows** （Windows 原生应用）。下面我会详细讲解这两种方案的实现方式、适用场景和核心代码示例。

## 一、方案 1：React + Electron（最常用）

Electron 是一个使用 JavaScript、HTML 和 CSS 构建跨平台桌面应用的框架，它将 Chromium 和 Node.js 嵌入到了一个二进制文件中，让你可以用 React 开发能运行在 Windows/macOS/Linux 上的桌面应用。

### 1\. 快速搭建项目

#### 步骤 1：创建 React 基础项目

bash

运行

```bash
# 创建 React 项目（使用 Vite 更轻量）
npm create vite@latest my-react-electron-app -- --template react
cd my-react-electron-app
npm install

# 安装 Electron 依赖
npm install electron electron-builder concurrently wait-on --save-dev
```

#### 步骤 2：配置 Electron 主进程文件

在项目根目录创建 `electron/main.js` （主进程，控制窗口生命周期）：

javascript

运行

```javascript
const { app, BrowserWindow } = require('electron');
const path = require('path');

// 保持窗口对象的全局引用，防止被垃圾回收
let mainWindow;

// 创建窗口函数
function createWindow() {
  mainWindow = new BrowserWindow({
    width: 800,
    height: 600,
    webPreferences: {
      nodeIntegration: true, // 允许渲染进程使用 Node.js
      contextIsolation: false, // 关闭上下文隔离（新手友好）
      preload: path.join(__dirname, 'preload.js') // 预加载脚本（可选）
    }
  });

  // 加载 React 应用
  // 开发环境加载本地服务，生产环境加载打包后的 index.html
  const startUrl = process.env.NODE_ENV === 'development'
    ? 'http://localhost:5173'
    : \`file://${path.join(__dirname, '../dist/index.html')}\`;
  
  mainWindow.loadURL(startUrl);

  // 打开开发者工具（开发环境）
  if (process.env.NODE_ENV === 'development') {
    mainWindow.webContents.openDevTools();
  }

  // 窗口关闭时的处理
  mainWindow.on('closed', () => {
    mainWindow = null;
  });
}

// Electron 应用就绪后创建窗口
app.whenReady().then(createWindow);

// 所有窗口关闭时退出应用（Windows/Linux）
app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

// macOS 点击 Dock 图标且无窗口时重新创建
app.on('activate', () => {
  if (BrowserWindow.getAllWindows().length === 0) {
    createWindow();
  }
});
```

#### 步骤 3：配置 package.json

修改 `package.json` ，添加 Electron 相关配置和脚本：

json

```json
{
  "name": "my-react-electron-app",
  "version": "0.1.0",
  "main": "electron/main.js", // 指定 Electron 主进程文件
  "scripts": {
    "dev:react": "vite", // 启动 React 开发服务
    "dev:electron": "electron .", // 启动 Electron
    "dev": "concurrently \"npm run dev:react\" \"wait-on http://localhost:5173 && npm run dev:electron\"", // 同时启动
    "build:react": "vite build", // 打包 React
    "build:electron": "electron-builder", // 打包 Electron
    "build": "npm run build:react && npm run build:electron" // 整体打包
  },
  "build": { // electron-builder 配置（Windows 打包）
    "appId": "com.example.react-electron",
    "win": {
      "target": [
        {
          "target": "nsis", // 生成 Windows 安装包
          "arch": ["x64", "ia32"] // 支持 64/32 位
        }
      ],
      "icon": "public/icon.ico" // Windows 应用图标
    },
    "directories": {
      "output": "dist-electron" // 打包输出目录
    }
  }
}
```

#### 步骤 4：运行和打包

bash

运行

```bash
# 启动开发环境（Windows 上实时调试）
npm run dev

# 打包成 Windows 可执行程序/安装包
npm run build
```

### 2\. 核心特性（Windows 适配）

- **窗口控制** ：可以通过 Electron API 实现最小化、最大化、关闭、置顶、自定义标题栏等 Windows 窗口特性。
- **系统集成** ：访问 Windows 系统托盘、文件系统、注册表、通知等（需 Node.js 权限）。
- **打包优化** ：生成 `.exe` 可执行文件或 `.msi` 安装包，支持自动更新。

## 二、方案 2：React Native for Windows（原生 Windows 应用）

React Native for Windows 是 React Native 的官方扩展，允许你用 React 语法开发真正的 Windows 原生应用（基于 UWP/Win32），性能比 Electron 更好，但生态不如 Electron 完善。

### 1\. 环境准备（Windows 专属）

- 安装 [Visual Studio 2022](https://visualstudio.microsoft.com/) （需勾选 “通用 Windows 平台开发” 和 “桌面开发使用 C++” 工作负载）。
- 安装 Node.js (16+)、Python 3.7+、Yarn。

### 2\. 快速搭建项目

bash

运行

```bash
# 安装 React Native 脚手架
npm install -g react-native-cli

# 创建 React Native 项目
npx react-native init MyRNWindowsApp
cd MyRNWindowsApp

# 安装 Windows 扩展
npx react-native-windows-init --overwrite

# 运行 Windows 应用
npx react-native run-windows
```

### 3\. 核心代码示例（Windows 页面）

修改 `App.js` ，添加 Windows 适配的 UI 组件：

jsx

```jsx
import React from 'react';
import { View, Text, StyleSheet, Button } from 'react-native';

const App = () => {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>React Native Windows 应用</Text>
      <Button 
        title="点击触发 Windows 原生提示" 
        onPress={() => {
          // 调用 Windows 原生 API（需原生模块扩展）
          alert('这是 Windows 原生弹窗！');
        }} 
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  title: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
});

export default App;
```

### 2\. 适用场景

- 追求原生性能、需要深度集成 Windows 系统功能（如触摸、笔输入、系统主题）。
- 开发面向 Windows 10/11 的 UWP 应用，可上架 Microsoft Store。

## 三、两种方案对比

表格

| 特性 | React + Electron | React Native for Windows |
| --- | --- | --- |
| 性能 | 中等（基于 Chromium） | 优秀（原生渲染） |
| 开发难度 | 低（Web 技术栈） | 中（需了解 Windows 原生开发） |
| 跨平台支持 | Windows/macOS/Linux | 仅 Windows（可配合 RN 支持 iOS） |
| 生态 / 社区 | 丰富 | 较有限 |
| 打包体积 | 较大（约 100MB+） | 较小（约 10MB+） |
| 适用场景 | 通用桌面应用、工具类应用 | 高性能 Windows 原生应用、Store 应用 |

---

### 总结

1. **快速开发跨平台桌面应用** ：优先选择 **React + Electron** ，学习成本低、生态完善，适合大多数 Windows 桌面应用场景。
2. **追求原生性能 / Windows 深度集成** ：选择 **React Native for Windows** ，但需要配置 Visual Studio 环境，且需适配 Windows 原生组件。
3. 核心关键：Electron 基于 Web 技术栈，开发体验和 React 网页开发一致；React Native for Windows 则是将 React 组件映射为 Windows 原生控件，性能更优但灵活性稍低。

如何在 React + Electron 中实现窗口间通信？

Electron 打包应用时如何配置图标和启动画面？

React Native for Windows 与 React + Electron 相比有哪些优缺点？
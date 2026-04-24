React 创建第一个项目

创建 React 第一个项目非常简单，React 官方推荐使用 `create-react-app` 脚手架（适用于新手），也可以使用更现代化的 Vite 工具（启动更快）。下面我会详细讲解两种方式，优先推荐新手从 `create-react-app` 入手。

### 一、前置条件（必须）

在开始前，你需要先安装：

1. **Node.js** （版本建议 14.0.0 及以上）：下载地址 [https://nodejs.org/](https://nodejs.org/)
2. 验证安装：打开终端 / 命令提示符，输入以下命令，能显示版本号即安装成功
	bash
	运行
	```bash
	node -v
	npm -v
	```

### 二、方式 1：使用 create-react-app（官方推荐，新手友好）

#### 步骤 1：创建项目

打开终端，执行以下命令（将 `my-first-react-app` 替换为你想要的项目名，不能有中文 / 空格）：

bash

运行

```bash
# 全局安装 create-react-app（如果没装过）
npm install -g create-react-app

# 创建项目
npx create-react-app my-first-react-app
```

#### 步骤 2：进入项目目录

bash

运行

```bash
cd my-first-react-app
```

#### 步骤 3：启动项目

bash

运行

```bash
npm start
```

执行后，浏览器会自动打开 `http://localhost:3000` ，看到 React 的默认欢迎页面，就说明项目创建并启动成功了！

#### 步骤 4：认识项目结构（核心文件）

plaintext

```
my-first-react-app/
├── node_modules/       # 项目依赖包（自动生成，不用改）
├── public/             # 静态资源（如 favicon、index.html）
├── src/                # 核心代码目录（重点关注）
│   ├── App.js          # 根组件（你主要写代码的地方）
│   ├── index.js        # 入口文件（渲染 App 到页面）
│   └── App.css         # App 组件的样式
├── package.json        # 项目配置和依赖清单
└── README.md           # 项目说明
```

#### 步骤 5：修改第一个组件（体验开发）

打开 `src/App.js` ，替换为以下代码：

jsx

```jsx
import './App.css';

function App() {
  return (
    <div className="App">
      <h1>我的第一个 React 项目！</h1>
      <p>Hello React 🚀</p>
    </div>
  );
}

export default App;
```

保存后，浏览器会 **自动刷新** ，就能看到你修改后的内容了。

### 三、方式 2：使用 Vite（现代化工具，启动更快）

如果觉得 `create-react-app` 启动慢，可以用 Vite：

#### 步骤 1：创建项目

bash

运行

```bash
# npm 方式
npm create vite@latest my-first-react-app -- --template react

# yarn 方式（如果用 yarn）
yarn create vite my-first-react-app --template react
```

#### 步骤 2：安装依赖并启动

bash

运行

```bash
# 进入目录
cd my-first-react-app

# 安装依赖
npm install

# 启动项目
npm run dev
```

启动后，终端会显示访问地址（如 `http://127.0.0.1:5173/` ），打开即可看到 React 页面。

### 四、停止项目

在终端中按下 `Ctrl + C` （Windows）/ `Command + C` （Mac），即可停止运行的 React 项目。

### 总结

1. 创建 React 项目的核心前提是安装 **Node.js** ，验证 `node -v` 和 `npm -v` 即可。
2. 新手优先用 `create-react-app` ： `npx create-react-app 项目名` → `cd 项目名` → `npm start` 。
3. 追求速度选 Vite： `npm create vite@latest 项目名 -- --template react` → 安装依赖 → `npm run dev` 。
4. 核心代码写在 `src/App.js` 中，修改后浏览器会自动刷新，无需手动重启项目。

如何在 React 项目中使用 TypeScript？

如何在 React 项目中使用 Redux？

如何在 React 项目中使用 React Router？
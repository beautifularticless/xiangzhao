React 项目的目录结构会根据脚手架（如 Create React App、Vite）和项目规模（小型 / 大型）有所差异，但核心目录的职责是相通的。我会先以最常用的 **Create React App (CRA)** 基础目录为例，再补充大型项目的进阶目录规范，帮你清晰理解每个目录 / 文件的作用。

### 一、基础版（Create React App 生成）

这是新手最常接触的目录结构，简洁且满足中小型项目需求：

plaintext

```
my-react-app/          # 项目根目录
├── node_modules/      # 项目依赖包（npm install 生成，无需手动修改）
├── public/            # 静态资源（不会被 Webpack 处理）
│   ├── favicon.ico    # 网站图标
│   ├── index.html     # 应用入口 HTML（唯一的 HTML 文件，React 挂载到这里）
│   ├── logo192.png    # PWA 相关图标
│   ├── logo512.png    # PWA 相关图标
│   ├── manifest.json  # PWA 配置文件
│   └── robots.txt     # 搜索引擎爬虫规则
├── src/               # 核心源码目录（99% 的开发工作在这里）
│   ├── App.css        # App 组件的样式文件
│   ├── App.js         # 根组件（项目的核心组件）
│   ├── App.test.js    # App 组件的测试文件（可选）
│   ├── index.css      # 全局样式文件
│   ├── index.js       # 入口 JS 文件（挂载 App 到 HTML 的 root 节点）
│   ├── logo.svg       # 示例图片资源
│   ├── reportWebVitals.js # 性能监控（可选）
│   └── setupTests.js  # 测试环境配置（可选）
├── .gitignore         # Git 忽略文件（如 node_modules、build 等）
├── package.json       # 项目配置（依赖、脚本命令、项目信息）
├── package-lock.json  # 依赖版本锁定（保证多人开发依赖一致）
└── README.md          # 项目说明文档
```

#### 核心目录 / 文件详解

1. **public/**
	- 存放「不会被 Webpack 编译处理」的静态资源，比如 HTML 模板、favicon、第三方 CDN 引入的脚本等。
	- 访问这里的资源时，直接用根路径（如 `/favicon.ico` ），无需相对路径。
	- 注意：如果把图片放在这里，React 中引用时需要写完整路径，且不会被压缩 / 优化，建议小体积、非业务图片放在这里（如图标）。
2. **src/**
	- 项目所有业务代码的核心目录，Webpack 会递归处理这里的文件（JS/JSX/CSS/ 图片等）。
	- `index.js` ：入口文件，核心逻辑是把 `App` 组件挂载到 `public/index.html` 的 `#root` 节点上，示例：
		jsx
		```jsx
		import React from 'react';
		import ReactDOM from 'react-dom/client';
		import './index.css';
		import App from './App';
		const root = ReactDOM.createRoot(document.getElementById('root'));
		root.render(<App />);
		```
	- `App.js` ：根组件，所有页面 / 子组件都嵌套在这个组件里，是业务逻辑的入口。
3. **package.json**
	- 核心配置文件，包含：
		- `scripts` ：启动 / 打包 / 测试命令（如 `npm start` 对应 `"start": "react-scripts start"` ）；
		- `dependencies` ：生产环境依赖（如 react、react-dom）；
		- `devDependencies` ：开发环境依赖（如 eslint、babel）。

### 二、进阶版（大型项目规范）

当项目规模扩大（多人协作、多页面、复杂状态管理），需要更清晰的目录划分，通常会在 `src/` 下新增以下目录：

plaintext

```
src/
├── assets/            # 静态资源（会被 Webpack 处理，如图片、字体、全局样式）
│   ├── images/        # 业务图片（如 banner、图标）
│   ├── fonts/         # 字体文件
│   └── styles/        # 全局样式（如 reset.css、变量.scss）
├── components/        # 通用公共组件（可复用，如 Button、Card、Modal）
│   ├── Button/        # 组件目录（一个组件一个文件夹，包含 jsx、css、index.js）
│   │   ├── Button.jsx
│   │   ├── Button.css
│   │   └── index.js   # 导出组件，方便外部引用
│   └── Card/
├── pages/             # 页面组件（路由对应的页面，如首页、详情页）
│   ├── Home/          # 首页
│   │   ├── Home.jsx
│   │   ├── Home.css
│   │   └── index.js
│   └── Detail/
├── router/            # 路由配置（集中管理路由，如 router.js）
├── store/             # 状态管理（如 Redux、MobX、Zustand 相关文件）
│   ├── slices/        # Redux Toolkit 的切片
│   └── index.js       # 配置 store
├── utils/             # 工具函数（通用方法，如请求封装、时间格式化、防抖节流）
│   ├── request.js     # axios 封装
│   └── formatTime.js
├── hooks/             # 自定义 Hooks（如 useRequest、useScroll）
├── api/               # 接口请求（集中管理 API 地址和请求函数）
│   ├── home.js        # 首页相关接口
│   └── user.js        # 用户相关接口
└── constants/         # 常量定义（如接口地址、枚举值、全局变量）
```

#### 关键目录说明

1. **components/ vs pages/**
	- `components/` ：通用组件（无路由关联，可在多个页面复用，如按钮、弹窗）；
	- `pages/` ：页面组件（与路由一一对应，包含完整的页面逻辑，如首页、个人中心）。
2. **assets/ vs public/**
	- `assets/` ：业务相关的静态资源（会被 Webpack 处理，比如图片会被优化、重命名，样式会被编译）；
	- `public/` ：纯静态资源（不参与编译，如 HTML 模板、第三方脚本）。
3. **api/ + utils/request.js**
	- 集中管理接口，避免散落在各个组件中，示例：
		js
		```js
		// utils/request.js（axios 封装）
		import axios from 'axios';
		const request = axios.create({
		  baseURL: process.env.REACT_APP_API_BASE_URL,
		  timeout: 5000
		});
		// 请求/响应拦截器（统一处理 token、错误提示）
		export default request;
		// api/home.js
		import request from '../utils/request';
		export const getHomeData = () => request.get('/api/home');
		```

### 总结

1. **核心目录** ： `public/` （静态 HTML / 图标）、 `src/` （业务源码）、 `node_modules/` （依赖）是所有 React 项目的基础， `src/index.js` 是入口， `src/App.js` 是根组件。
2. **基础 vs 进阶** ：小型项目用 CRA 原生目录即可，大型项目需新增 `components/` （公共组件）、 `pages/` （页面）、 `api/` （接口）、 `utils/` （工具）等目录，提升可维护性。
3. **资源区分** ： `public/` 存放不编译的静态资源， `src/assets/` 存放需 Webpack 处理的业务资源。

如何在 React 项目中使用 PWA？

如何在 React 项目中进行性能优化？

如何在 React 项目中进行测试？
React 热更新

React 的热更新（Hot Module Replacement，简称 HMR）是开发过程中非常实用的功能，它能在不刷新整个页面的前提下，实时更新修改后的组件代码，保留页面当前的状态，极大提升开发效率。

### 一、主流实现方案

目前 React 项目实现热更新主要有两种方式，对应不同的项目脚手架：

#### 1\. Create React App (CRA) 项目（零配置）

CRA 已经内置了热更新功能， **无需手动配置** ，默认开启。

- 启动项目： `npm start` 或 `yarn start`
- 修改组件代码后，页面会自动更新，且大部分场景下会保留组件状态

如果热更新失效，可检查：

jsx

```jsx
// src/index.js 确保有以下代码（CRA 已默认配置）
import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import App from './App';

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);

// CRA 会自动注入热更新逻辑，无需手动写 module.hot.accept
```

#### 2\. 自定义 Webpack 配置的项目（手动配置）

如果是自己搭建的 Webpack + React 项目，需要手动配置 HMR：

##### 步骤 1：安装依赖

bash

运行

```bash
# 核心依赖
npm install react-hot-loader @pmmmwh/react-refresh-webpack-plugin react-refresh --save-dev
# 或 yarn
yarn add react-hot-loader @pmmmwh/react-refresh-webpack-plugin react-refresh -D
```

##### 步骤 2：配置 Webpack（webpack.config.js）

javascript

运行

```javascript
const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const ReactRefreshWebpackPlugin = require('@pmmmwh/react-refresh-webpack-plugin');
const webpack = require('webpack');

module.exports = {
  mode: 'development', // 仅在开发环境开启热更新
  entry: './src/index.js',
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'dist'),
    clean: true,
  },
  devServer: {
    static: path.join(__dirname, 'dist'),
    hot: true, // 开启热更新
    open: true, // 自动打开浏览器
    client: {
      overlay: true, // 错误浮层提示
    },
  },
  module: {
    rules: [
      {
        test: /\.(js|jsx)$/,
        exclude: /node_modules/,
        use: [
          {
            loader: 'babel-loader',
            options: {
              presets: ['@babel/preset-env', '@babel/preset-react'],
              plugins: [
                // 启用 React 热更新插件
                require.resolve('react-refresh/babel'),
              ],
            },
          },
        ],
      },
    ],
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: './public/index.html',
    }),
    // 启用 React 热更新插件
    new ReactRefreshWebpackPlugin(),
    // 启用 Webpack 热更新
    new webpack.HotModuleReplacementPlugin(),
  ],
  resolve: {
    extensions: ['.js', '.jsx'],
  },
};
```

##### 步骤 3：配置入口文件（src/index.js）

jsx

```jsx
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';

const root = ReactDOM.createRoot(document.getElementById('root'));
function renderApp() {
  root.render(<App />);
}

// 首次渲染
renderApp();

// 监听模块更新，触发重新渲染（保留状态）
if (module.hot) {
  module.hot.accept('./App', () => {
    renderApp();
  });
}
```

### 二、关键注意事项

1. **仅用于开发环境** ：热更新是开发辅助功能，生产环境需禁用（Webpack 生产模式会自动忽略 HMR 相关配置）。
2. **状态保留限制** ：
	- 函数组件的 `useState` / `useReducer` 状态可保留；
	- 类组件的 state 也可保留，但建议优先使用函数组件；
	- 全局变量 / 第三方库修改不会触发热更新，需手动刷新。
3. **常见问题排查** ：
	- 热更新不生效：检查 `devServer.hot` 是否为 `true` ，Babel 插件是否配置正确；
	- 页面刷新而非热更新：检查是否修改了入口文件或根组件的核心逻辑，部分修改仍需刷新页面。

### 总结

1. React 热更新（HMR）核心是在不刷新页面的前提下更新组件代码，保留页面状态，提升开发效率；
2. CRA 项目默认内置热更新，自定义 Webpack 项目需安装 `react-refresh` 相关依赖并配置 Webpack/Babel；
3. 热更新仅用于开发环境，生产环境需禁用，且部分场景（如全局变量修改）仍需手动刷新页面。

如何在 React 项目中使用 HMR？

热更新可能会导致哪些问题？

除了 React，还有哪些框架支持热更新？
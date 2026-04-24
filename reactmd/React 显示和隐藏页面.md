react 显示和隐藏页面

在 React 中实现页面（组件）的显示和隐藏，核心思路是通过 **条件渲染** 控制组件的挂载 / 卸载或样式显隐。下面我会提供两种最常用、最符合 React 最佳实践的方案，你可以根据场景选择。

### 方案 1：条件渲染（完全挂载 / 卸载组件）

这是 React 官方推荐的方式，通过 `if/else` 或三元表达式控制组件是否渲染，适合需要完全销毁 / 重建组件的场景（比如重置组件状态）。

#### 完整代码示例

### 方案 2：样式控制（仅隐藏，组件仍挂载）

通过 CSS 的 `display: none` 或 `visibility: hidden` 控制显隐，组件仍保留在 DOM 中（状态不会丢失），适合需要快速切换、保留组件状态的场景。

#### 完整代码示例

jsx

```jsx
import { useState } from 'react';

const AboutPage = () => {
  // 模拟组件内部状态（样式隐藏时状态不会丢失）
  const [count, setCount] = useState(0);

  return (
    <div className="page">
      <h1>关于页</h1>
      <p>点击次数：{count}</p>
      <button onClick={() => setCount(count + 1)}>点击+1</button>
    </div>
  );
};

function App() {
  const [isShowAbout, setIsShowAbout] = useState(true);

  const toggleAbout = () => {
    setIsShowAbout(!isShowAbout);
  };

  return (
    <div className="app">
      <button onClick={toggleAbout}>
        {isShowAbout ? '隐藏关于页' : '显示关于页'}
      </button>

      {/* 核心：通过样式控制显隐 */}
      <div style={{ display: isShowAbout ? 'block' : 'none' }}>
        <AboutPage />
      </div>
    </div>
  );
}

export default App;
```

### 补充：路由级别的页面显隐（多页面场景）

如果是 **不同路由页面** 的切换（比如首页 / 详情页 / 个人中心），推荐使用 React Router 实现 “显隐”（本质是路由切换）：

#### 前置依赖

bash

运行

```bash
npm install react-router-dom
```

#### 代码示例

### 关键代码解释

1. **状态管理** ： `useState` 定义布尔值状态（如 `isShowHome` ），控制显隐逻辑；
2. **条件渲染** ： `{isShowHome && <HomePage />}` 是简洁写法，状态为 `true` 时渲染组件；
3. **样式控制** ： `style={{ display: isShow ? 'block' : 'none' }}` 通过内联样式隐藏，组件仍在 DOM 中；
4. **路由切换** ：React Router 通过 `Route` 匹配路径，只渲染对应路径的页面组件。

### 总结

1. **简单组件显隐** ：优先用 **条件渲染** （完全挂载 / 卸载），需要保留状态则用 **样式控制** ；
2. **多页面路由场景** ：用 React Router 实现页面切换，这是最符合用户习惯的方式；
3. **核心区别** ：条件渲染会销毁 / 重建组件（状态重置），样式控制仅隐藏（状态保留），根据需求选择。

除了上述两种方案，还有其他方法可以实现 React 页面的显示和隐藏吗？

在 React 中，如何使用 CSS 类名来控制组件的显示和隐藏？

如何在 React 中实现页面的平滑过渡效果？
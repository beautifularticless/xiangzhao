React 路由

React 路由是 React 生态中用于实现 **单页应用 (SPA)** 页面跳转和路由管理的核心方案，最常用的是 `react-router-dom` （适用于 Web 端）。下面我会从基础到实战，帮你全面理解和使用 React 路由。

### 一、核心概念（新手必懂）

先理解几个关键术语，避免后续混淆：

- **路由（Route）** ：URL 路径与组件的映射关系（比如 `/home` 对应 `<Home />` 组件）。
- **单页应用（SPA）** ：整个应用只有一个 HTML 文件，页面切换通过 JS 动态替换组件实现，无页面刷新。
- **react-router-dom** ：React 官方推荐的路由库，v6 是目前的主流版本（与 v5 有较大差异）。

### 二、快速上手（v6 版本）

#### 1\. 安装依赖

首先在 React 项目中安装 `react-router-dom` ：

bash

运行

```bash
# npm 安装
npm install react-router-dom

# yarn 安装
yarn add react-router-dom
```

#### 2\. 基础使用示例（完整代码）

下面是一个最基础的路由配置示例，包含首页、关于页、404 页的跳转：

jsx

```jsx
// src/App.js
import { BrowserRouter, Routes, Route, Link, Navigate } from 'react-router-dom';

// 定义页面组件
const Home = () => <h1>首页</h1>;
const About = () => <h1>关于我们</h1>;
const NotFound = () => <h1>404 页面不存在</h1>;

function App() {
  return (
    {/* 路由容器：整个应用的路由根节点（必须包裹所有路由相关组件） */}
    <BrowserRouter>
      {/* 导航栏：Link 替代 a 标签，避免页面刷新 */}
      <nav style={{ margin: '10px 0' }}>
        <Link to="/" style={{ marginRight: '10px' }}>首页</Link>
        <Link to="/about" style={{ marginRight: '10px' }}>关于</Link>
      </nav>

      {/* 路由规则：Routes 替代 v5 的 Switch，只能包含 Route/Navigate */}
      <Routes>
        {/* 首页路由：path 是 URL 路径，element 是要渲染的组件 */}
        <Route path="/" element={<Home />} />
        {/* 关于页路由 */}
        <Route path="/about" element={<About />} />
        {/* 重定向：将 /home 重定向到 / */}
        <Route path="/home" element={<Navigate to="/" />} />
        {/* 404 路由：path="*" 匹配所有未定义的路径 */}
        <Route path="*" element={<NotFound />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
```

#### 3\. 代码关键解释

- **BrowserRouter** ：基于 HTML5 History API 的路由模式（URL 无 `#` ），是整个路由的 “容器”，必须放在最外层。
- **Link** ：替代原生 `<a>` 标签，实现无刷新跳转， `to` 属性指定目标路径。
- **Routes & Route** ： `Routes` 包裹所有 `Route` ，匹配到第一个符合的 `Route` 后停止（类似 v5 的 `Switch` ）； `Route` 的 `path` 是路径， `element` 是要渲染的组件。
- **Navigate** ：实现路由重定向（比如 `/home` 跳转到 `/` ）， `to` 属性指定目标路径。

### 三、进阶用法（常用场景）

#### 1\. 动态路由（参数传递）

比如用户详情页 `/user/123` ，其中 `123` 是用户 ID，通过 `useParams` 获取参数：

jsx

```jsx
// 1. 定义动态路由
<Route path="/user/:id" element={<UserDetail />} />

// 2. 接收参数的组件 UserDetail.js
import { useParams } from 'react-router-dom';

const UserDetail = () => {
  // 获取路由参数：{ id: '123' }
  const { id } = useParams();
  return <h1>用户 ID：{id}</h1>;
};

export default UserDetail;
```

#### 2\. 嵌套路由（子路由）

比如后台管理系统，主布局包含侧边栏和内容区，内容区根据子路由切换：

jsx

```jsx
// 1. 主布局组件 Layout.js
import { Outlet, Link } from 'react-router-dom';

const Layout = () => {
  return (
    <div style={{ display: 'flex' }}>
      {/* 侧边栏导航 */}
      <aside style={{ width: '200px', borderRight: '1px solid #ccc' }}>
        <Link to="/dashboard" style={{ display: 'block', margin: '10px' }}>仪表盘</Link>
        <Link to="/dashboard/setting" style={{ display: 'block', margin: '10px' }}>设置</Link>
      </aside>
      {/* 子路由渲染位置：Outlet 是子路由的“占位符” */}
      <main style={{ flex: 1, padding: '20px' }}>
        <Outlet />
      </main>
    </div>
  );
};

export default Layout;

// 2. 配置嵌套路由（App.js）
import Layout from './Layout';
const Dashboard = () => <h2>仪表盘首页</h2>;
const Setting = () => <h2>系统设置</h2>;

<Routes>
  {/* 嵌套路由：path 以 /dashboard 开头，element 是主布局 */}
  <Route path="/dashboard" element={<Layout />}>
    {/* 子路由：默认子路由（path=""），匹配 /dashboard 时渲染 */}
    <Route index element={<Dashboard />} />
    {/* 子路由：匹配 /dashboard/setting 时渲染 */}
    <Route path="setting" element={<Setting />} />
  </Route>
</Routes>
```

#### 3\. 编程式导航（通过 JS 跳转）

#### 4\. 路由守卫（权限控制）

比如未登录用户无法访问个人中心，通过自定义组件实现权限校验：

### 四、常见问题

1. **v6 与 v5 的主要区别** ：
	- v6 移除了 `Switch` ，改用 `Routes` ；
	- v6 的 `Route` 必须放在 `Routes` 中， `element` 替代 `component/render` ；
	- v6 移除了 `useHistory` ，改用 `useNavigate` ；
	- 嵌套路由推荐用 `Outlet` ，而非手动拼接路径。
2. **HashRouter vs BrowserRouter** ：
	- `BrowserRouter` ：URL 无 `#` ，依赖后端配置（需配置所有路由指向 index.html）；
	- `HashRouter` ：URL 带 `#` （如 `/#/home` ），无需后端配置，适合静态部署。

### 总结

1. React 路由核心是 `react-router-dom` （v6 为主流），通过 `BrowserRouter` 包裹、 `Routes/Route` 配置路径与组件的映射， `Link` 实现跳转。
2. 常用功能：动态路由（ `useParams` ）、嵌套路由（ `Outlet` ）、编程式导航（ `useNavigate` ）、权限控制（自定义守卫组件）。
3. 单页应用的路由切换本质是 JS 动态替换组件，无页面刷新，这是 React 路由的核心优势。

如何在 React 路由中传递参数？

React 路由的嵌套路由是怎么实现的？

如何在 React 路由中进行路由守卫？
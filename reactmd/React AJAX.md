React AJAX

在 React 中进行 AJAX（异步数据请求）是开发中最常见的需求之一，React 本身并没有内置的 AJAX 功能，通常我们会结合第三方库（如 `axios` ）或浏览器原生的 `fetch API` 来实现。下面我会从基础到实战，带你全面理解 React 中的 AJAX 用法。

### 一、核心实现方式

#### 1\. 基础准备：安装常用请求库（axios）

`axios` 是目前 React 项目中最主流的 AJAX 库，相比原生 `fetch` 更易用（自带请求 / 响应拦截、自动解析 JSON、兼容低版本浏览器）。

bash

运行

```bash
# 安装 axios
npm install axios
# 或
yarn add axios
```

#### 2\. 函数组件中使用 AJAX（最常用）

在函数组件中，AJAX 请求通常结合 `useEffect` 钩子（模拟生命周期）来触发，避免组件渲染时重复请求。

jsx

```jsx
import React, { useState, useEffect } from 'react';
import axios from 'axios';

function UserList() {
  // 定义状态存储请求结果、加载状态、错误信息
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // 发起 AJAX 请求
  useEffect(() => {
    // 定义异步请求函数
    const fetchUsers = async () => {
      try {
        // 发起 GET 请求（示例接口：获取用户列表）
        const response = await axios.get('https://jsonplaceholder.typicode.com/users');
        // 成功：更新数据，关闭加载状态
        setUsers(response.data);
        setLoading(false);
      } catch (err) {
        // 失败：记录错误，关闭加载状态
        setError('请求失败：' + err.message);
        setLoading(false);
      }
    };

    // 执行请求
    fetchUsers();

    // 清理函数（可选，取消未完成的请求，避免内存泄漏）
    return () => {
      // 创建取消令牌（axios 专属）
      const CancelToken = axios.CancelToken;
      const source = CancelToken.source();
      source.cancel('组件卸载，取消请求');
    };
  }, []); // 空依赖数组：仅在组件挂载时执行一次

  // 渲染不同状态
  if (loading) return <div>加载中...</div>;
  if (error) return <div>{error}</div>;

  return (
    <div>
      <h2>用户列表</h2>
      <ul>
        {users.map(user => (
          <li key={user.id}>{user.name} - {user.email}</li>
        ))}
      </ul>
    </div>
  );
}

export default UserList;
```

#### 3\. 类组件中使用 AJAX（兼容旧项目）

类组件中通常在 `componentDidMount` 生命周期中发起请求，在 `componentWillUnmount` 中取消请求。

jsx

```jsx
import React, { Component } from 'react';
import axios from 'axios';

class UserList extends Component {
  state = {
    users: [],
    loading: true,
    error: null
  };

  // 存储取消请求的令牌
  cancelTokenSource = axios.CancelToken.source();

  componentDidMount() {
    // 发起请求
    axios.get('https://jsonplaceholder.typicode.com/users', {
      cancelToken: this.cancelTokenSource.token // 绑定取消令牌
    })
    .then(response => {
      this.setState({ users: response.data, loading: false });
    })
    .catch(err => {
      // 排除手动取消的情况
      if (!axios.isCancel(err)) {
        this.setState({ error: '请求失败：' + err.message, loading: false });
      }
    });
  }

  componentWillUnmount() {
    // 组件卸载时取消请求，避免内存泄漏
    this.cancelTokenSource.cancel('组件卸载，取消请求');
  }

  render() {
    const { loading, error, users } = this.state;
    if (loading) return <div>加载中...</div>;
    if (error) return <div>{error}</div>;

    return (
      <div>
        <h2>用户列表</h2>
        <ul>
          {users.map(user => (
            <li key={user.id}>{user.name} - {user.email}</li>
          ))}
        </ul>
      </div>
    );
  }
}

export default UserList;
```

#### 4\. 原生 fetch API（无需安装依赖）

如果不想引入第三方库，可使用浏览器原生的 `fetch` ，但需要手动处理 JSON 解析和错误。

jsx

```jsx
import React, { useState, useEffect } from 'react';

function UserList() {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchUsers = async () => {
      try {
        const response = await fetch('https://jsonplaceholder.typicode.com/users');
        // fetch 不会把 4xx/5xx 状态码视为错误，需手动判断
        if (!response.ok) {
          throw new Error(\`HTTP 错误：${response.status}\`);
        }
        const data = await response.json(); // 手动解析 JSON
        setUsers(data);
        setLoading(false);
      } catch (err) {
        setError('请求失败：' + err.message);
        setLoading(false);
      }
    };

    fetchUsers();
  }, []);

  // 渲染逻辑和之前一致
  if (loading) return <div>加载中...</div>;
  if (error) return <div>{error}</div>;

  return (
    <div>
      <h2>用户列表</h2>
      <ul>
        {users.map(user => (
          <li key={user.id}>{user.name} - {user.email}</li>
        ))}
      </ul>
    </div>
  );
}

export default UserList;
```

### 二、关键注意事项

1. **避免重复请求** ： `useEffect` 的依赖数组要合理设置（空数组仅挂载时请求，依赖变量变化时重新请求）。
2. **取消未完成的请求** ：组件卸载前取消请求，避免 “更新已卸载组件的状态” 错误。
3. **错误处理** ：必须捕获请求异常，避免页面崩溃，同时给用户友好提示。
4. **加载状态** ：请求过程中显示加载动画 / 文字，提升用户体验。
5. **跨域问题** ：开发中若遇到跨域，需在后端配置 CORS，或在前端用代理（如 React 脚手架的 `setupProxy.js` ）。

### 总结

1. React 中实现 AJAX 首选 `axios` （易用、功能全），也可使用原生 `fetch` （无需依赖）。
2. 函数组件中结合 `useEffect` 触发请求，类组件中用 `componentDidMount` ，且都需处理取消请求和错误。
3. 核心要点：控制加载状态、捕获请求错误、避免重复请求、处理跨域问题。
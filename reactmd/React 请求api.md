react 请求api

在 React 中请求 API 是前端开发的核心场景之一。我会为你介绍几种最常用、最符合现代 React 开发最佳实践的方式，从基础到进阶逐步讲解。

### 一、基础方案：使用 Fetch API（原生）

Fetch 是浏览器内置的 API，无需安装额外依赖，适合简单的请求场景。

#### 1\. 函数组件中使用（结合 useEffect）

jsx

```jsx
import { useState, useEffect } from 'react';

function ApiFetchExample() {
  // 定义状态存储数据、加载状态和错误信息
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // 发送 API 请求的逻辑
  useEffect(() => {
    // 定义异步函数（useEffect 回调不能直接是 async）
    const fetchData = async () => {
      try {
        // 发送 GET 请求
        const response = await fetch('https://jsonplaceholder.typicode.com/posts/1');
        
        // 检查响应是否成功（status 200-299）
        if (!response.ok) {
          throw new Error(\`请求失败: ${response.status}\`);
        }

        // 解析 JSON 数据
        const result = await response.json();
        setData(result); // 存储数据
      } catch (err) {
        setError(err.message); // 捕获并存储错误
      } finally {
        setLoading(false); // 无论成功/失败，结束加载状态
      }
    };

    fetchData();

    // 清理函数（可选，比如组件卸载时取消请求）
    return () => {
      // 可在这里处理请求取消逻辑
    };
  }, []); // 空依赖数组：仅组件挂载时执行一次

  // 渲染不同状态
  if (loading) return <div>加载中...</div>;
  if (error) return <div>错误: {error}</div>;

  return (
    <div>
      <h2>{data?.title}</h2>
      <p>{data?.body}</p>
    </div>
  );
}

export default ApiFetchExample;
```

#### 2\. POST 请求示例

### 二、进阶方案：使用 Axios（推荐）

Axios 是一个流行的 HTTP 客户端库，相比 Fetch 有更简洁的 API、内置的错误处理、请求 / 响应拦截器等优势。

#### 1\. 安装 Axios

bash

运行

```bash
npm install axios
# 或
yarn add axios
```

#### 2\. 基础使用示例

jsx

```jsx
import { useState, useEffect } from 'react';
import axios from 'axios';

function AxiosExample() {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    // 发送 GET 请求
    axios.get('https://jsonplaceholder.typicode.com/posts/1')
      .then((response) => {
        // Axios 自动解析 JSON，数据在 response.data 中
        setData(response.data);
      })
      .catch((err) => {
        // 捕获所有错误（网络错误、状态码非 2xx 等）
        setError(err.message || '请求失败');
      })
      .finally(() => {
        setLoading(false);
      });

    // 组件卸载时取消请求（防止内存泄漏）
    const source = axios.CancelToken.source();
    return () => {
      source.cancel('组件卸载，取消请求');
    };
  }, []);

  if (loading) return <div>加载中...</div>;
  if (error) return <div>错误: {error}</div>;

  return (
    <div>
      <h2>{data.title}</h2>
      <p>{data.body}</p>
    </div>
  );
}

export default AxiosExample;
```

#### 3\. Axios 封装（最佳实践）

为了避免重复代码，通常会封装 Axios 实例：

#### 4\. 使用封装后的 Axios

jsx

```jsx
import { useState, useEffect } from 'react';
import request from './utils/request';

function EncapsulatedAxiosExample() {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    request.get('/posts/1')
      .then((result) => {
        setData(result);
      })
      .catch((err) => {
        setError(err.message);
      })
      .finally(() => {
        setLoading(false);
      });
  }, []);

  // 渲染逻辑和之前一致
  if (loading) return <div>加载中...</div>;
  if (error) return <div>错误: {error}</div>;

  return (
    <div>
      <h2>{data.title}</h2>
      <p>{data.body}</p>
    </div>
  );
}

export default EncapsulatedAxiosExample;
```

### 三、React 18+ 新方案：使用 useTransition（处理慢速请求）

如果请求耗时较长，可结合 `useTransition` 避免页面卡顿：

jsx

```jsx
import { useState, useEffect, useTransition } from 'react';
import request from './utils/request';

function UseTransitionExample() {
  const [data, setData] = useState(null);
  const [isPending, startTransition] = useTransition();

  useEffect(() => {
    // 用 startTransition 包裹耗时操作，不阻塞 UI
    startTransition(async () => {
      const result = await request.get('/posts/1');
      setData(result);
    });
  }, []);

  if (isPending) return <div>加载中...</div>;

  return <div>{data?.title}</div>;
}

export default UseTransitionExample;
```

### 总结

1. **基础场景** ：使用浏览器原生 `fetch` ，无需安装依赖，但需手动处理状态码、解析 JSON。
2. **推荐方案** ：使用 `axios` ，封装实例后可统一处理请求头、拦截器、错误，代码更简洁。
3. **核心要点** ：
	- 结合 `useEffect` 发送请求（避免组件渲染时重复请求）；
	- 始终处理 `loading` 、 `error` 状态，提升用户体验；
	- 组件卸载时取消请求，防止内存泄漏。

在 React 中如何处理 API 请求错误？

除了 Fetch API，还有哪些常用的 React 请求 API 的方法？

在 React 中如何进行分页请求？
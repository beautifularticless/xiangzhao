React Hooks

React Hooks 是 React 16.8 版本引入的新特性，它让你 **无需编写类组件** 就能使用状态（state）、生命周期等 React 核心功能，让函数组件的能力和类组件持平，同时让代码逻辑更清晰、复用性更高。

### 一、核心 Hooks 详解（从基础到常用）

我会用「定义 + 代码示例 + 核心说明」的方式，帮你快速理解最常用的 Hooks。

#### 1\. useState：给函数组件添加状态

**作用** ：在函数组件中创建并管理状态变量，替代类组件的 `this.state` 。 **语法** ： `const [状态变量, 修改状态的函数] = useState(初始值)`

jsx

```jsx
import { useState } from 'react';

function Counter() {
  // 定义状态：count 是状态值，setCount 是修改 count 的函数，初始值为 0
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>当前计数：{count}</p>
      {/* 点击按钮修改状态，注意：修改函数是异步的 */}
      <button onClick={() => setCount(count + 1)}>加1</button>
      <button onClick={() => setCount(count - 1)}>减1</button>
    </div>
  );
}
```

**核心说明** ：

- 初始值可以是任意类型（数字、字符串、对象、数组等）；
- 修改状态的函数（如 `setCount` ）不会直接修改原状态，而是生成新状态，触发组件重新渲染；
- 如果初始值是复杂计算（比如从接口获取），可以传一个函数： `useState(() => 复杂计算逻辑)` ，避免每次渲染都执行计算。

#### 2\. useEffect：处理副作用

**作用** ：替代类组件的生命周期（ `componentDidMount` 、 `componentDidUpdate` 、 `componentWillUnmount` ），处理「副作用」（比如请求数据、操作 DOM、订阅事件）。 **语法** ： `useEffect(副作用函数, 依赖数组)`

jsx

```jsx
import { useState, useEffect } from 'react';

function UserInfo() {
  const [user, setUser] = useState(null);

  // 副作用函数：模拟请求用户数据
  useEffect(() => {
    // 1. 组件挂载时执行（类似 componentDidMount）
    const fetchUser = async () => {
      const res = await fetch('https://jsonplaceholder.typicode.com/users/1');
      const data = await res.json();
      setUser(data);
    };
    fetchUser();

    // 2. 组件卸载时执行（类似 componentWillUnmount）：清理副作用
    return () => {
      console.log('组件卸载，清理资源（比如取消请求、解绑事件）');
    };
  }, []); // 依赖数组为空：仅在组件挂载/卸载时执行

  if (!user) return <div>加载中...</div>;
  return <div>用户名：{user.name}</div>;
}
```

**核心说明** ：

- 依赖数组决定副作用的执行时机：
	- 不传依赖：每次组件渲染都执行；
	- 空数组 `[]` ：仅组件挂载时执行 1 次；
	- 传具体值（如 `[count]` ）：仅当 `count` 变化时执行；
- 副作用函数可以返回一个「清理函数」，用于卸载组件时清理资源（比如取消定时器、解绑事件）。

#### 3\. useContext：跨组件共享状态

**作用** ：无需通过「props 层层传递」，直接在任意子组件中获取父组件（或全局）的状态，解决「props 透传」问题。 **步骤** ：① 创建 Context → ② 用 Provider 提供状态 → ③ 用 useContext 获取状态

#### 4\. useRef：获取 DOM 或保存可变值

**作用** ：有两个核心用途：

- 获取 DOM 元素（替代类组件的 `this.refs` ）；
- 保存一个「跨渲染周期」的可变值（修改它不会触发组件重新渲染）。

jsx

```jsx
import { useRef, useEffect } from 'react';

function InputFocus() {
  // 1. 创建 ref 对象
  const inputRef = useRef(null);

  // 2. 组件挂载时，让输入框自动聚焦（获取 DOM）
  useEffect(() => {
    inputRef.current.focus();
  }, []);

  // 3. 保存跨渲染的可变值（修改不会触发渲染）
  const countRef = useRef(0);
  const handleClick = () => {
    countRef.current += 1;
    console.log('点击次数：', countRef.current); // 数值变，但组件不重新渲染
  };

  return (
    <div>
      <input ref={inputRef} type="text" placeholder="自动聚焦" />
      <button onClick={handleClick}>点击计数（不渲染）</button>
    </div>
  );
}
```

### 二、自定义 Hooks（Hooks 的核心价值：逻辑复用）

自定义 Hooks 是 **以 `use` 开头的函数** ，可以封装通用的逻辑（比如请求数据、监听滚动、防抖等），让逻辑在多个组件中复用。

**示例：封装一个通用的「请求数据」Hook**

jsx

```jsx
import { useState, useEffect } from 'react';

// 自定义 Hook：封装请求逻辑
function useFetch(url) {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    // 定义异步请求函数
    const fetchData = async () => {
      try {
        setLoading(true);
        const res = await fetch(url);
        if (!res.ok) throw new Error('请求失败');
        const result = await res.json();
        setData(result);
        setError(null);
      } catch (err) {
        setError(err.message);
        setData(null);
      } finally {
        setLoading(false);
      }
    };

    fetchData();

    // 清理函数：取消请求（避免组件卸载后 setState）
    return () => {
      const controller = new AbortController();
      controller.abort();
    };
  }, [url]); // 仅当 url 变化时重新请求

  // 返回需要的状态，供组件使用
  return { data, loading, error };
}

// 使用自定义 Hook
function UserList() {
  const { data: users, loading, error } = useFetch('https://jsonplaceholder.typicode.com/users');

  if (loading) return <div>加载中...</div>;
  if (error) return <div>错误：{error}</div>;

  return (
    <ul>
      {users.map(user => (
        <li key={user.id}>{user.name}</li>
      ))}
    </ul>
  );
}
```

### 三、使用 Hooks 的核心规则

1. **只能在函数组件 / 自定义 Hook 中使用** ：不能在类组件、普通函数、条件 / 循环语句中调用 Hooks；
2. **只能在顶层调用** ：Hooks 必须写在函数组件的最外层，不能嵌套在 `if` 、 `for` 、 `useEffect` 等内部；
3. **自定义 Hook 必须以 `use` 开头** ：比如 `useFetch` 、 `useTheme` ，这样 React 才能检测到它遵循 Hooks 规则。

### 总结

1. **核心 Hooks** ： `useState` 管理状态、 `useEffect` 处理副作用、 `useContext` 跨组件传值、 `useRef` 操作 DOM / 保存可变值；
2. **自定义 Hooks** ：以 `use` 开头，是复用组件逻辑的最佳方式，让代码更简洁；
3. **使用规则** ：仅在函数组件 / 自定义 Hook 中顶层调用，是避免 Hooks 出错的关键。

如果想深入了解某个 Hook（比如 `useReducer` 、 `useMemo` 、 `useCallback` ），可以告诉我，我会补充对应的详解和示例。

如何使用 useEffect 进行数据请求？

除了 useState 和 useEffect，还有哪些常用的 React Hooks？

React Hooks 有哪些使用注意事项？
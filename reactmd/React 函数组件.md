React 函数组件

React 函数组件是 React 中定义组件最简洁、最主流的方式，它以 JavaScript 函数的形式存在，相比传统的类组件更轻量、易理解，也是 React Hooks 出现后官方推荐的写法。

### 一、函数组件的基础用法

#### 1\. 最简化的函数组件

这是一个无状态、无交互的基础函数组件，核心就是 **返回一段 JSX 结构** ：

jsx

```jsx
// 定义函数组件
function HelloWorld() {
  // 返回 JSX（React 的语法糖，最终会被编译为 React.createElement）
  return <h1>你好，React 函数组件！</h1>;
}

// 渲染组件到页面
function App() {
  return (
    <div className="app">
      <HelloWorld />
    </div>
  );
}

export default App;
```

#### 2\. 接收 Props（外部传参）

函数组件可以通过 **函数参数** 接收父组件传递的 props，props 是只读的（不可修改）：

jsx

```jsx
// 接收 props 参数
function Greeting(props) {
  // 方式1：直接通过 props.属性名 获取
  // return <h2>你好，{props.name}！你的年龄是 {props.age}</h2>;
  
  // 方式2：解构 props（更常用，代码更简洁）
  const { name, age } = props;
  return <h2>你好，{name}！你的年龄是 {age}</h2>;
}

// 父组件传参
function App() {
  return (
    <div>
      <Greeting name="张三" age={20} />
      <Greeting name="李四" age={25} />
    </div>
  );
}

export default App;
```

#### 3\. 带默认值的 Props

可以给 props 设置默认值，避免传参缺失时出现异常：

jsx

```jsx
function Greeting({ name = "未知用户", age = 18 }) {
  return <h2>你好，{name}！你的年龄是 {age}</h2>;
}

// 不传 age 时，使用默认值 18
function App() {
  return <Greeting name="王五" />;
}
```

### 二、函数组件的核心能力（结合 Hooks）

函数组件本身是 “无状态” 的，想要实现 **状态管理、生命周期、副作用处理** 等功能，需要借助 React Hooks（钩子函数），最常用的是 `useState` 和 `useEffect` 。

#### 1\. 用 useState 管理组件状态

`useState` 用于在函数组件中定义 **可修改的状态** ，返回一个数组：

- 第一个元素：当前的状态值
- 第二个元素：更新状态的函数（调用后会触发组件重新渲染）

jsx

```jsx
import { useState } from 'react';

function Counter() {
  // 定义状态：count 初始值为 0，setCount 是更新 count 的函数
  const [count, setCount] = useState(0);

  // 点击事件：更新状态
  const handleClick = () => {
    setCount(count + 1); // 不可直接修改 count，必须通过 setCount
  };

  return (
    <div>
      <p>当前计数：{count}</p>
      <button onClick={handleClick}>点击加1</button>
    </div>
  );
}

export default Counter;
```

#### 2\. 用 useEffect 处理副作用

副作用包括：数据请求、DOM 操作、定时器 / 订阅等， `useEffect` 可以模拟类组件的生命周期（如 `componentDidMount` 、 `componentDidUpdate` 、 `componentWillUnmount` ）。

jsx

```jsx
import { useState, useEffect } from 'react';

function UserInfo() {
  const [user, setUser] = useState(null);

  // 模拟请求用户数据（副作用）
  useEffect(() => {
    // 1. 组件挂载后执行（类似 componentDidMount）
    const fetchUser = async () => {
      const res = await fetch('https://jsonplaceholder.typicode.com/users/1');
      const data = await res.json();
      setUser(data);
    };
    fetchUser();

    // 2. 组件卸载前执行（类似 componentWillUnmount）
    return () => {
      console.log('组件即将卸载，可清理定时器/订阅等');
    };
  }, []); // 空依赖数组：仅在组件挂载/卸载时执行

  if (!user) return <p>加载中...</p>;

  return (
    <div>
      <h3>用户名：{user.name}</h3>
      <p>邮箱：{user.email}</p>
    </div>
  );
}

export default UserInfo;
```

### 三、函数组件 vs 类组件（核心区别）

表格

| 特性 | 函数组件 | 类组件 |
| --- | --- | --- |
| 写法 | 简洁，JS 函数形式 | 繁琐，继承 React.Component |
| 状态管理 | 依赖 useState Hooks | 依赖 this.state |
| 生命周期 | 依赖 useEffect Hooks | 专用生命周期方法（如 componentDidMount） |
| this 指向 | 无 this | 需处理 this 绑定问题 |
| 性能 | 更轻量，无实例开销 | 有实例开销，相对较重 |

### 总结

1. React 函数组件是 **以 JS 函数形式定义** 的组件，核心是返回 JSX 结构，可通过参数接收 props；
2. 借助 `useState` 可管理组件状态，借助 `useEffect` 可处理副作用，替代类组件的核心能力；
3. 函数组件是 React 官方推荐的写法，相比类组件更简洁、易维护，是 React 开发的主流选择。

如何使用 React 的 useState 钩子函数来管理组件的状态？

除了 useState 和 useEffect，React 还有哪些常用的钩子函数？

在函数组件中使用 useEffect 时需要注意什么？
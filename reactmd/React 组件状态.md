React 组件状态

### React 组件状态（State）详解

React 中的「状态（State）」是组件内部管理的可变数据，用于记录组件的动态信息（比如输入框内容、弹窗显隐、列表数据等），状态变化会触发组件重新渲染，是实现交互的核心。

#### 一、核心概念（新手友好版）

可以把 State 理解为：

- 组件的「私有数据」：只有组件自己能直接修改（类组件）或通过特定方法修改（函数组件）。
- 「响应式数据」：State 变了，React 会自动重新渲染组件，更新页面。
- 与 Props 的区别：Props 是父组件传递的「只读数据」，State 是组件自身的「可变数据」。

#### 二、两种组件的 State 使用方式

React 有类组件和函数组件两种写法，函数组件（配合 Hooks）是现在的主流，下面分别讲解：

##### 1\. 函数组件（推荐）：使用 useState Hook

`useState` 是 React 提供的 Hook，专门用于在函数组件中管理状态，语法简单且易上手。

**基本用法代码示例** ：

jsx

```jsx
import { useState } from 'react';

// 计数器组件：点击按钮修改数值
function Counter() {
  // 声明状态：[状态变量, 修改状态的方法] = useState(初始值)
  const [count, setCount] = useState(0); 
  // 声明多个状态：可以多次调用 useState
  const [isShow, setIsShow] = useState(true);

  // 修改状态的函数
  const increment = () => {
    // 注意：修改状态必须用 setState 方法，不能直接赋值（count++ 无效）
    setCount(count + 1); 
  };

  return (
    <div>
      <h2>计数器：{count}</h2>
      <button onClick={increment}>点击+1</button>
      <button onClick={() => setIsShow(!isShow)}>
        {isShow ? '隐藏' : '显示'}计数器
      </button>
      {isShow && <p>当前数值：{count}</p>}
    </div>
  );
}

export default Counter;
```

**关键解释** ：

- `useState(0)` ：初始化状态，参数是状态的初始值（可以是数字、字符串、对象、数组等）。
- `[count, setCount]` ：数组解构， `count` 是当前状态值， `setCount` 是修改该状态的「唯一方法」。
- 状态更新是「异步的」：如果需要基于上一次的状态更新（比如连续点击），建议用函数形式：
	jsx
	```jsx
	// 正确：基于上一次的 count 计算新值
	setCount(prevCount => prevCount + 1);
	```
- 复杂状态（对象 / 数组）：修改时要「浅拷贝」原状态，避免直接修改（React 状态是不可变的）：
	jsx
	```jsx
	// 示例：修改对象状态
	const [user, setUser] = useState({ name: '张三', age: 20 });
	const updateAge = () => {
	  // 错误：直接修改原对象，React 检测不到变化
	  // user.age = 21;
	  // 正确：创建新对象，覆盖需要修改的属性
	  setUser({ ...user, age: 21 });
	};
	```

##### 2\. 类组件（旧写法，了解即可）

类组件通过 `this.state` 定义状态， `this.setState()` 修改状态：

jsx

```jsx
import React, { Component } from 'react';

class Counter extends Component {
  // 初始化状态
  state = {
    count: 0,
    isShow: true
  };

  increment = () => {
    // 修改状态：setState 会合并新状态到原状态
    this.setState({ count: this.state.count + 1 });
  };

  render() {
    return (
      <div>
        <h2>计数器：{this.state.count}</h2>
        <button onClick={this.increment}>点击+1</button>
        <button onClick={() => this.setState({ isShow: !this.state.isShow })}>
          {this.state.isShow ? '隐藏' : '显示'}
        </button>
      </div>
    );
  }
}

export default Counter;
```

#### 三、State 使用注意事项

1. **不要直接修改 State** ：无论是类组件还是函数组件，直接赋值（如 `count = 1` 、 `this.state.count = 1` ）不会触发组件渲染，必须用 `setCount` 或 `setState` 。
2. **State 更新是异步的** ：React 会批量处理状态更新，所以不要在 setState 后立即读取最新状态：
	jsx
	```jsx
	// 错误：这里的 count 还是旧值
	setCount(count + 1);
	console.log(count); 
	// 正确：用 useEffect 监听状态变化
	useEffect(() => {
	  console.log(count); // 状态更新后触发
	}, [count]);
	```
3. **状态提升** ：如果多个组件需要共享同一个状态，把状态提升到它们的最近公共父组件中管理。
4. **复杂状态管理** ：如果项目状态复杂（如跨组件共享、异步请求数据），可以用 `useReducer` （Hook）或 Redux、Zustand 等状态管理库。

### 总结

1. React 状态（State）是组件内部的可变响应式数据，用于管理动态交互，状态变化会触发组件重渲染。
2. 函数组件用 `useState` 管理状态，修改状态必须用返回的 setState 方法，复杂状态需浅拷贝后修改。
3. 核心原则： **不直接修改 State，通过 React 提供的方法更新，且 State 更新是异步的** 。

类组件中如何使用 State？

React 中 State 的更新是同步还是异步的？

如何优化 React 组件的 State？
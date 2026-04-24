React 组件生命周期

React 组件的生命周期是组件从 **创建** 到 **挂载** 、 **更新** 、 **卸载** 的整个过程，理解它能帮你精准控制组件在不同阶段的行为。React 16.8 引入 Hooks 后，函数组件通过 Hooks 替代了类组件的生命周期，但类组件的生命周期概念仍是基础，我会先讲类组件，再补充函数组件的对应实现。

### 一、类组件的生命周期（核心阶段）

类组件的生命周期分为 3 个核心阶段，每个阶段对应不同的钩子函数（生命周期方法）：

#### 1\. 挂载阶段（组件首次渲染到 DOM）

组件从创建到首次显示在页面上的过程，执行顺序固定：

- `constructor()` ：构造函数，初始化 state、绑定事件处理函数（ **不要在这里调用 setState** ）。
- `static getDerivedStateFromProps(props, state)` ：静态方法，根据 props 更新 state（极少用，替代旧的 `componentWillReceiveProps` ）。
- `render()` ：核心方法，返回 JSX 描述组件结构（ **纯函数，不能有副作用** ，比如发请求、修改 DOM）。
- `componentDidMount()` ：组件挂载完成（DOM 已生成），可执行副作用操作：发 ajax 请求、操作 DOM、订阅事件、定时器等（ **这里可以调用 setState，会触发一次额外更新，但不影响首次渲染** ）。

示例代码：

jsx

```jsx
import React, { Component } from 'react';

class MyComponent extends Component {
  constructor(props) {
    super(props);
    this.state = { count: 0 }; // 初始化state
    console.log('1. 构造函数：初始化state');
  }

  static getDerivedStateFromProps(props, state) {
    console.log('2. getDerivedStateFromProps：根据props更新state');
    return null; // 不需要更新state则返回null
  }

  render() {
    console.log('3. render：渲染组件');
    return <div>计数：{this.state.count}</div>;
  }

  componentDidMount() {
    console.log('4. componentDidMount：组件挂载完成');
    // 示例：发请求、操作DOM
    this.timer = setInterval(() => {
      this.setState({ count: this.state.count + 1 });
    }, 1000);
  }
}

export default MyComponent;
```

#### 2\. 更新阶段（组件重新渲染）

当组件的 `props` 变化、调用 `setState` 、强制更新（ `forceUpdate` ）时触发，执行顺序：

- `static getDerivedStateFromProps(props, state)` ：挂载阶段也会执行，更新阶段同样先触发。
- `shouldComponentUpdate(nextProps, nextState)` ：返回布尔值，决定是否触发重新渲染（默认 true），可用于性能优化（比如对比 props/state 避免不必要的渲染）。
- `render()` ：重新渲染组件。
- `getSnapshotBeforeUpdate(prevProps, prevState)` ：在 DOM 更新前执行，返回一个值，会传给 `componentDidUpdate` （比如获取更新前的滚动位置）。
- `componentDidUpdate(prevProps, prevState, snapshot)` ：DOM 更新完成后执行，可处理更新后的逻辑（比如根据新 props 重新发请求）。

示例（补充更新阶段钩子）：

jsx

```jsx
// 接上面的MyComponent
shouldComponentUpdate(nextProps, nextState) {
  console.log('5. shouldComponentUpdate：是否更新');
  return nextState.count % 2 === 0; // 仅当count为偶数时更新
}

getSnapshotBeforeUpdate(prevProps, prevState) {
  console.log('6. getSnapshotBeforeUpdate：DOM更新前');
  return \`更新前count：${prevState.count}\`; // 传递给componentDidUpdate
}

componentDidUpdate(prevProps, prevState, snapshot) {
  console.log('7. componentDidUpdate：DOM更新完成', snapshot);
  if (this.state.count > 10) {
    clearInterval(this.timer); // 计数超过10停止定时器
  }
}
```

#### 3\. 卸载阶段（组件从 DOM 移除）

只有一个核心钩子：

- `componentWillUnmount()` ：组件卸载前执行，用于 **清理副作用** （清除定时器、取消订阅、关闭请求等），避免内存泄漏。

示例（补充卸载钩子）：

jsx

```jsx
// 接上面的MyComponent
componentWillUnmount() {
  console.log('8. componentWillUnmount：组件卸载');
  clearInterval(this.timer); // 清理定时器
}
```

### 二、函数组件的 “生命周期”（Hooks 实现）

函数组件没有类组件的生命周期钩子，但可以通过 `useState` 、 `useEffect` 模拟所有生命周期行为：

- `useEffect` 是核心：接收两个参数（回调函数、依赖数组），回调的返回值是清理函数。

表格

| 类组件生命周期 | 函数组件 Hooks 实现 |
| --- | --- |
| `componentDidMount` | `useEffect(() => { /* 副作用 */ }, [])` （空依赖） |
| `componentDidUpdate` | `useEffect(() => { /* 副作用 */ }, [依赖项])` |
| `componentWillUnmount` | `useEffect(() => { return () => { /* 清理 */ } }, [])` |

示例（函数组件模拟生命周期）：

jsx

```jsx
import React, { useState, useEffect } from 'react';

function MyFunctionComponent() {
  const [count, setCount] = useState(0);

  // 模拟 componentDidMount（仅挂载时执行）
  useEffect(() => {
    console.log('函数组件：挂载完成');
    const timer = setInterval(() => {
      setCount(prev => prev + 1);
    }, 1000);

    // 模拟 componentWillUnmount（卸载时清理）
    return () => {
      console.log('函数组件：卸载清理');
      clearInterval(timer);
    };
  }, []); // 空依赖

  // 模拟 componentDidUpdate（count变化时执行）
  useEffect(() => {
    console.log('函数组件：count更新', count);
    if (count > 10) {
      clearInterval(timer);
    }
  }, [count]); // 依赖count

  return <div>计数：{count}</div>;
}

export default MyFunctionComponent;
```

### 三、关键注意事项

1. 类组件中， `render` 是纯函数， **禁止修改 state、发请求、操作 DOM** ，否则会导致无限循环。
2. `getDerivedStateFromProps` 是静态方法，没有 `this` ，只能通过返回值更新 state，尽量少用（容易导致逻辑复杂）。
3. 函数组件中， `useEffect` 的依赖数组必须写全（否则会捕获旧值），可通过 `eslint-plugin-react-hooks` 检查。
4. 无论类组件还是函数组件， **避免在生命周期中执行耗时操作** ，优先用异步方式处理。

### 总结

1. 类组件生命周期分 **挂载、更新、卸载** 三阶段，核心钩子： `componentDidMount` （挂载）、 `componentDidUpdate` （更新）、 `componentWillUnmount` （卸载）。
2. 函数组件通过 `useEffect` 模拟生命周期：空依赖对应挂载、指定依赖对应更新、返回清理函数对应卸载。
3. 生命周期的核心作用是 **处理副作用** （发请求、操作 DOM、定时器等），且必须在卸载阶段清理副作用，避免内存泄漏。

类组件的生命周期中，componentDidMount 方法有什么作用？

函数组件的生命周期有哪些阶段？

如何在函数组件中模拟类组件的生命周期方法？
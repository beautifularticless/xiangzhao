React生命周期
React 的生命周期是组件从 **创建** 到 **挂载** 、 **更新** 、 **卸载** 的整个过程中，会自动触发的一系列钩子函数（生命周期方法）。理解它能帮你精准控制组件在不同阶段的行为，比如初始化数据、操作 DOM、清理副作用等。

### 一、React 生命周期的两个阶段（核心划分）

React 16.8 引入 Hooks 后，类组件的生命周期依然可用，但函数组件通过 Hooks 实现了类似能力。我们先以 **类组件** 为核心讲解（最易理解生命周期逻辑），再补充函数组件的等价实现。

#### 1\. 类组件的生命周期（三大阶段）

类组件的生命周期可分为 **挂载阶段** 、 **更新阶段** 、 **卸载阶段** ，每个阶段对应固定的钩子函数：

表格

| 阶段 | 执行时机 | 核心钩子函数 | 常用场景 |
| --- | --- | --- | --- |
| 挂载阶段 | 组件首次渲染到 DOM 中 | constructor → render → componentDidMount | 初始化 state、请求数据、操作 DOM |
| 更新阶段 | props/state 变化、强制更新 | shouldComponentUpdate → render → componentDidUpdate | 更新 DOM、根据新数据请求接口 |
| 卸载阶段 | 组件从 DOM 中移除 | componentWillUnmount | 清理定时器、取消网络请求、解绑事件 |

##### （1）挂载阶段（组件第一次出现）

jsx

```jsx
import React, { Component } from 'react';

class Example extends Component {
  // 1. 构造函数：最先执行，初始化 state/绑定 this
  constructor(props) {
    super(props);
    this.state = { count: 0 }; // 初始化状态
    console.log('1. constructor 执行');
  }

  // 2. 渲染函数：必须有，返回要渲染的 JSX（纯函数，不能修改 state）
  render() {
    console.log('2. render 执行');
    return <div>计数：{this.state.count}</div>;
  }

  // 3. 组件挂载完成：DOM 已生成，可操作 DOM/发请求
  componentDidMount() {
    console.log('3. componentDidMount 执行');
    // 示例：请求数据、绑定事件、启动定时器
    this.timer = setInterval(() => {
      this.setState({ count: this.state.count + 1 });
    }, 1000);
  }
}
```

##### （2）更新阶段（组件重新渲染）

更新触发条件： `props` 变化、 `setState` 调用、 `forceUpdate()` 调用。

jsx

```jsx
// 接上面的 Example 类
// 可选：控制是否允许更新（性能优化）
shouldComponentUpdate(nextProps, nextState) {
  console.log('4. shouldComponentUpdate 执行');
  // 示例：只有 count 变化时才更新
  return nextState.count !== this.state.count;
}

// 组件更新完成：DOM 已更新，可操作新 DOM
componentDidUpdate(prevProps, prevState) {
  console.log('5. componentDidUpdate 执行');
  // 注意：避免在此处直接 setState（需加条件，否则无限循环）
  if (prevState.count !== this.state.count) {
    console.log('count 已更新为：', this.state.count);
  }
}
```

##### （3）卸载阶段（组件被移除）

jsx

```jsx
// 接上面的 Example 类
componentWillUnmount() {
  console.log('6. componentWillUnmount 执行');
  // 必须：清理副作用（定时器、事件监听、网络请求等）
  clearInterval(this.timer);
}
```

#### 2\. 函数组件的 “生命周期”（Hooks 实现）

函数组件没有类组件的生命周期钩子，但可以通过 `useState` 、 `useEffect` 实现完全等价的效果， `useEffect` 是核心：

jsx

```jsx
import React, { useState, useEffect } from 'react';

function Example() {
  const [count, setCount] = useState(0); // 等价于 constructor 初始化 state

  // 等价于 componentDidMount + componentDidUpdate + componentWillUnmount
  useEffect(() => {
    // 1. 这里的代码：组件挂载/更新后执行（对应 componentDidMount + componentDidUpdate）
    const timer = setInterval(() => {
      setCount(prev => prev + 1);
    }, 1000);
    console.log('组件挂载/更新');

    // 2. 返回的函数：组件卸载前执行（对应 componentWillUnmount）
    return () => {
      clearInterval(timer);
      console.log('组件卸载，清理定时器');
    };
  }, [count]); // 依赖数组：只有 count 变化时，才重新执行 useEffect

  return <div>计数：{count}</div>;
}
```

- 依赖数组 `[]` （空数组）：仅在组件挂载时执行一次（等价 `componentDidMount` ）；
- 依赖数组 `[count]` ：count 变化时执行（等价 `componentDidUpdate` ）；
- useEffect 返回的函数：卸载时执行（等价 `componentWillUnmount` ）。

### 二、关键注意事项

1. **render 函数是纯函数** ：不能在 `render` 中调用 `setState` 、发请求、操作 DOM，否则会导致无限循环；
2. **componentDidUpdate 慎用 setState** ：必须加条件判断（比如对比 prevProps/prevState），否则会触发无限更新；
3. **副作用必须清理** ：定时器、事件监听、网络请求等，一定要在卸载阶段清理，否则会导致内存泄漏；
4. **Hooks 依赖数组不能漏** ：函数组件中 `useEffect` 的依赖数组要写全，否则会导致闭包陷阱（读取到旧值）。

### 总结

1. React 类组件生命周期分为 **挂载、更新、卸载** 三大阶段，核心钩子是 `componentDidMount` （挂载）、 `componentDidUpdate` （更新）、 `componentWillUnmount` （卸载）；
2. 函数组件通过 `useEffect` 实现生命周期逻辑，依赖数组控制执行时机，返回函数清理副作用；
3. 无论类组件还是函数组件， **副作用（定时器、请求等）必须在卸载阶段清理** ，避免内存泄漏。

类组件的生命周期中，哪些钩子函数可以用来处理副作用？

函数组件的生命周期与类组件的生命周期有哪些区别？

如何在 React 中使用生命周期方法来优化性能？
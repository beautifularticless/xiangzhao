React 事件处理

React 的事件处理是前端开发中的核心知识点，它在原生 DOM 事件的基础上做了封装和优化，既保留了熟悉的使用方式，又适配了 React 的组件化特性。下面我会从基础到进阶，帮你彻底理解 React 事件处理。

### 一、React 事件处理的核心特点

1. **语法差异** ：React 事件采用 **小驼峰命名** （如 `onClick` 而非 `onclick` ），事件处理函数通过赋值传递（而非字符串）。
2. **合成事件（SyntheticEvent）** ：React 封装了原生事件对象，提供跨浏览器的统一接口，用法和原生事件对象几乎一致（如 `e.target` 、 `e.preventDefault()` ）。
3. **事件委托** ：React 会将所有事件委托到 `document` 节点，而非绑定在具体 DOM 元素上，提升性能。

### 二、基础用法（函数组件）

#### 1\. 简单事件绑定

这是最基础的用法，直接将事件处理函数赋值给事件属性：

jsx

```jsx
import React from 'react';

function Button() {
  // 定义事件处理函数
  const handleClick = () => {
    console.log('按钮被点击了！');
  };

  // 绑定 onClick 事件（小驼峰）
  return <button onClick={handleClick}>点击我</button>;
}

export default Button;
```

#### 2\. 带参数的事件处理

如果需要给事件处理函数传参，常用两种方式：

jsx

```jsx
import React from 'react';

function List() {
  // 带参数的处理函数
  const handleItemClick = (id, e) => {
    console.log(\`点击了第 ${id} 项\`, e.target); // e 是合成事件对象
  };

  return (
    <ul>
      {/* 方式1：箭头函数传参（推荐，简洁） */}
      <li onClick={(e) => handleItemClick(1, e)}>选项1</li>
      {/* 方式2：bind 绑定（不推荐，每次渲染都会生成新函数） */}
      <li onClick={handleItemClick.bind(null, 2)}>选项2</li>
    </ul>
  );
}

export default List;
```

#### 3\. 阻止默认行为

React 中不能通过返回 `false` 阻止默认行为，必须显式调用 `e.preventDefault()` ：

jsx

```jsx
import React from 'react';

function Link() {
  const handleLinkClick = (e) => {
    // 阻止<a>标签的默认跳转行为
    e.preventDefault();
    console.log('链接被点击，但没有跳转');
  };

  return <a href="https://react.dev" onClick={handleLinkClick}>React 官网</a>;
}

export default Link;
```

### 三、类组件中的事件处理（兼容旧项目）

类组件的事件处理需要注意 `this` 指向问题（类方法默认不会绑定 `this` ），常用 3 种解决方式：

jsx

```jsx
import React, { Component } from 'react';

class Counter extends Component {
  constructor(props) {
    super(props);
    // 状态初始化
    this.state = { count: 0 };
    // 方式1：在构造函数中绑定 this（推荐，性能最优）
    this.handleIncrement = this.handleIncrement.bind(this);
  }

  // 事件处理函数
  handleIncrement() {
    this.setState({ count: this.state.count + 1 });
  }

  // 方式2：类字段语法（箭头函数，无需绑定 this，简洁）
  handleDecrement = () => {
    this.setState({ count: this.state.count - 1 });
  };

  render() {
    return (
      <div>
        <p>计数：{this.state.count}</p>
        {/* 方式1的使用 */}
        <button onClick={this.handleIncrement}>+1</button>
        {/* 方式2的使用 */}
        <button onClick={this.handleDecrement}>-1</button>
        {/* 方式3：渲染时绑定（不推荐，每次渲染生成新函数，性能差） */}
        <button onClick={() => this.setState({ count: 0 })}>重置</button>
      </div>
    );
  }
}

export default Counter;
```

### 四、常见注意事项

1. **避免直接调用函数** ： `onClick={handleClick()}` 会导致组件渲染时立即执行函数，正确写法是 `onClick={handleClick}` （传递函数引用）。
2. **合成事件的坑** ：如果需要在异步操作中使用合成事件对象，需先调用 `e.persist()` 保留事件（React 会自动回收合成事件）：
	jsx
	```jsx
	const handleClick = (e) => {
	  e.persist(); // 保留事件
	  setTimeout(() => {
	    console.log(e.target); // 异步中仍能访问
	  }, 1000);
	};
	```
3. **获取原生事件** ：通过 `e.nativeEvent` 可以访问底层原生事件对象。

### 总结

1. React 事件采用 **小驼峰命名** ，事件处理函数传递引用而非字符串，核心基于 **合成事件** 实现跨浏览器兼容。
2. 函数组件中事件传参优先用箭头函数，类组件中解决 `this` 指向优先用「构造函数绑定」或「类字段箭头函数」。
3. 阻止默认行为必须显式调用 `e.preventDefault()` ，避免渲染时直接调用事件函数（需传递函数引用）。

React 事件处理的性能优化

React 事件处理与其他框架的对比

React 事件处理的常见问题及解决方案
React 类组件

React 类组件是 React 早期版本中创建可复用、有状态组件的核心方式，虽然现在函数组件（配合 Hooks）成为主流，但理解类组件依然是掌握 React 核心概念的基础。下面我会从基础到核心特性，帮你全面理解类组件。

### 一、类组件的基础定义与使用

类组件本质是一个继承自 `React.Component` 的 ES6 类，必须实现 `render()` 方法（返回 React 元素）。

#### 1\. 最基础的类组件示例

jsx

```jsx
import React from 'react';

// 定义类组件
class HelloWorld extends React.Component {
  // render 是类组件的核心方法，必须实现
  render() {
    // 返回要渲染的 JSX
    return <h1>你好，React 类组件！</h1>;
  }
}

// 使用组件
function App() {
  return (
    <div className="App">
      <HelloWorld />
    </div>
  );
}

export default App;
```

#### 2\. 核心说明

- **继承要求** ：必须继承 `React.Component` （或 `React.PureComponent` ），否则无法被 React 识别为组件。
- **render 方法** ：唯一必须的方法，返回值可以是 JSX、null、false 或其他 React 元素，负责描述组件的 UI。
- **组件命名** ：遵循大驼峰命名法（如 `HelloWorld` ），这是 React 的规范。

### 二、类组件的核心特性

#### 1\. 接收和使用 props

props 是父组件传递给子组件的只读数据，类组件中通过 `this.props` 访问。

jsx

```jsx
class Greeting extends React.Component {
  render() {
    // 从 this.props 中解构接收的属性
    const { name, age } = this.props;
    return (
      <div>
        <p>姓名：{name}</p>
        <p>年龄：{age}</p>
      </div>
    );
  }
}

// 使用时传递 props
function App() {
  return <Greeting name="张三" age={20} />;
}
```

- 注意： `this.props` 是只读的， **不能在子组件中修改 props** ，要修改只能由父组件传递新值。

#### 2\. 状态（state）与 setState

类组件的核心优势是能管理内部状态（state），状态变化会触发组件重新渲染。

- `state` ：是类组件的实例属性，必须是对象格式，用于存储组件的可变数据。
- `setState()` ：修改 state 的唯一正确方式（直接修改 `this.state` 不会触发渲染），支持对象式和函数式两种写法。

jsx

```jsx
class Counter extends React.Component {
  // 初始化 state（方式1：构造函数）
  constructor(props) {
    super(props); // 必须调用 super，才能访问 this
    this.state = {
      count: 0
    };
  }

  // 初始化 state（方式2：类的实例属性，更简洁）
  // state = { count: 0 };

  // 定义事件处理函数（注意 this 绑定问题）
  increment = () => {
    // 方式1：对象式 setState（适用于不依赖旧 state 的场景）
    // this.setState({ count: this.state.count + 1 });

    // 方式2：函数式 setState（适用于依赖旧 state 的场景，更可靠）
    this.setState((prevState) => ({
      count: prevState.count + 1
    }));
  };

  render() {
    return (
      <div>
        <p>计数：{this.state.count}</p>
        <button onClick={this.increment}>点击+1</button>
      </div>
    );
  }
}
```

- 关键注意点：
	1. `super(props)` 必须在构造函数中第一个调用，否则无法使用 `this.props` 。
	2. `setState` 是 **异步的** ，不要在调用 `setState` 后立即读取 `this.state` （如需基于旧 state 修改，用函数式写法）。
	3. 事件处理函数的 `this` 绑定：推荐使用 **箭头函数** （如上例），也可在构造函数中绑定 `this` （ `this.increment = this.increment.bind(this)` ）。

#### 3\. 生命周期钩子

类组件有一套完整的生命周期钩子，用于在组件不同阶段执行逻辑，核心生命周期分为三个阶段：

表格

| 阶段 | 核心钩子 | 作用 |
| --- | --- | --- |
| 挂载阶段 | constructor → render → componentDidMount | 组件初始化 → 渲染 UI → 组件挂载完成（可执行 DOM 操作、请求数据） |
| 更新阶段 | shouldComponentUpdate → render → componentDidUpdate | 判断是否更新 → 重新渲染 → 更新完成（可处理更新后的 DOM、依赖 props 更新） |
| 卸载阶段 | componentWillUnmount | 组件卸载前（清理定时器、取消网络请求、解绑事件等） |

**生命周期示例（请求数据）** ：

jsx

```jsx
class UserList extends React.Component {
  state = {
    users: [],
    loading: true
  };

  // 组件挂载完成后请求数据（最常用的异步操作时机）
  componentDidMount() {
    // 模拟接口请求
    setTimeout(() => {
      const mockUsers = [{ id: 1, name: "张三" }, { id: 2, name: "李四" }];
      this.setState({
        users: mockUsers,
        loading: false
      });
    }, 1000);
  }

  // 组件卸载前清理资源
  componentWillUnmount() {
    // 比如清理定时器、取消请求等
    console.log("组件即将卸载，清理资源");
  }

  render() {
    const { loading, users } = this.state;
    if (loading) return <div>加载中...</div>;
    return (
      <ul>
        {users.map((user) => (
          <li key={user.id}>{user.name}</li>
        ))}
      </ul>
    );
  }
}
```

### 三、类组件 vs 函数组件（Hooks）

表格

| 特性 | 类组件 | 函数组件（Hooks） |
| --- | --- | --- |
| 状态管理 | this.state + setState | useState、useReducer |
| 生命周期 | 生命周期钩子 | useEffect（模拟所有钩子） |
| this 绑定 | 需要处理 this 指向 | 无 this，更简洁 |
| 代码复杂度 | 较高（类、继承） | 较低（函数、纯逻辑） |
| 复用逻辑 | 高阶组件、Render Props | 自定义 Hooks（更优雅） |

### 总结

1. **类组件核心** ：继承 `React.Component` ，必须实现 `render()` 方法，通过 `this.props` 接收外部数据，通过 `this.state` + `setState()` 管理内部状态。
2. **关键注意** ： `setState` 是异步的，修改状态优先用函数式写法；事件处理函数需绑定 `this` （推荐箭头函数）。
3. **生命周期** ：核心关注 `componentDidMount` （初始化异步操作）、 `componentDidUpdate` （处理更新逻辑）、 `componentWillUnmount` （清理资源）。

虽然现在函数组件是主流，但类组件的核心思想（状态管理、生命周期）是 React 的基础，理解它能帮你更好地掌握 Hooks 的设计思路。

类组件如何更新状态？

类组件和函数组件的区别是什么？

类组件的生命周期方法有哪些？
React JSX

### React JSX 详解

JSX 是 React 的核心语法糖，全称是 JavaScript XML，它允许你在 JavaScript 代码中直接编写类 HTML 的标记，让界面开发更直观。本质上，JSX 会被 Babel 等工具编译成 React.createElement () 函数调用，最终生成 React 元素（虚拟 DOM）。

---

### 一、JSX 基础用法

#### 1\. 基本语法

JSX 看起来像 HTML，但其实是 JavaScript 的扩展，核心规则：

- 外层必须有唯一根节点（或用 `<></>` 空片段包裹）
- 标签必须闭合（如 `<input />` 而非 `<input>` ）
- 属性名采用驼峰命名（如 `className` 替代 `class` ， `onClick` 替代 `onclick` ）

jsx

```jsx
import React from 'react';

function App() {
  // JSX 核心结构
  return (
    <div className="app-container">
      <h1>Hello, JSX!</h1>
      <button onClick={() => alert('点击了按钮')}>点击我</button>
      <input type="text" placeholder="请输入内容" />
    </div>
  );
}

export default App;
```

#### 2\. 嵌入 JavaScript 表达式

在 JSX 中用 `{}` 包裹任意有效的 JavaScript 表达式（变量、运算、函数调用等）：

#### 3\. 列表渲染

用 `map()` 遍历数组生成 JSX 列表，必须给每个子元素加 `key` （唯一标识）：

jsx

```jsx
function TodoList() {
  const todos = ['学习JSX', '写React组件', '理解虚拟DOM'];

  return (
    <ul>
      {todos.map((todo, index) => (
        <li key={index}>{todo}</li>
      ))}
    </ul>
  );
}
```

#### 4\. 样式处理

- 行内样式：用对象表示，属性驼峰命名
- 类名样式：用 `className` 绑定 CSS 类

jsx

```jsx
function StyledComponent() {
  // 行内样式对象
  const titleStyle = {
    color: 'blue',
    fontSize: '20px', // 驼峰命名
    marginTop: '10px'
  };

  return (
    <div>
      {/* 行内样式 */}
      <h2 style={titleStyle}>行内样式示例</h2>
      {/* 类名样式（需提前定义CSS） */}
      <p className="text-content">类名样式示例</p>
    </div>
  );
}
```

---

### 二、JSX 编译原理

JSX 本身不能被浏览器直接识别，需要通过 Babel 编译为 React.createElement 调用：

jsx

```jsx
// 原始 JSX
<div className="app">Hello JSX</div>

// 编译后
React.createElement('div', { className: 'app' }, 'Hello JSX');
```

- 第一个参数：标签名 / 组件
- 第二个参数：属性对象
- 第三个及以后参数：子元素

---

### 三、常见注意事项

1. **注释写法** ：JSX 中的注释必须放在 `{}` 内，格式： `{/* 这是注释 */}`
2. **布尔属性** ：如 `disabled` ，写 `disabled={true}` 可简化为 `disabled`
3. **避免 XSS** ：React 会自动转义 `{}` 中的内容，防止注入攻击（如 `<p>{userInput}</p>` 会转义特殊字符）
4. **多标签处理** ：若需返回多个标签，除了根节点，还可用 `<React.Fragment>` 或简写 `<></>` ：

jsx

```jsx
function MultiTags() {
  return (
    <>
      <p>标签1</p>
      <p>标签2</p>
    </>
  );
}
```

---

### 总结

1. **核心本质** ：JSX 是 React.createElement () 的语法糖，最终生成 React 元素（虚拟 DOM）。
2. **核心规则** ：唯一根节点、标签闭合、属性驼峰命名，用 `{}` 嵌入 JS 表达式。
3. **常用场景** ：基础渲染、条件渲染、列表渲染、样式绑定，是 React 组件开发的基础。

掌握 JSX 是学习 React 的第一步，它让 React 组件的结构更直观，同时保留了 JavaScript 的灵活性。

如何在 JSX 中使用条件渲染？

如何在 JSX 中使用事件处理？

如何在 JSX 中使用样式？
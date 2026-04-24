react 声明式开发

### React 声明式开发：从理解到实践

#### 一、什么是声明式开发？

先通过对比帮你理解核心概念：

- **命令式开发** （传统 JS / 原生 DOM）：告诉计算机「 **一步步做什么** 」，需要手动控制每一步操作（比如先创建元素、再设置样式、最后添加到 DOM）。
- **声明式开发** （React 核心）：告诉计算机「 **想要什么结果** 」，不需要关心具体实现步骤，React 会自动处理从「当前状态」到「目标状态」的转换。

举个通俗例子：

- 命令式：「打开冰箱门 → 把苹果放进去 → 关上冰箱门」（关注步骤）。
- 声明式：「让冰箱里有苹果」（关注结果）。

#### 二、React 中声明式开发的具体体现

React 的声明式开发核心是「 **状态驱动视图** 」：你只需要定义「状态（state）」和「视图（JSX）」的映射关系，当状态变化时，React 自动更新视图，无需手动操作 DOM。

##### 1\. 基础示例：声明式渲染

jsx

```jsx
import { useState } from 'react';

function Counter() {
  // 声明状态：想要一个数字计数器，初始值为0
  const [count, setCount] = useState(0);

  // 声明视图：想要「显示count的值 + 点击按钮让count+1」的结果
  return (
    <div>
      <p>当前计数：{count}</p>
      {/* 只声明「点击按钮后count要变成count+1」，无需关心DOM如何更新 */}
      <button onClick={() => setCount(count + 1)}>点击加1</button>
    </div>
  );
}

export default Counter;
```

**关键解释** ：

- 你只需要声明「count 状态」和「视图依赖 count 渲染」，以及「点击按钮后 count 要更新为 count+1」。
- 至于「点击按钮后如何找到 p 标签、如何修改它的内容、如何更新 DOM」，这些细节完全由 React 接管，你无需关心。

##### 2\. 对比命令式开发（原生 JS 实现相同功能）

javascript

运行

```javascript
// 命令式：每一步都要手动写
const container = document.getElementById('counter');

// 1. 创建元素
const p = document.createElement('p');
p.textContent = '当前计数：0';
const button = document.createElement('button');
button.textContent = '点击加1';

// 2. 添加到DOM
container.appendChild(p);
container.appendChild(button);

// 3. 手动管理状态和DOM更新
let count = 0;
button.addEventListener('click', () => {
  count += 1;
  // 手动修改DOM内容
  p.textContent = \`当前计数：${count}\`;
});
```

可以明显看到：命令式需要手动操作 DOM 的每一步，而 React 声明式只需要描述「想要的结果」。

#### 三、React 声明式开发的核心优势

1. **代码更简洁易维护** ：无需关注 DOM 操作细节，只需聚焦业务逻辑（状态和视图的映射）。
2. **可预测性更强** ：视图完全由状态决定，状态变化是唯一的视图更新源，调试时只需跟踪状态。
3. **复用性更高** ：声明式的组件可以轻松复用（比如上面的 Counter 组件，可在任意地方导入使用）。

#### 四、进阶场景：条件渲染 / 列表渲染（声明式的典型用法）

##### 1\. 条件渲染（声明「满足 XX 条件时显示 XX 内容」）

##### 2\. 列表渲染（声明「把数组渲染成列表」）

jsx

```jsx
function TodoList({ todos }) {
  // 声明：把todos数组渲染成li列表，无需手动循环创建DOM
  return (
    <ul>
      {todos.map((todo) => (
        <li key={todo.id}>{todo.text}</li>
      ))}
    </ul>
  );
}
```

### 总结

1. React 声明式开发的核心是「 **描述结果而非步骤** 」：只需定义状态和视图的映射关系，React 自动处理 DOM 更新。
2. 核心逻辑是「 **状态驱动视图** 」：视图完全由状态决定，状态变化是视图更新的唯一来源。
3. 优势：代码简洁、可预测性强、易维护，这也是 React 相比传统命令式开发的核心价值。
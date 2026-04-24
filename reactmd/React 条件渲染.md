React 条件渲染

React 中的条件渲染是指根据不同的条件（比如状态、属性、数据等）来决定渲染哪些组件或元素，它的核心思想和普通 JavaScript 中的条件判断完全一致，只是把判断逻辑和 JSX 结合了起来。

下面我会用由浅入深的方式，讲解 React 中最常用的几种条件渲染方式：

### 1\. 基础：if/else 条件判断

这是最直观、最容易理解的方式，适合逻辑较复杂的场景。

jsx

```jsx
import React, { useState } from 'react';

function UserGreeting() {
  // 定义状态：模拟用户是否登录
  const [isLoggedIn, setIsLoggedIn] = useState(false);

  // 核心：根据条件返回不同的 JSX
  if (isLoggedIn) {
    return <h1>欢迎回来！</h1>;
  } else {
    return <h1>请先登录。</h1>;
  }

  // 也可以把判断逻辑抽成函数，更清晰
  // function renderGreeting() {
  //   if (isLoggedIn) {
  //     return <h1>欢迎回来！</h1>;
  //   }
  //   return <h1>请先登录。</h1>;
  // }
  // return <div>{renderGreeting()}</div>;
}

export default UserGreeting;
```

### 2\. 简洁：三元运算符

适合在 JSX 内部直接写简单的二选一逻辑，是 React 中最常用的方式之一。

jsx

```jsx
import React, { useState } from 'react';

function ToggleButton() {
  const [isOn, setIsOn] = useState(false);

  return (
    <div>
      {/* 三元运算符：条件 ? 满足时渲染 : 不满足时渲染 */}
      <p>开关状态：{isOn ? '开启' : '关闭'}</p>
      <button onClick={() => setIsOn(!isOn)}>
        {isOn ? '关闭开关' : '打开开关'}
      </button>
    </div>
  );
}

export default ToggleButton;
```

### 3\. 极简：与运算符（&&）

适合「满足条件就渲染，不满足就不渲染（空）」的场景（单条件场景）。

jsx

```jsx
import React, { useState } from 'react';

function Notification() {
  // 模拟未读消息数量
  const [unreadCount, setUnreadCount] = useState(3);

  return (
    <div>
      <h1>消息中心</h1>
      {/* && 逻辑：只有左边为 true 时，才会渲染右边的内容 */}
      {unreadCount > 0 && (
        <p>你有 {unreadCount} 条未读消息</p>
      )}
      {/* 如果 unreadCount 为 0，上面的内容会直接不渲染 */}
    </div>
  );
}

export default Notification;
```

⚠️ 注意：如果左边是 0/NaN/'' 等「假值」，React 会渲染这个假值本身（比如 0），因此建议确保左边是布尔值（比如用 `unreadCount > 0` 而不是直接 `unreadCount` ）。

### 4\. 进阶：元素变量

把要渲染的元素赋值给变量，适合需要复用或逻辑较复杂的场景。

jsx

```jsx
import React, { useState } from 'react';

function RoleBasedContent() {
  const [userRole, setUserRole] = useState('visitor'); // visitor / editor / admin

  // 定义变量存储要渲染的内容
  let content;
  if (userRole === 'admin') {
    content = <div>管理员：可管理所有内容</div>;
  } else if (userRole === 'editor') {
    content = <div>编辑：可编辑内容</div>;
  } else {
    content = <div>访客：仅可查看内容</div>;
  }

  return (
    <div>
      <h2>根据角色展示内容</h2>
      {content} {/* 渲染变量 */}
      <button onClick={() => setUserRole('admin')}>切换为管理员</button>
      <button onClick={() => setUserRole('editor')}>切换为编辑</button>
      <button onClick={() => setUserRole('visitor')}>切换为访客</button>
    </div>
  );
}

export default RoleBasedContent;
```

### 5\. 特殊：阻止渲染（返回 null）

如果组件在某些条件下不需要渲染任何内容，可以直接返回 `null` 。

jsx

```jsx
import React, { useState } from 'react';

function HiddenComponent() {
  const [isHidden, setIsHidden] = useState(true);

  // 返回 null 时，组件不会渲染任何内容
  if (isHidden) {
    return null;
  }

  return <div>这个组件只有在不隐藏时才会显示</div>;
}

export default HiddenComponent;
```

---

### 总结

1. **if/else** ：适合复杂逻辑，可读性高，推荐用于组件级别的条件判断；
2. **三元运算符** ：React 中最常用，适合 JSX 内部的二选一简单逻辑；
3. **&& 运算符** ：适合「满足条件就渲染，否则不渲染」的单条件场景，注意左边要确保是布尔值；
4. 核心原则：React 条件渲染本质是 **用 JavaScript 控制 JSX 的输出** ，所有 JavaScript 条件语法都可以复用。

你可以根据场景选择最合适的方式：简单逻辑用三元 /&&，复杂逻辑用 if/else/ 元素变量，让代码既清晰又易维护。

除了上述三种方式，React 还有哪些条件渲染的方式？

如何在条件渲染中传递参数？

条件渲染和 React 的虚拟 DOM 有什么关系？
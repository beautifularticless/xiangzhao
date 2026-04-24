React 条件判断

在 React 中进行条件判断是开发中非常基础且高频的需求，核心思路是根据不同的条件渲染不同的 UI 内容。下面我会由浅入深介绍几种最常用的条件判断方式，全部基于 React 函数组件（当前主流写法）。

### 一、基础条件判断方式

#### 1\. if/else 语句（最通用）

适合逻辑较复杂、分支较多的场景，在组件内先通过 if/else 判断，再决定渲染什么内容。

jsx

```jsx
import React from 'react';

// 示例：根据用户登录状态展示不同内容
function UserGreeting({ isLoggedIn }) {
  // 条件判断逻辑
  if (isLoggedIn) {
    return <h1>欢迎回来！</h1>;
  } else {
    return <h1>请先登录。</h1>;
  }
}

// 使用组件
function App() {
  return (
    <div>
      <UserGreeting isLoggedIn={true} />
    </div>
  );
}

export default App;
```

#### 2\. 三元运算符（内联判断首选）

适合简单的二选一场景，可以直接写在 JSX 中，是 React 中最常用的内联条件判断方式。

jsx

```jsx
import React from 'react';

function StatusBadge({ status }) {
  return (
    <div>
      {/* 三元运算符：条件 ? 满足时渲染 : 不满足时渲染 */}
      <span style={{ 
        color: status === 'success' ? 'green' : 'red',
        fontWeight: 'bold'
      }}>
        {status === 'success' ? '操作成功' : '操作失败'}
      </span>
    </div>
  );
}

function App() {
  return <StatusBadge status="success" />;
}

export default App;
```

#### 3\. 与运算符（&&）：仅渲染 “真” 分支

适合 “满足条件就渲染，不满足就不渲染” 的场景（单分支），核心逻辑： `条件 && 要渲染的内容` （条件为 false 时，React 会忽略这个表达式，渲染 `null` ）。

jsx

```jsx
import React from 'react';

function Notification({ hasUnreadMsg }) {
  return (
    <div>
      <h3>消息中心</h3>
      {/* 有未读消息时，显示小红点提示 */}
      {hasUnreadMsg && <span style={{ color: 'red' }}>（有未读）</span>}
    </div>
  );
}

function App() {
  return <Notification hasUnreadMsg={true} />;
}

export default App;
```

#### 4\. 元素变量（抽离复杂判断）

适合需要先判断再把结果赋值给变量，最后渲染变量的场景，让 JSX 更简洁。

jsx

```jsx
import React from 'react';

function OrderStatus({ orderStatus }) {
  // 先定义变量存储要渲染的内容
  let statusElement;

  // 多分支条件判断
  switch (orderStatus) {
    case 'pending':
      statusElement = <span>待支付</span>;
      break;
    case 'paid':
      statusElement = <span>已支付</span>;
      break;
    case 'shipped':
      statusElement = <span>已发货</span>;
      break;
    default:
      statusElement = <span>已取消</span>;
  }

  // 渲染变量
  return <div>订单状态：{statusElement}</div>;
}

function App() {
  return <OrderStatus orderStatus="paid" />;
}

export default App;
```

### 二、注意事项

1. **避免渲染 undefined** ：如果条件判断后没有返回任何内容，要确保返回 `null` 而非 `undefined` （React 不允许组件返回 undefined）。
	jsx
	```jsx
	// 错误示例
	function EmptyComponent() {
	  if (false) { return <div>内容</div>; }
	  // 无返回值 → 返回 undefined → 报错
	}
	// 正确示例
	function EmptyComponent() {
	  if (false) { return <div>内容</div>; }
	  return null; // 明确返回 null
	}
	```
2. **复杂条件抽离成函数** ：如果条件判断逻辑过长，建议抽离成独立函数，提升可读性。
	jsx
	```jsx
	function getOrderAction(status) {
	  if (status === 'pending') {
	    return <button>立即支付</button>;
	  } else if (status === 'paid') {
	    return <button>申请退款</button>;
	  }
	  return <button disabled>暂无操作</button>;
	}
	function OrderAction({ status }) {
	  return <div>{getOrderAction(status)}</div>;
	}
	```

### 总结

1. **简单二选一** ：优先用 **三元运算符** （内联写在 JSX 中）；
2. **单分支渲染** ：用 \*\*&& 运算符 \*\*（满足条件才渲染，否则不渲染）；
3. **复杂多分支** ：用 `if/else` 或 `switch` + **元素变量** ，或抽离成独立函数；
4. 核心原则：确保组件始终返回有效的 React 元素或 `null` ，避免返回 `undefined` 。

除了这些，还有哪些条件判断方式？

如何在 React 中进行嵌套条件判断？

条件判断会影响 React 组件的性能吗？
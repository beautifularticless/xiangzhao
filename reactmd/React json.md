react json

在 React 开发中，JSON（JavaScript Object Notation）是最常用的数据格式之一，主要用于 **数据交互** （如接口请求返回）、 **数据存储** （如 localStorage）和 **数据渲染** 。下面我会从核心使用场景入手，带你掌握 React 中 JSON 的关键用法。

### 一、核心使用场景与代码示例

#### 1\. 渲染 JSON 数据（最基础场景）

React 组件中最常见的需求是把 JSON 数据渲染到页面上，比如从接口获取的列表数据。

jsx

```jsx
import React from 'react';

function UserList() {
  // 模拟接口返回的 JSON 数据（实际开发中从 API 获取）
  const userJson = \`[
    {"id": 1, "name": "张三", "age": 25},
    {"id": 2, "name": "李四", "age": 30}
  ]\`;

  // 第一步：将 JSON 字符串转为 JavaScript 对象/数组（关键）
  const users = JSON.parse(userJson);

  return (
    <div>
      <h2>用户列表</h2>
      <ul>
        {/* 第二步：遍历渲染 JSON 解析后的数据 */}
        {users.map((user) => (
          <li key={user.id}>
            姓名：{user.name}，年龄：{user.age}
          </li>
        ))}
      </ul>
    </div>
  );
}

export default UserList;
```

**关键解释** ：

- `JSON.parse()` ：将 JSON 字符串转为 React 可操作的 JS 对象 / 数组（必须！直接渲染 JSON 字符串会显示纯文本）。
- 渲染列表时必须加 `key` （用唯一标识如 `id` ），这是 React 的性能优化要求。

#### 2\. 将 React 数据转为 JSON（如存储 / 提交接口）

当需要把 React 组件中的状态数据存到 localStorage，或提交给后端接口时，需要用 `JSON.stringify()` 转为 JSON 字符串。

jsx

```jsx
import React, { useState, useEffect } from 'react';

function UserForm() {
  // 组件状态（JS 对象）
  const [user, setUser] = useState({ name: "王五", age: 28 });

  // 示例1：将状态存入 localStorage（需转为 JSON 字符串）
  useEffect(() => {
    // JS 对象 → JSON 字符串
    const userJson = JSON.stringify(user);
    localStorage.setItem("userInfo", userJson);
  }, [user]);

  // 示例2：提交数据到后端接口（请求体需传 JSON 字符串）
  const handleSubmit = async () => {
    try {
      const response = await fetch("/api/user", {
        method: "POST",
        headers: {
          "Content-Type": "application/json", // 告诉后端接收的是 JSON
        },
        body: JSON.stringify(user), // JS 对象 → JSON 字符串
      });
      const result = await response.json(); // 接口返回的 JSON → JS 对象
      console.log("提交成功：", result);
    } catch (error) {
      console.error("提交失败：", error);
    }
  };

  return (
    <div>
      <button onClick={handleSubmit}>提交用户信息</button>
    </div>
  );
}

export default UserForm;
```

**关键解释** ：

- `JSON.stringify()` ：将 JS 对象 / 数组转为 JSON 字符串（localStorage / 接口请求只能存字符串）。
- 接口请求时需设置 `Content-Type: application/json` ，后端才能正确解析 JSON 数据。
- `response.json()` ：将接口返回的 JSON 字符串自动转为 JS 对象（无需手动 `JSON.parse` ）。

#### 3\. 处理 JSON 解析异常（健壮性优化）

如果 JSON 格式错误， `JSON.parse()` 会报错，需加异常捕获：

jsx

```jsx
function SafeJsonParse() {
  const invalidJson = \`{"name": "赵六", "age": }\`; // 格式错误的 JSON
  let data = null;

  try {
    data = JSON.parse(invalidJson);
  } catch (error) {
    console.error("JSON 解析失败：", error.message);
    data = { name: "默认用户", age: 0 }; // 兜底默认值
  }

  return <div>当前用户：{data.name}</div>;
}
```

### 二、总结

1. **核心方法** ： `JSON.parse()` （JSON 字符串 → JS 对象）、 `JSON.stringify()` （JS 对象 → JSON 字符串）是 React 中处理 JSON 的基础。
2. **渲染场景** ：接口返回的 JSON 数据需先 `parse` 转为 JS 数据，再通过 React 列表 / 条件渲染展示。
3. **异常处理** ：解析 JSON 时必须加 `try/catch` ，避免格式错误导致组件崩溃，同时设置兜底默认值。

如何在 React 中使用 JSON.stringify() 方法？

除了上述场景，JSON 在 React 中还有哪些应用？

在 React 中处理 JSON 数据时，有哪些常见的错误需要避免？
react 渲染列表

在 React 中渲染列表是非常常见的场景，核心是使用 JavaScript 的数组方法（如 `map()` ）遍历数据，并为每个列表项提供唯一的 `key` 属性。下面我会从基础到进阶，一步步教你如何正确渲染列表。

### 一、基础用法（最常用）

这是渲染列表的标准方式，适用于绝大多数场景。

#### 完整代码示例

jsx

```jsx
import React from 'react';

function UserList() {
  // 模拟列表数据（通常来自接口/状态）
  const users = [
    { id: 1, name: '张三', age: 25 },
    { id: 2, name: '李四', age: 28 },
    { id: 3, name: '王五', age: 30 }
  ];

  return (
    <div className="user-list">
      <h2>用户列表</h2>
      {/* 核心：用 map 遍历数组，渲染每个列表项 */}
      {users.map((user) => (
        // 必须加唯一的 key（优先用数据自身的唯一标识，如 id）
        <div key={user.id} className="user-item">
          <p>姓名：{user.name}</p>
          <p>年龄：{user.age}</p>
        </div>
      ))}
    </div>
  );
}

export default UserList;
```

#### 关键说明

1. **`map()` 方法** ：遍历数组，为每个元素返回一个 React 元素（如 `<div>` / `<li>` 等），最终生成一个元素数组，React 会自动渲染这个数组。
2. **`key` 属性** ：
	- 作用：帮助 React 识别每个列表项的唯一性，优化重渲染性能（避免不必要的 DOM 操作）。
	- 要求：必须是 **稳定、唯一、不可变** 的（不能用数组索引，除非列表永不增删改）。
	- 推荐：使用数据自身的唯一标识（如 id、uuid）；如果没有，可手动生成（如 `nanoid` 库）。
3. **渲染容器** ：列表项通常需要包裹在一个容器中（如 `<div>` / `<ul>` ），避免多个根元素（React 18 后支持多根元素，但列表建议统一包裹）。

### 二、进阶用法：渲染复杂列表（如表格 / 条件渲染）

如果列表需要条件过滤、嵌套，或渲染为表格 / 列表标签（ `<ul>/<li>` ），写法如下：

jsx

```jsx
import React from 'react';

function FilteredUserList() {
  const users = [
    { id: 1, name: '张三', age: 25, status: 'active' },
    { id: 2, name: '李四', age: 28, status: 'inactive' },
    { id: 3, name: '王五', age: 30, status: 'active' }
  ];

  // 条件过滤：只显示活跃用户
  const activeUsers = users.filter(user => user.status === 'active');

  return (
    <div>
      <h2>活跃用户列表（表格形式）</h2>
      <table border="1">
        <thead>
          <tr>
            <th>ID</th>
            <th>姓名</th>
            <th>年龄</th>
          </tr>
        </thead>
        <tbody>
          {/* 遍历过滤后的数组 */}
          {activeUsers.map((user) => (
            <tr key={user.id}>
              <td>{user.id}</td>
              <td>{user.name}</td>
              <td>{user.age}</td>
            </tr>
          ))}
        </tbody>
      </table>

      <h2>无序列表形式</h2>
      <ul>
        {users.map((user) => (
          <li key={user.id}>
            {user.name} - {user.status === 'active' ? '活跃' : '非活跃'}
          </li>
        ))}
      </ul>
    </div>
  );
}

export default FilteredUserList;
```

### 三、注意事项（新手避坑）

1. **不要用数组索引作为 key** ：如果列表会增删、排序，索引会变化，导致 React 误判，引发渲染错误或性能问题。示例：
	jsx
	```jsx
	// ❌ 错误（不推荐）
	{users.map((user, index) => (
	  <div key={index}>{user.name}</div>
	))}
	// ✅ 正确（有唯一 id 时）
	{users.map((user) => (
	  <div key={user.id}>{user.name}</div>
	))}
	```
2. **空列表处理** ：当列表数据为空时，显示友好提示，提升用户体验：
	jsx
	```jsx
	{activeUsers.length === 0 ? (
	  <p>暂无活跃用户</p>
	) : (
	  activeUsers.map((user) => <tr key={user.id}>...</tr>)
	)}
	```
3. **提取列表项为独立组件** ：复杂列表项建议拆分为单独组件，让代码更清晰：
	jsx
	```jsx
	// 单独的列表项组件
	function UserItem({ user }) {
	  return (
	    <div className="user-item">
	      <p>姓名：{user.name}</p>
	      <p>年龄：{user.age}</p>
	    </div>
	  );
	}
	// 列表组件中使用
	function UserList() {
	  const users = [...];
	  return (
	    <div>
	      {users.map(user => (
	        <UserItem key={user.id} user={user} />
	      ))}
	    </div>
	  );
	}
	```

### 总结

1. React 渲染列表的核心是用 `数组.map()` 遍历数据，为每个项返回 React 元素。
2. 必须为列表项设置 **唯一、稳定** 的 `key` （优先用数据自身的 id，避免用索引）。
3. 复杂场景可结合 `filter()` 做条件过滤，或拆分列表项为独立组件，同时处理空列表提升体验。

如何使用 React 渲染复杂列表？

如何优化 React 列表渲染性能？

React 中 keys 的作用是什么？
react key

### React Key 详解

`key` 是 React 中用于标识列表元素唯一性的特殊属性，核心作用是帮助 React 高效地识别列表中哪些元素发生了变化（新增、删除、重排），从而优化 DOM 更新性能，避免不必要的渲染和错误。

#### 一、为什么需要 key？

React 的虚拟 DOM 对比（Diffing）算法在处理列表时，如果没有 `key` ，会默认使用元素的 **索引** 作为隐式 key，但这会导致两个问题：

1. **性能问题** ：列表重排 / 增删时，React 无法精准识别元素，可能会重新创建 / 更新大量 DOM 节点；
2. **逻辑错误** ：如果列表元素包含状态（如输入框内容），索引作为 key 会导致状态错位。

#### 二、正确使用 key 的方式

##### 1\. 核心原则

- `key` 必须是 **唯一且稳定** 的（同一列表内不重复，元素重排 / 增删后 key 不变化）；
- `key` 只需要在 **列表上下文** 中唯一（无需全局唯一）；
- `key` 应直接赋值给列表的根元素（而非子元素）。

##### 2\. 推荐用法（优先级从高到低）

###### （1）使用数据自身的唯一标识（最优）

如果列表数据来自后端，通常会有 `id` / `uuid` 等唯一字段，这是最理想的 key：

jsx

```jsx
const TodoList = ({ todos }) => {
  return (
    <ul>
      {/* 推荐：使用数据自身的 id 作为 key */}
      {todos.map(todo => (
        <li key={todo.id}>{todo.text}</li>
      ))}
    </ul>
  );
};
```

###### （2）手动生成稳定的唯一 key

如果数据没有天然唯一标识，可通过哈希 / 拼接字段生成（避免用随机数）：

jsx

```jsx
const UserList = ({ users }) => {
  return (
    <div>
      {users.map(user => {
        // 拼接姓名+手机号生成唯一 key（确保组合唯一）
        const key = \`${user.name}-${user.phone}\`;
        return <div key={key}>{user.name}</div>;
      })}
    </div>
  );
};
```

###### （3）万不得已才用索引（不推荐）

仅当列表 **永不增删 / 重排** （纯静态列表）时，可临时用索引：

jsx

```jsx
const StaticList = ({ items }) => {
  return (
    <ul>
      {/* 不推荐：仅静态列表可用 */}
      {items.map((item, index) => (
        <li key={index}>{item}</li>
      ))}
    </ul>
  );
};
```

#### 三、常见错误用法

1. **使用随机数作为 key** ：每次渲染都会生成新 key，React 会认为所有元素都是新的，直接销毁并重建 DOM，完全失去优化意义：
	jsx
	```jsx
	// 错误示例！
	{todos.map(todo => (
	  <li key={Math.random()}>{todo.text}</li>
	))}
	```
2. **key 传递到子组件** ：key 是 React 保留属性，不会传递给子组件，若子组件需要唯一标识，需单独传参：
	jsx
	```jsx
	// 错误：子组件无法获取 props.key
	const TodoItem = ({ key, text }) => <li>{text}</li>;
	// 正确：单独传递 id 作为标识
	const TodoItem = ({ id, text }) => <li>{text}</li>;
	{todos.map(todo => (
	  <TodoItem key={todo.id} id={todo.id} text={todo.text} />
	))}
	```

### 总结

1. `key` 的核心作用是帮助 React 精准识别列表元素，优化 DOM 更新性能；
2. 优先使用数据自身的唯一标识（如 `id` ）作为 key，避免用索引 / 随机数；
3. `key` 只需在列表内唯一，且不能传递给子组件（需单独传参）。

在 React 中，使用随机数作为 key 会有什么问题？

除了数据自身的唯一标识和手动生成稳定的唯一 key，还有其他方式可以设置 React key 吗？

如何在 React 中使用 key 来优化列表性能？
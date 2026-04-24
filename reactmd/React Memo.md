React Memo

### React.memo 详解

React.memo 是 React 提供的一个 **高阶组件 (HOC)** ，核心作用是 **优化函数组件的重渲染性能** ，避免不必要的重复渲染。

#### 一、核心概念（通俗理解）

默认情况下，React 函数组件只要父组件重渲染，无论自身 props 是否变化，都会跟着重渲染。React.memo 就像给组件加了一个 “缓存开关”：它会对比组件 **前后两次的 props** ，如果 props 没有变化，就直接复用上次渲染的结果，不执行组件的重新渲染；只有 props 变化时，才会重新渲染。

#### 二、基本用法

##### 1\. 基础使用（浅比较 props）

jsx

```jsx
import React from 'react';

// 定义一个普通的函数组件
const UserCard = ({ name, age }) => {
  console.log('UserCard 组件渲染了'); // 用于观察渲染次数
  return (
    <div>
      <h3>{name}</h3>
      <p>年龄：{age}</p>
    </div>
  );
};

// 用 React.memo 包裹组件，开启 props 浅比较
const MemoizedUserCard = React.memo(UserCard);

// 父组件
const ParentComponent = () => {
  const [count, setCount] = React.useState(0);
  
  return (
    <div>
      <button onClick={() => setCount(count + 1)}>点击次数：{count}</button>
      {/* 使用包裹后的组件 */}
      <MemoizedUserCard name="张三" age={20} />
    </div>
  );
};

export default ParentComponent;
```

**效果** ：点击按钮时，父组件的 `count` 变化会触发父组件重渲染，但 `MemoizedUserCard` 的 props（ `name` 、 `age` ）没有变化，因此控制台不会打印 “UserCard 组件渲染了”，组件不会重渲染。

##### 2\. 自定义比较逻辑（深比较）

默认情况下，React.memo 只会做 **浅比较** （只对比 props 里的基本类型值，引用类型如对象 / 数组只会对比引用地址）。如果需要对比引用类型的内容，可以传入第二个参数（自定义比较函数）：

jsx

```jsx
const UserCard = ({ user }) => {
  console.log('UserCard 组件渲染了');
  return (
    <div>
      <h3>{user.name}</h3>
      <p>年龄：{user.age}</p>
    </div>
  );
};

// 自定义比较函数：对比前后 props 中 user 对象的内容
const arePropsEqual = (prevProps, nextProps) => {
  return (
    prevProps.user.name === nextProps.user.name &&
    prevProps.user.age === nextProps.user.age
  );
};

// 传入自定义比较函数
const MemoizedUserCard = React.memo(UserCard, arePropsEqual);
```

**注意** ：自定义比较函数返回 `true` 表示 props 无变化（复用缓存），返回 `false` 表示 props 变化（重新渲染）。

#### 三、适用场景 & 注意事项

##### 适用场景

1. 组件接收的 props 是 **基本类型** （字符串、数字、布尔），且父组件频繁重渲染，但该组件的 props 很少变化；
2. 组件渲染成本较高（比如内部有复杂计算、大量 DOM 节点），优化收益明显。

##### 注意事项

1. **不要滥用** ：如果组件本身渲染成本低，使用 React.memo 会增加 “props 对比” 的开销，反而得不偿失；
2. 对 **引用类型 props** 无效（除非自定义深比较）：比如父组件每次传递新的对象 / 数组（ `{ name: '张三' }` ），即使内容相同，浅比较也会认为 props 变化，组件依然重渲染。此时需要配合 `useMemo` 缓存引用类型 props：
	jsx
	```jsx
	// 父组件中缓存引用类型 props
	const user = React.useMemo(() => ({ name: '张三', age: 20 }), []);
	<MemoizedUserCard user={user} />
	```
3. React.memo **只对比 props** ：如果组件内部使用了 `useState` 、 `useContext` 等状态，状态变化时依然会重渲染（这是正常的）。

### 总结

1. React.memo 是优化函数组件重渲染的高阶组件，核心逻辑是 **对比前后 props** ，无变化则复用渲染结果；
2. 默认做 **浅比较** ，引用类型 props 需配合 `useMemo` 缓存，或自定义深比较函数；
3. 仅在组件渲染成本高、且 props 很少变化时使用，避免滥用导致性能反降。

React.memo 与 shouldComponentUpdate 的区别是什么？

如何使用 React.memo 优化性能？

除了 React.memo，还有哪些方法可以优化 React 组件的性能？
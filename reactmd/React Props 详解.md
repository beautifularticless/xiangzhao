### React Props 详解

Props（Properties 的缩写）是 React 中组件间传递数据的核心方式，你可以把它理解为 **组件的 “输入参数”** —— 父组件通过 props 给子组件传值，子组件接收并使用这些值，且 props 是 **只读的** （不能在子组件中修改），这是 React 的核心原则之一。

#### 一、Props 的基础使用

##### 1\. 父组件传递 props

父组件在使用子组件时，通过 “属性名 = 值” 的形式传递数据，支持任意类型（字符串、数字、布尔、数组、对象、函数等）。

jsx

```jsx
// 父组件 Parent.js
import React from 'react';
import Child from './Child';

function Parent() {
  // 准备要传递的数据
  const userName = "小明";
  const age = 18;
  const hobbies = ["打球", "看书", "编程"];
  const greet = () => alert("你好！");

  return (
    <div>
      {/* 传递 props：字符串可直接写，非字符串需用 {} 包裹 */}
      <Child 
        name={userName} 
        age={age} 
        hobbies={hobbies} 
        isStudent={true} 
        sayHello={greet}
      />
    </div>
  );
}

export default Parent;
```

##### 2\. 子组件接收 props

子组件有两种接收方式：

- **方式 1：直接通过参数接收** （最常用）
- **方式 2：解构赋值** （简化代码，推荐）

jsx

```jsx
// 子组件 Child.js
import React from 'react';

// 方式1：直接接收 props 对象
// function Child(props) {
//   return (
//     <div>
//       <p>姓名：{props.name}</p>
//       <p>年龄：{props.age}</p>
//       <p>爱好：{props.hobbies.join('、')}</p>
//       <p>是否学生：{props.isStudent ? '是' : '否'}</p>
//       <button onClick={props.sayHello}>打招呼</button>
//     </div>
//   );
// }

// 方式2：解构赋值（更简洁）
function Child({ name, age, hobbies, isStudent, sayHello }) {
  return (
    <div>
      <p>姓名：{name}</p>
      <p>年龄：{age}</p>
      <p>爱好：{hobbies.join('、')}</p>
      <p>是否学生：{isStudent ? '是' : '否'}</p>
      <button onClick={sayHello}>打招呼</button>
    </div>
  );
}

export default Child;
```

#### 二、Props 的关键特性

1. **只读性** ：子组件绝对不能修改 props 的值，React 规定 props 是 “单向数据流”—— 数据只能从父组件流向子组件。如果需要修改，必须由父组件更新数据，再重新传递给子组件。
	jsx
	```jsx
	// ❌ 错误：不能修改 props
	function Child(props) {
	  props.age = 20; // 会报错
	  return <p>年龄：{props.age}</p>;
	}
	```
2. **默认值（defaultProps）** ：如果父组件没传递某个 props，可以给子组件设置默认值。
	jsx
	```jsx
	function Child({ name, age }) {
	  return (
	    <div>
	      <p>姓名：{name}</p>
	      <p>年龄：{age}</p>
	    </div>
	  );
	}
	// 设置默认值
	Child.defaultProps = {
	  name: "未知",
	  age: 0
	};
	// 父组件不传 props 时，子组件会显示默认值
	// <Child /> → 姓名：未知，年龄：0
	```
3. **类型校验（PropTypes）** ：推荐使用 `prop-types` 库校验 props 的类型，避免传错数据类型导致 bug（需先安装： `npm install prop-types` ）。
	jsx
	```jsx
	import React from 'react';
	import PropTypes from 'prop-types';
	function Child({ name, age, hobbies }) {
	  return (
	    <div>
	      <p>姓名：{name}</p>
	      <p>年龄：{age}</p>
	      <p>爱好：{hobbies.join('、')}</p>
	    </div>
	  );
	}
	// 校验 props 类型
	Child.propTypes = {
	  name: PropTypes.string.isRequired, // 字符串类型，且必须传递
	  age: PropTypes.number, // 数字类型
	  hobbies: PropTypes.array // 数组类型
	};
	export default Child;
	```
	如果父组件传错类型（比如给 `age` 传字符串），控制台会打印清晰的错误提示，方便你排查问题。

#### 三、Props 的常见使用场景

1. **传递静态数据** ：如文本、数字等固定值；
2. **传递动态数据** ：如父组件的 state，当 state 变化时，子组件的 props 会自动更新，实现视图刷新；
3. **传递函数** ：父组件把函数通过 props 传给子组件，子组件调用该函数，实现 “子组件向父组件传值”（React 单向数据流的补充）。
	jsx
	```jsx
	// 父组件
	function Parent() {
	  const [count, setCount] = React.useState(0);
	  // 定义修改 count 的函数
	  const increment = () => setCount(count + 1);
	  return (
	    <div>
	      <p>计数：{count}</p>
	      {/* 把函数传给子组件 */}
	      <Child onClick={increment} />
	    </div>
	  );
	}
	// 子组件
	function Child({ onClick }) {
	  // 调用父组件传过来的函数
	  return <button onClick={onClick}>点击加1</button>;
	}
	```

### 总结

1. **核心作用** ：Props 是 React 组件间传递数据的主要方式，实现父→子组件通信，且 props 只读不可修改；
2. **关键用法** ：支持传递任意类型数据（包括函数），可设置默认值和类型校验提升代码健壮性；
3. **核心原则** ：单向数据流 —— 数据从父组件流向子组件，子组件需通过调用父组件传递的函数间接修改数据。

React Props 如何在组件间进行深度嵌套传递？

如何在 React 中使用 Props 进行状态管理？

Props 和 State 有什么区别？
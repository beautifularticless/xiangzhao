## React函数组件定义的三种方法

使用React函数组件是一种简洁易读的方法。
函数组件是一个接受 props 并返回 React 元素的 JavaScript 函数。
基础语法：
// 方式 1：函数声明

```
function Welcome(props) {
  return <h1>Hello, {props.name}</h1>;
}
```

// 方式 2：箭头函数

```
const Welcome = (props) => {
  return <h1>Hello, {props.name}</h1>;
};
```

// 方式 3：简化写法（单行返回）

```
const Welcome = (props) => <h1>Hello, {props.name}</h1>;
```

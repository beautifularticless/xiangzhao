React Refs

### React Refs 详解

Refs 是 React 提供的一种 **直接访问 DOM 元素或组件实例** 的方式，它可以绕过 React 的声明式数据流，直接操作底层 DOM（比如获取输入框的值、聚焦输入框、调用组件的方法等），适用于那些无法通过 props/state 优雅实现的场景。

---

## 一、核心概念（新手友好版）

可以把 Refs 理解为：给 DOM 元素 / 组件贴一个 “标签”，通过这个标签能直接找到并操作这个元素 / 组件，就像给 DOM 元素起了个 “外号”，需要时直接喊外号就能找到它。

### 适用场景（什么时候用）

1. 管理焦点（如输入框自动聚焦）、文本选择或媒体播放
2. 触发强制动画
3. 与第三方 DOM 库集成（如 jQuery）
4. 避免过度使用：能通过 state/props 实现的逻辑，优先不用 Refs（遵循 React 声明式思想）

---

## 二、使用方式（从简单到进阶）

React 提供了 3 种常用的创建 Refs 的方式，新手优先掌握 **useRef（函数组件）** 和 **createRef（类组件）** 。

### 1\. 函数组件：useRef（最常用）

`useRef` 是 React Hooks 提供的 API，返回一个 **可变的 ref 对象** ，其 `.current` 属性可以存储任意值（DOM 元素、组件实例、普通数据），且修改 `.current` 不会触发组件重新渲染。

#### 示例：输入框自动聚焦 + 获取输入值

jsx

```jsx
import { useRef, useEffect } from 'react';

function InputDemo() {
  // 1. 创建 ref 对象，初始值为 null
  const inputRef = useRef(null);

  // 2. 组件挂载后，通过 ref 操作 DOM（聚焦输入框）
  useEffect(() => {
    // inputRef.current 指向真实的 input DOM 元素
    inputRef.current.focus(); 
  }, []);

  // 3. 获取输入框的值
  const getInputValue = () => {
    alert('输入框的值：' + inputRef.current.value);
  };

  return (
    <div>
      {/* 4. 将 ref 绑定到 DOM 元素 */}
      <input ref={inputRef} type="text" placeholder="自动聚焦的输入框" />
      <button onClick={getInputValue}>获取值</button>
    </div>
  );
}

export default InputDemo;
```

#### 关键解释：

- `useRef(null)` ：创建一个 ref 对象，初始 `.current` 为 `null`
- `<input ref={inputRef} />` ：将 ref 绑定到 input 元素，组件挂载后， `inputRef.current` 会自动指向这个 input 的 DOM 节点
- `useEffect` 依赖空数组：确保只在组件挂载后执行一次聚焦操作

### 2\. 类组件：createRef

类组件中使用 `React.createRef()` 创建 ref，用法和 `useRef` 类似，但 `createRef` 每次渲染都会创建新的 ref 对象（而 `useRef` 会复用）。

jsx

```jsx
import React from 'react';

class ClassInputDemo extends React.Component {
  // 1. 创建 ref 对象
  inputRef = React.createRef();

  componentDidMount() {
    // 2. 挂载后聚焦
    this.inputRef.current.focus();
  }

  getValue = () => {
    alert(this.inputRef.current.value);
  };

  render() {
    return (
      <div>
        <input ref={this.inputRef} type="text" placeholder="类组件输入框" />
        <button onClick={this.getValue}>获取值</button>
      </div>
    );
  }
}

export default ClassInputDemo;
```

### 3\. 回调 Refs（进阶，了解即可）

除了 `useRef/createRef` ，还可以通过回调函数手动绑定 ref，灵活性更高（比如动态绑定 / 解绑）。

jsx

```jsx
import { useEffect, useState } from 'react';

function CallbackRefDemo() {
  const [inputEl, setInputEl] = useState(null);

  // 回调函数：元素挂载时执行，参数是 DOM 元素
  const bindRef = (el) => {
    setInputEl(el);
  };

  useEffect(() => {
    if (inputEl) {
      inputEl.focus();
    }
  }, [inputEl]);

  return <input ref={bindRef} type="text" placeholder="回调 Ref" />;
}
```

---

## 三、注意事项（新手避坑）

1. **函数组件无法直接绑定 ref** ：如果想给自定义函数组件加 ref，需要用 `forwardRef` 转发 ref（后续进阶内容）。
	jsx
	```jsx
	// 转发 ref 示例（自定义输入框组件）
	const CustomInput = React.forwardRef((props, ref) => {
	  return <input ref={ref} {...props} />;
	});
	// 使用
	function Parent() {
	  const inputRef = useRef(null);
	  useEffect(() => {
	    inputRef.current.focus();
	  }, []);
	  return <CustomInput ref={inputRef} placeholder="转发 ref 的输入框" />;
	}
	```
2. **不要在渲染阶段修改 ref** ：ref 的修改（如 `inputRef.current = xxx` ）应放在 `useEffect` 、事件处理函数中，避免触发无限渲染。
3. **优先用声明式逻辑** ：比如 “输入框值变化” 应通过 `onChange` + `state` 实现，而不是直接读 ref 的 value（Ref 只用于特殊场景）。

---

### 总结

1. **核心作用** ：Refs 用于直接访问 DOM 元素 / 组件实例，绕过 React 声明式数据流，适用于聚焦、操作第三方库等场景。
2. **常用方式** ：函数组件用 `useRef` （推荐），类组件用 `createRef` ，回调 Ref 灵活性更高但较少用。
3. **避坑要点** ：函数组件需用 `forwardRef` 转发 ref，避免在渲染阶段修改 ref，优先用 state/props 实现逻辑。

类组件中如何使用 Refs？

Refs 会导致性能问题吗？

Refs 与 React 的状态管理有什么关系？
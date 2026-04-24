React 表单与事件

React 中的表单和事件处理是前端开发的核心知识点之一，与原生 HTML 表单相比，React 更推崇 **受控组件** 的方式来管理表单状态，让数据和 UI 保持同步。下面我会从基础概念到实际案例，由浅入深地讲解。

### 一、React 事件处理基础

React 事件处理和原生 DOM 事件类似，但有几个关键区别：

1. React 事件采用 **小驼峰命名** （如 `onClick` 而非 `onclick` ）
2. 事件处理函数需传入 **函数引用** （而非字符串）
3. 可以通过 `e.preventDefault()` 阻止默认行为（如表单提交）

#### 简单事件示例

jsx

```jsx
import React from 'react';

function ButtonClick() {
  // 定义事件处理函数
  const handleClick = (e) => {
    e.preventDefault(); // 阻止默认行为（如果有）
    alert('按钮被点击了！');
  };

  return (
    <button onClick={handleClick}>点击我</button>
  );
}

export default ButtonClick;
```

### 二、React 表单处理（核心：受控组件）

#### 1\. 受控组件的概念

受控组件是指 **表单元素的值由 React 状态（state）控制** 的组件。

- 表单元素的值 = state 中的值
- 输入变化时触发事件，更新 state
- state 变化 → 组件重新渲染 → 表单值同步更新

#### 2\. 常见表单元素的受控实现

##### （1）单行输入框（input \[type="text"\]）

jsx

```jsx
import React, { useState } from 'react';

function TextInput() {
  // 初始化 state 存储输入值
  const [inputValue, setInputValue] = useState('');

  // 处理输入变化
  const handleChange = (e) => {
    setInputValue(e.target.value); // 将输入值同步到 state
  };

  // 处理表单提交
  const handleSubmit = (e) => {
    e.preventDefault(); // 阻止表单默认提交行为
    alert(\`你输入的内容是：${inputValue}\`);
    setInputValue(''); // 提交后清空输入框
  };

  return (
    <form onSubmit={handleSubmit}>
      <label>
        输入内容：
        {/* value 绑定 state，onChange 绑定处理函数 */}
        <input 
          type="text" 
          value={inputValue} 
          onChange={handleChange} 
          placeholder="请输入..."
        />
      </label>
      <button type="submit">提交</button>
      <p>当前输入：{inputValue}</p>
    </form>
  );
}

export default TextInput;
```

##### （2）复选框（input \[type="checkbox"\]）

复选框的 `value` 不直接控制选中状态，而是通过 `checked` 属性：

jsx

```jsx
import React, { useState } from 'react';

function CheckboxInput() {
  const [isChecked, setIsChecked] = useState(false);

  const handleCheck = (e) => {
    setIsChecked(e.target.checked);
  };

  return (
    <div>
      <label>
        <input 
          type="checkbox" 
          checked={isChecked} 
          onChange={handleCheck} 
        />
        同意协议
      </label>
      <p>是否勾选：{isChecked ? '是' : '否'}</p>
    </div>
  );
}

export default CheckboxInput;
```

##### （3）下拉选择框（select）

jsx

```jsx
import React, { useState } from 'react';

function SelectInput() {
  const [selectedValue, setSelectedValue] = useState('react');

  const handleSelect = (e) => {
    setSelectedValue(e.target.value);
  };

  return (
    <div>
      <select value={selectedValue} onChange={handleSelect}>
        <option value="react">React</option>
        <option value="vue">Vue</option>
        <option value="angular">Angular</option>
      </select>
      <p>选中的框架：{selectedValue}</p>
    </div>
  );
}

export default SelectInput;
```

#### 3\. 非受控组件（补充）

如果不想用 state 控制表单值（比如简单场景），可以用 **非受控组件** ，通过 `ref` 获取 DOM 元素的值：

jsx

```jsx
import React, { useRef } from 'react';

function UncontrolledInput() {
  // 创建 ref 引用
  const inputRef = useRef(null);

  const handleSubmit = (e) => {
    e.preventDefault();
    alert(\`输入的内容：${inputRef.current.value}\`);
    inputRef.current.value = ''; // 清空输入框
  };

  return (
    <form onSubmit={handleSubmit}>
      <input type="text" ref={inputRef} placeholder="请输入..." />
      <button type="submit">提交</button>
    </form>
  );
}

export default UncontrolledInput;
```

### 三、复杂表单：多输入项统一管理

实际开发中表单通常有多个输入项，可将 state 设计为对象，统一管理：

jsx

```jsx
import React, { useState } from 'react';

function ComplexForm() {
  // 初始化多字段 state
  const [formData, setFormData] = useState({
    username: '',
    password: '',
    gender: 'male',
    agree: false
  });

  // 通用处理函数：通过 name 属性匹配字段
  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;
    // 根据输入类型处理值（复选框用 checked，其他用 value）
    setFormData({
      ...formData,
      [name]: type === 'checkbox' ? checked : value
    });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log('表单数据：', formData);
    // 这里可发送请求提交表单
  };

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <label>用户名：</label>
        <input
          type="text"
          name="username"
          value={formData.username}
          onChange={handleChange}
        />
      </div>
      <div>
        <label>密码：</label>
        <input
          type="password"
          name="password"
          value={formData.password}
          onChange={handleChange}
        />
      </div>
      <div>
        <label>性别：</label>
        <input
          type="radio"
          name="gender"
          value="male"
          checked={formData.gender === 'male'}
          onChange={handleChange}
        /> 男
        <input
          type="radio"
          name="gender"
          value="female"
          checked={formData.gender === 'female'}
          onChange={handleChange}
        /> 女
      </div>
      <div>
        <input
          type="checkbox"
          name="agree"
          checked={formData.agree}
          onChange={handleChange}
        /> 同意用户协议
      </div>
      <button type="submit" disabled={!formData.agree}>提交</button>
    </form>
  );
}

export default ComplexForm;
```

### 总结

1. **React 事件** ：小驼峰命名、传函数引用、 `e.preventDefault()` 阻止默认行为。
2. **受控组件** ：表单值由 state 控制，通过 `onChange` 同步 state，是 React 表单的推荐写法。
3. **非受控组件** ：通过 `ref` 直接获取 DOM 值，适合简单场景；复杂表单建议用受控组件 + 对象型 state 统一管理。

核心原则：让 React 状态成为表单数据的 **唯一数据源** ，确保 UI 和数据始终同步。

如何在 React 中处理表单的验证？

受控组件和非受控组件的区别是什么？

如何在 React 中处理文件上传表单？
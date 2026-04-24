react 鼠标事件

React 中的鼠标事件是前端交互中最常用的事件类型之一，它基于原生 JavaScript 鼠标事件做了封装，使用方式更符合 React 的组件化思想，且能避免原生事件的一些兼容性问题。下面我会从基础用法、常用事件、事件对象、进阶用法等方面，帮你全面理解 React 中的鼠标事件。

### 一、React 鼠标事件的基础使用规则

1. React 事件采用 **小驼峰命名** （区别于原生的全小写），比如 `onClick` 而非 `onclick` 。
2. 事件处理函数需要以 **函数引用** 的形式传递（而非字符串）。
3. 事件处理函数中的 `this` 指向需要注意（推荐用箭头函数避免绑定问题）。

### 二、React 常用鼠标事件

以下是开发中最常用的鼠标事件，附简单示例：

表格

| 事件名 | 触发时机 |
| --- | --- |
| `onClick` | 鼠标点击元素后触发 |
| `onDoubleClick` | 鼠标双击元素后触发 |
| `onMouseDown` | 鼠标按下（任意键）时触发 |
| `onMouseUp` | 鼠标按键松开时触发 |
| `onMouseEnter` | 鼠标进入元素范围时触发（不冒泡） |
| `onMouseLeave` | 鼠标离开元素范围时触发（不冒泡） |
| `onMouseOver` | 鼠标进入元素或其子元素时触发（冒泡） |
| `onMouseOut` | 鼠标离开元素或其子元素时触发（冒泡） |
| `onMouseMove` | 鼠标在元素内移动时持续触发 |

#### 基础示例：常用鼠标事件演示

jsx

```jsx
import React from 'react';

function MouseEventDemo() {
  // 事件处理函数（推荐用箭头函数，避免this指向问题）
  const handleClick = (e) => {
    console.log('点击了元素', e);
  };

  const handleMouseEnter = () => {
    console.log('鼠标进入元素');
  };

  const handleMouseMove = (e) => {
    // 获取鼠标位置
    console.log('鼠标X坐标：', e.clientX, '鼠标Y坐标：', e.clientY);
  };

  return (
    <div 
      style={{ width: 200, height: 200, backgroundColor: '#f0f0f0', textAlign: 'center', lineHeight: '200px' }}
      onClick={handleClick}          // 点击
      onDoubleClick={() => console.log('双击了元素')} // 双击（直接写箭头函数）
      onMouseEnter={handleMouseEnter} // 鼠标进入
      onMouseLeave={() => console.log('鼠标离开')}   // 鼠标离开
      onMouseMove={handleMouseMove}   // 鼠标移动
    >
      鼠标事件演示
    </div>
  );
}

export default MouseEventDemo;
```

### 三、鼠标事件对象（SyntheticEvent）

React 封装了原生事件对象，提供了和原生事件几乎一致的属性，常用的有：

- `e.clientX` / `e.clientY` ：鼠标相对于浏览器视口的坐标。
- `e.pageX` / `e.pageY` ：鼠标相对于文档的坐标（包含滚动距离）。
- `e.target` ：触发事件的元素（React 封装后的元素）。
- `e.currentTarget` ：绑定事件的元素（等同于 `this` ）。
- `e.preventDefault()` ：阻止默认行为（比如阻止链接跳转）。
- `e.stopPropagation()` ：阻止事件冒泡。

#### 示例：阻止默认行为 + 获取鼠标坐标

jsx

```jsx
import React from 'react';

function MouseEventObject() {
  const handleLinkClick = (e) => {
    // 阻止链接默认跳转行为
    e.preventDefault();
    console.log('点击链接，鼠标坐标：', e.clientX, e.clientY);
  };

  return (
    <a href="https://www.baidu.com" onClick={handleLinkClick}>
      点击我（不会跳转）
    </a>
  );
}

export default MouseEventObject;
```

### 四、进阶用法：传递自定义参数

如果需要给事件处理函数传递额外参数（比如数据 ID），可以通过 **箭头函数包裹** 实现：

jsx

```jsx
import React from 'react';

function MouseEventWithParams() {
  // 带参数的事件处理函数
  const handleItemClick = (id, e) => {
    console.log('点击了第', id, '项，事件对象：', e);
  };

  return (
    <ul>
      {/* 传递自定义参数 id，同时保留事件对象 e */}
      <li onClick={(e) => handleItemClick(1, e)}>选项1</li>
      <li onClick={(e) => handleItemClick(2, e)}>选项2</li>
    </ul>
  );
}

export default MouseEventWithParams;
```

### 五、注意事项

1. `onMouseEnter` / `onMouseLeave` 不冒泡， `onMouseOver` / `onMouseOut` 冒泡：如果元素有子元素， `onMouseOver` 会在鼠标进入子元素时再次触发，而 `onMouseEnter` 不会，开发中优先用 `onMouseEnter` / `onMouseLeave` 实现 “鼠标移入 / 移出” 逻辑。
2. 避免在渲染时创建新函数（性能优化）：上面示例中直接写 `onClick={() => {}}` 会在每次渲染时创建新函数，频繁渲染的组件建议把函数抽离成独立方法（如前面的 `handleClick` ）。
3. 事件委托：React 内部已经实现了事件委托（所有事件都绑定到 document 上），无需手动做事件委托。

### 总结

1. React 鼠标事件采用 **小驼峰命名** （如 `onClick` ），事件处理函数传递函数引用而非字符串。
2. 常用鼠标事件包括 `onClick` / `onMouseEnter` / `onMouseMove` 等， `onMouseEnter` / `onMouseLeave` 无冒泡，适合做移入 / 移出交互。
3. React 封装的事件对象（SyntheticEvent）提供了 `e.clientX` / `preventDefault()` 等常用属性 / 方法，用法和原生一致，且兼容各浏览器。
4. 传递自定义参数时，通过箭头函数包裹事件处理函数，同时可保留事件对象。

如何在 React 中阻止鼠标事件的默认行为？

如何在 React 中获取鼠标事件的坐标？

除了鼠标事件，React 还支持哪些其他类型的事件？
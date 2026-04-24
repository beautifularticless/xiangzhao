## React 常见居中布局方法

你希望在 React 中使用**内联样式**（inline style）来实现 div 居中，而不是外部 CSS 文件，这在需要动态控制样式或组件独立封装时非常实用。我会把之前的几种居中方案都改写成 React 内联样式的形式。

### 方法 1：Flex 布局（内联样式，推荐）

这是内联样式中最常用、最灵活的居中方式：

```
import React from 'react';

function App() {
  // 定义内联样式对象
  const containerStyle = {
    height: '100vh', // 占满整个视口高度
    display: 'flex',
    justifyContent: 'center', // 水平居中
    alignItems: 'center', // 垂直居中
    overflow: 'hidden' // 可选：防止内容溢出
  };

  const boxStyle = {
    width: '300px',
    height: '200px',
    backgroundColor: '#f0f0f0',
    border: '1px solid #ddd',
    // 可选：让 div 内部文字也居中
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center'
  };

  return (
    <div style={containerStyle}>
      <div style={boxStyle}>
        我是内联样式居中的内容
      </div>
    </div>
  );
}

export default App;
```

### 方法 2：Grid 布局（内联样式，更简洁）

Grid 布局的内联样式写法更精简，同样支持水平 + 垂直居中：

jsx

```
import React from 'react';

function App() {
  const containerStyle = {
    height: '100vh',
    display: 'grid',
    placeItems: 'center' // 一行代码实现水平+垂直居中
  };

  const boxStyle = {
    width: '300px',
    height: '200px',
    backgroundColor: '#f0f0f0',
    border: '1px solid #ddd'
  };

  return (
    <div style={containerStyle}>
      <div style={boxStyle}>Grid 内联样式居中</div>
    </div>
  );
}

export default App;
```

### 方法 3：绝对定位 + transform（内联样式）

适合需要兼容旧浏览器的场景，内联样式写法如下：

jsx

```
import React from 'react';

function App() {
  const containerStyle = {
    height: '100vh',
    position: 'relative' // 作为子元素绝对定位的参考
  };

  const boxStyle = {
    width: '300px',
    height: '200px',
    backgroundColor: '#f0f0f0',
    border: '1px solid #ddd',
    position: 'absolute',
    left: '50%', // 水平偏移50%
    top: '50%', // 垂直偏移50%
    transform: 'translate(-50%, -50%)' // 偏移自身一半实现居中
  };

  return (
    <div style={containerStyle}>
      <div style={boxStyle}>绝对定位内联样式居中</div>
    </div>
  );
}

export default App;
```

### 方法 4：仅水平居中（内联样式）

如果只需要水平居中（比如文本 / 行内元素）：

jsx

```
import React from 'react';

function App() {
  const containerStyle = {
    textAlign: 'center', // 仅水平居中
    padding: '20px'
  };

  return (
    <div style={containerStyle}>
      <div>我只是水平居中的内容</div>
    </div>
  );
}

export default App;
```

### 关键注意事项（内联样式特有）

1. **样式属性名**：React 内联样式使用**驼峰命名法**，比如 `justify-content` 要写成 `justifyContent`，`background-color` 要写成 `backgroundColor`。
2. **值的格式**：所有值都必须是字符串，比如 `100vh` 不能写成 `100`，`solid` 不能省略引号。
3. **优先级**：内联样式的优先级高于外部 CSS，适合动态修改（比如通过 state 控制样式）。

### 总结

1. **内联样式首选 Flex/Grid**：写法简洁，支持水平 + 垂直居中，符合 React 组件化开发习惯。
2. **注意驼峰命名**：这是 React 内联样式和普通 CSS 最大的区别，避免因命名错误导致样式失效。
3. **动态控制**：内联样式可结合 state/props 动态修改（比如 `height: isFullScreen ? '100vh' : '50vh'`），灵活性更高。
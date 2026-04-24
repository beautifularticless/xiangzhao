## React Button

我会为你详细讲解 React 中按钮（Button）的创建和使用，从基础到进阶，覆盖新手最常用的场景。

### 1\. 基础按钮实现

这是 React 中最基础的按钮组件，包含点击事件、基本样式和状态管理。

jsx

```jsx
import React, { useState } from 'react';

// 基础按钮组件
const BasicButton = () => {
  // 状态管理：记录按钮点击次数
  const [clickCount, setClickCount] = useState(0);
  
  // 点击事件处理函数
  const handleClick = () => {
    setClickCount(prevCount => prevCount + 1);
    alert('按钮被点击了！');
  };

  return (
    <div style={{ padding: '20px' }}>
      {/* 基础按钮 */}
      <button 
        onClick={handleClick}
        style={{
          padding: '8px 16px',
          fontSize: '14px',
          cursor: 'pointer',
          backgroundColor: '#4CAF50',
          color: 'white',
          border: 'none',
          borderRadius: '4px',
          marginRight: '10px'
        }}
      >
        点击我 ({clickCount})
      </button>

      {/* 禁用状态按钮 */}
      <button 
        disabled
        style={{
          padding: '8px 16px',
          fontSize: '14px',
          cursor: 'not-allowed',
          backgroundColor: '#cccccc',
          color: '#666666',
          border: 'none',
          borderRadius: '4px'
        }}
      >
        禁用按钮
      </button>
    </div>
  );
};

export default BasicButton;
```

#### 关键代码解释：

- `useState(0)` ：用于管理按钮的点击次数状态，这是 React 函数组件的核心状态管理方式。
- `onClick={handleClick}` ：绑定点击事件，注意这里 **不要写 `handleClick()`** （否则会立即执行），只需传递函数引用。
- `disabled` ：原生 HTML 属性，用于禁用按钮，禁用后点击事件不会触发。
- `style` 属性：内联样式（React 中使用驼峰命名，如 `backgroundColor` 而非 `background-color` ）。

### 2\. 可复用的自定义按钮组件

在实际项目中，我们通常会封装可复用的按钮组件，支持自定义样式、类型、点击事件等。

jsx

```jsx
import React from 'react';
import PropTypes from 'prop-types'; // 推荐使用，做属性类型校验

// 自定义可复用按钮组件
const CustomButton = ({
  children,        // 按钮内容（文字/图标）
  onClick,         // 点击事件
  type = 'primary',// 按钮类型（primary/success/danger/default）
  disabled = false,// 是否禁用
  className = '',  // 自定义类名
  ...rest          // 其他原生按钮属性
}) => {
  // 根据类型定义不同样式
  const buttonStyles = {
    primary: {
      backgroundColor: '#1677ff',
      color: 'white',
      border: 'none'
    },
    success: {
      backgroundColor: '#52c41a',
      color: 'white',
      border: 'none'
    },
    danger: {
      backgroundColor: '#ff4d4f',
      color: 'white',
      border: 'none'
    },
    default: {
      backgroundColor: 'white',
      color: '#333',
      border: '1px solid #d9d9d9'
    }
  };

  return (
    <button
      onClick={onClick}
      disabled={disabled}
      className={className}
      style={{
        padding: '8px 20px',
        borderRadius: '4px',
        cursor: disabled ? 'not-allowed' : 'pointer',
        fontSize: '14px',
        ...buttonStyles[type] // 合并对应类型的样式
      }}
      {...rest} // 传递其他原生属性（如 id、name 等）
    >
      {children}
    </button>
  );
};

// 属性类型校验（可选但推荐）
CustomButton.propTypes = {
  children: PropTypes.node.isRequired,
  onClick: PropTypes.func,
  type: PropTypes.oneOf(['primary', 'success', 'danger', 'default']),
  disabled: PropTypes.bool,
  className: PropTypes.string
};

// 使用自定义按钮组件
const ButtonDemo = () => {
  return (
    <div style={{ padding: '20px', gap: '10px', display: 'flex' }}>
      <CustomButton type="primary" onClick={() => console.log('主按钮点击')}>
        主按钮
      </CustomButton>
      <CustomButton type="success" onClick={() => console.log('成功按钮点击')}>
        成功按钮
      </CustomButton>
      <CustomButton type="danger" disabled>
        禁用的危险按钮
      </CustomButton>
      <CustomButton type="default">默认按钮</CustomButton>
    </div>
  );
};

export default ButtonDemo;
```

#### 关键代码解释：

- `PropTypes` ：用于校验组件接收的属性类型，提升代码健壮性（需先安装： `npm install prop-types` ）。
- 解构赋值：将传入的属性解构，方便使用和设置默认值。
- 样式复用：通过 `type` 属性动态切换按钮样式，避免重复代码。
- `...rest` ：透传原生按钮属性，让组件更灵活。

### 3\. 使用第三方 UI 库的按钮（实战推荐）

实际开发中，很少从零写按钮样式，通常使用成熟的 UI 库（如 Ant Design、MUI 等），以下是 Ant Design 按钮的示例：

#### 前置条件：

bash

运行

```bash
# 安装 Ant Design
npm install antd
```

jsx

```jsx
import React from 'react';
import { Button, Space } from 'antd'; // 导入 AntD 的按钮和间距组件

const AntdButtonDemo = () => {
  return (
    <Space size="middle" style={{ padding: '20px' }}>
      {/* 不同类型的 AntD 按钮 */}
      <Button type="primary">Primary Button</Button>
      <Button type="default">Default Button</Button>
      <Button type="dashed">Dashed Button</Button>
      <Button type="text">Text Button</Button>
      <Button type="link">Link Button</Button>

      {/* 带图标和加载状态的按钮 */}
      <Button type="primary" icon="search" loading={false}>
        搜索
      </Button>
      
      {/* 尺寸和禁用状态 */}
      <Button type="primary" size="large" disabled>
        大号禁用按钮
      </Button>
    </Space>
  );
};

export default AntdButtonDemo;
```

### 总结

1. **基础按钮** ：核心是 `onClick` 事件绑定 + `useState` 状态管理，注意 React 内联样式的驼峰命名规则。
2. **自定义按钮** ：通过封装组件实现样式和逻辑复用，推荐使用 `PropTypes` 做属性校验。
3. **实战推荐** ：优先使用成熟的 UI 库（如 Ant Design、MUI）的按钮组件，减少重复造轮子，提升开发效率。

这些是 React 按钮最核心的用法，覆盖了新手开发中 90% 以上的按钮使用场景。

如何在 React Button 中添加图标？

如何在 React Button 中实现加载状态？

如何在 React Button 中添加动画效果？
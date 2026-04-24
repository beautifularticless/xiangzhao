react 自定义button 组件

我会帮你创建一个功能完善、可复用的 React 自定义 Button 组件。这个组件会包含常用的属性（类型、尺寸、禁用、加载状态等），遵循 React 最佳实践，并且易于扩展。

### 完整的自定义 Button 组件实现

我们使用 React + TypeScript（也提供 JS 版本）来实现，结合 CSS Modules 做样式隔离：

#### 1\. 目录结构

plaintext

```
src/
├── components/
│   └── Button/
│       ├── Button.tsx   // 组件逻辑
│       ├── Button.module.css  // 组件样式
│       └── index.ts     // 导出组件
```

#### 2\. Button.module.css（样式文件）

css

```
/* 基础按钮样式 */
.button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.2s ease;
  font-size: 14px;
  font-weight: 500;
  padding: 0 16px;
  outline: none;
}

/* 不同类型按钮 */
.primary {
  background-color: #165dff;
  color: white;
}
.primary:hover {
  background-color: #0040e0;
}
.primary:active {
  background-color: #0030b0;
}

.secondary {
  background-color: #f5f7fa;
  color: #1d2129;
  border: 1px solid #d0d6e0;
}
.secondary:hover {
  background-color: #e8ebf0;
}

.danger {
  background-color: #ff4d4f;
  color: white;
}
.danger:hover {
  background-color: #ff3335;
}

/* 尺寸 */
.small {
  height: 32px;
  font-size: 12px;
  padding: 0 12px;
}

.medium {
  height: 40px;
}

.large {
  height: 48px;
  font-size: 16px;
  padding: 0 20px;
}

/* 禁用状态 */
.disabled {
  opacity: 0.6;
  cursor: not-allowed;
  pointer-events: none;
}

/* 加载状态 */
.loading {
  cursor: wait;
}

.loadingIcon {
  margin-right: 8px;
  width: 16px;
  height: 16px;
  border: 2px solid currentColor;
  border-top-color: transparent;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}
```

#### 3\. Button.tsx（组件逻辑，TS 版本）

tsx

```tsx
import React from 'react';
import styles from './Button.module.css';

// 定义按钮的属性类型
interface ButtonProps {
  /** 按钮类型 */
  type?: 'primary' | 'secondary' | 'danger';
  /** 按钮尺寸 */
  size?: 'small' | 'medium' | 'large';
  /** 是否禁用 */
  disabled?: boolean;
  /** 是否加载中 */
  loading?: boolean;
  /** 点击事件 */
  onClick?: (e: React.MouseEvent<HTMLButtonElement>) => void;
  /** 子元素（按钮文字/图标） */
  children?: React.ReactNode;
  /** 自定义类名 */
  className?: string;
  /** 自定义样式 */
  style?: React.CSSProperties;
  /** 是否为块级元素 */
  block?: boolean;
}

const Button: React.FC<ButtonProps> = ({
  type = 'primary',
  size = 'medium',
  disabled = false,
  loading = false,
  onClick,
  children,
  className,
  style,
  block = false,
}) => {
  // 组合样式类名
  const btnClasses = [
    styles.button,
    styles[type],
    styles[size],
    disabled && styles.disabled,
    loading && styles.loading,
    block && 'block', // 可自定义 block 样式
    className,
  ].filter(Boolean).join(' ');

  return (
    <button
      className={btnClasses}
      style={style}
      disabled={disabled || loading}
      onClick={(e) => {
        if (!loading && !disabled) {
          onClick && onClick(e);
        }
      }}
    >
      {/* 加载中图标 */}
      {loading && <span className={styles.loadingIcon} />}
      {/* 按钮内容 */}
      {children}
    </button>
  );
};

export default Button;
```

#### 4\. index.ts（导出组件）

ts

```ts
import Button from './Button';
export default Button;
```

#### 5\. 纯 JS 版本（如果不需要 TS）

jsx

```jsx
import React from 'react';
import styles from './Button.module.css';

const Button = ({
  type = 'primary',
  size = 'medium',
  disabled = false,
  loading = false,
  onClick,
  children,
  className,
  style,
  block = false,
}) => {
  const btnClasses = [
    styles.button,
    styles[type],
    styles[size],
    disabled && styles.disabled,
    loading && styles.loading,
    block && 'block',
    className,
  ].filter(Boolean).join(' ');

  return (
    <button
      className={btnClasses}
      style={style}
      disabled={disabled || loading}
      onClick={(e) => {
        if (!loading && !disabled) {
          onClick && onClick(e);
        }
      }}
    >
      {loading && <span className={styles.loadingIcon} />}
      {children}
    </button>
  );
};

export default Button;
```

### 组件使用示例

tsx

```tsx
import React from 'react';
import Button from './components/Button';

const App = () => {
  const handleClick = () => {
    console.log('按钮被点击');
  };

  return (
    <div style={{ padding: 20, gap: 16, display: 'flex', flexDirection: 'column' }}>
      {/* 基础用法 */}
      <Button type="primary" onClick={handleClick}>
        主要按钮
      </Button>

      {/* 不同类型 */}
      <Button type="secondary">次要按钮</Button>
      <Button type="danger">危险按钮</Button>

      {/* 不同尺寸 */}
      <Button size="small">小尺寸</Button>
      <Button size="large">大尺寸</Button>

      {/* 加载状态 */}
      <Button loading onClick={handleClick}>
        提交中
      </Button>

      {/* 禁用状态 */}
      <Button disabled type="primary">
        禁用按钮
      </Button>

      {/* 块级按钮 */}
      <Button block type="primary">
        块级按钮
      </Button>
    </div>
  );
};

export default App;
```

### 关键功能说明

1. **类型支持** ：提供 `primary` （主要）、 `secondary` （次要）、 `danger` （危险）三种常用类型，可扩展更多。
2. **尺寸支持** ： `small` / `medium` / `large` 三种尺寸，适配不同场景。
3. **状态处理** ：
	- `disabled` ：禁用按钮，添加禁用样式，阻止点击。
	- `loading` ：加载状态，显示加载动画，自动禁用点击。
4. **样式隔离** ：使用 CSS Modules 避免样式污染，符合 React 组件化最佳实践。
5. **扩展性** ：支持自定义 `className` 、 `style` 、 `block` 等属性，可根据需求扩展更多功能（如图标、圆角等）。

### 总结

1. 自定义 Button 组件核心是封装通用属性（类型、尺寸、状态）和样式，通过组合类名实现样式动态切换。
2. 需处理交互逻辑（如 loading/disabled 状态下阻止点击），保证组件的可用性和健壮性。
3. 组件设计遵循 “高内聚、低耦合” 原则，保留扩展入口（自定义类名 / 样式），方便后续迭代。

如何在 React 中使用自定义的 Button 组件？

如何在 Button 组件中添加点击事件？

如何在 Button 组件中添加图标？
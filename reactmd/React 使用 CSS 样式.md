React 使用 CSS 样式

在 React 中使用 CSS 样式有多种主流方式，每种方式都有其适用场景。我会从最基础、最易上手的方式开始，逐步介绍到更现代化的方案，帮助你根据项目需求选择最合适的方式。

### 一、内联样式（Inline Styles）

这是 React 内置的最基础的样式方式，直接在 JSX 元素上通过 `style` 属性定义。

#### 特点：

- 样式写在 JSX 中，是 JavaScript 对象形式
- 属性名采用 **驼峰命名法** （如 `backgroundColor` 而非 `background-color` ）
- 值为字符串（如 `'10px'` ），数字值可省略单位（仅适用于 px）

#### 示例代码：

jsx

```jsx
import React from 'react';

function InlineStyleDemo() {
  // 定义样式对象（可抽离，提高复用性）
  const boxStyle = {
    width: 200, // 等价于 '200px'
    height: '200px',
    backgroundColor: '#42b983', // 驼峰命名
    color: 'white',
    padding: '20px',
    borderRadius: '8px',
    textAlign: 'center'
  };

  return (
    <div style={boxStyle}>
      <h2 style={{ fontSize: '18px', marginBottom: '10px' }}>内联样式示例</h2>
      <p>这是通过内联样式设置的样式</p>
    </div>
  );
}

export default InlineStyleDemo;
```

### 二、外部 CSS 文件（全局样式）

这是最接近传统前端开发的方式，创建独立的 `.css` 文件，通过 `import` 引入。

#### 特点：

- 样式全局生效，需注意样式冲突
- 写法与普通 CSS 完全一致
- 适合全局通用样式（如重置样式、主题色）

#### 示例步骤：

1. 创建 CSS 文件（ `App.css` ）：

css

```
/* App.css */
.box {
  width: 200px;
  height: 200px;
  background-color: #3498db;
  color: white;
  padding: 20px;
  border-radius: 8px;
  text-align: center;
}

.box-title {
  font-size: 18px;
  margin-bottom: 10px;
}
```

1. 在 React 组件中引入并使用：

jsx

```jsx
import React from 'react';
// 引入外部 CSS 文件
import './App.css';

function ExternalCssDemo() {
  return (
    <div className="box"> {/* React 中用 className 替代 class */}
      <h2 className="box-title">外部 CSS 示例</h2>
      <p>这是通过外部 CSS 文件设置的样式</p>
    </div>
  );
}

export default ExternalCssDemo;
```

### 三、CSS Modules（模块化 CSS）

CSS Modules 解决了全局样式冲突的问题，每个组件的样式文件会被编译成唯一的类名，仅作用于当前组件。

#### 特点：

- 样式文件命名为 `[组件名].module.css`
- 类名通过 `import` 导入后使用
- 样式仅作用于当前组件，避免污染

#### 示例步骤：

1. 创建模块化 CSS 文件（ `ModuleStyle.module.css` ）：

css

```
/* ModuleStyle.module.css */
.box {
  width: 200px;
  height: 200px;
  background-color: #e74c3c;
  color: white;
  padding: 20px;
  border-radius: 8px;
  text-align: center;
}

.title {
  font-size: 18px;
  margin-bottom: 10px;
}
```

1. 在组件中使用：

jsx

```jsx
import React from 'react';
// 导入模块化 CSS（命名可自定义，通常用 styles）
import styles from './ModuleStyle.module.css';

function CssModuleDemo() {
  return (
    <div className={styles.box}> {/* 通过 styles.类名 使用 */}
      <h2 className={styles.title}>CSS Modules 示例</h2>
      <p>这是模块化 CSS，样式仅作用于当前组件</p>
    </div>
  );
}

export default CssModuleDemo;
```

### 四、Styled Components（CSS-in-JS 主流方案）

这是目前 React 生态中最流行的 CSS-in-JS 库，允许你用 JavaScript 编写 CSS，样式与组件完全耦合。

#### 前置条件：

先安装依赖：

bash

运行

```bash
npm install styled-components
# 或
yarn add styled-components
```

#### 特点：

- 样式写在 JavaScript 中，通过模板字符串定义
- 自动生成唯一类名，无样式冲突
- 支持动态样式（基于 props 调整样式）
- 支持嵌套、伪类、媒体查询等 CSS 特性

#### 示例代码：

jsx

```jsx
import React from 'react';
import styled from 'styled-components';

// 定义样式化组件（可直接作为标签使用）
const StyledBox = styled.div\`
  width: 200px;
  height: 200px;
  background-color: ${props => props.bgColor || '#9b59b6'}; // 基于 props 动态设置
  color: white;
  padding: 20px;
  border-radius: 8px;
  text-align: center;

  // 嵌套样式（类似 SCSS）
  h2 {
    font-size: 18px;
    margin-bottom: 10px;
    &:hover { // 伪类
      color: #f1c40f;
    }
  }

  // 媒体查询
  @media (max-width: 768px) {
    width: 150px;
    height: 150px;
  }
\`;

function StyledComponentsDemo() {
  return (
    <>
      {/* 默认样式 */}
      <StyledBox>
        <h2>Styled Components 示例</h2>
        <p>CSS-in-JS 主流方案</p>
      </StyledBox>

      {/* 传递 props 自定义样式 */}
      <StyledBox bgColor="#1abc9c" style={{ marginTop: '20px' }}>
        <h2>动态样式示例</h2>
        <p>通过 props 改变背景色</p>
      </StyledBox>
    </>
  );
}

export default StyledComponentsDemo;
```

### 五、各方案对比与选择建议

表格

| 方式 | 优点 | 缺点 | 适用场景 |
| --- | --- | --- | --- |
| 内联样式 | 简单、无需额外配置、动态性强 | 不支持伪类 / 媒体查询、代码冗余 | 简单动态样式、临时样式 |
| 外部 CSS | 写法传统、易上手、全局复用 | 样式冲突、命名混乱 | 全局通用样式、小型项目 |
| CSS Modules | 解决样式冲突、写法接近传统 CSS | 配置稍多、不支持动态样式（需结合内联） | 中大型项目、组件化开发 |
| Styled Components | 组件耦合、动态性强、功能丰富 | 学习成本、运行时开销 | 大型项目、复杂组件样式 |

### 总结

1. **快速上手 / 简单需求** ：优先使用内联样式或外部 CSS；
2. **避免样式冲突** ：选择 CSS Modules（无额外依赖）或 Styled Components（功能更丰富）；
3. **复杂动态样式** ：Styled Components 是最优选择，支持 props 动态调整、嵌套、伪类等特性；
4. React 中使用样式的核心注意点：内联样式用 **驼峰属性名** ，JSX 中用 `className` 替代 `class` 。

如何在 React 中使用 CSS Modules？

如何在 React 中使用 CSS-in-JS 库？

如何在 React 中使用 Tailwind CSS？
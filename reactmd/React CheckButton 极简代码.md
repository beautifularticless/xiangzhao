### React 极简 CheckButton 实现

以下是一个极简、可直接复用的 CheckButton（复选按钮）组件，保留核心功能（选中 / 取消选中、状态回显、点击回调），无冗余代码：

jsx

```jsx
import { useState } from 'react';

// 极简复选按钮组件
const CheckButton = ({ 
  initialChecked = false,  // 初始选中状态
  onChange                 // 状态变化回调
}) => {
  // 维护选中状态
  const [checked, setChecked] = useState(initialChecked);

  // 点击切换状态
  const handleClick = () => {
    const newChecked = !checked;
    setChecked(newChecked);
    onChange && onChange(newChecked); // 触发外部回调
  };

  return (
    <button
      onClick={handleClick}
      style={{
        padding: '8px 16px',
        border: '1px solid #ccc',
        borderRadius: '4px',
        cursor: 'pointer',
        // 选中状态样式区分
        backgroundColor: checked ? '#1677ff' : '#fff',
        color: checked ? '#fff' : '#333',
        borderColor: checked ? '#1677ff' : '#ccc'
      }}
    >
      {checked ? '✅ 已选中' : '□ 未选中'}
    </button>
  );
};

// 组件使用示例
const App = () => {
  // 监听选中状态变化
  const handleCheckChange = (isChecked) => {
    console.log('选中状态:', isChecked);
  };

  return (
    <div style={{ padding: '20px' }}>
      <CheckButton 
        initialChecked={false} 
        onChange={handleCheckChange} 
      />
    </div>
  );
};

export default App;
```

### 核心代码解释

1. **状态管理** ：使用 `useState` 维护内部选中状态， `initialChecked` 支持外部传入初始值，默认未选中；
2. **交互逻辑** ：点击按钮时切换 `checked` 状态，并通过 `onChange` 回调将最新状态传递给父组件；
3. **样式区分** ：通过行内样式极简实现选中 / 未选中的视觉差异（背景色、文字色、边框色），无额外样式文件；
4. **易用性** ：按钮内文字直观展示状态（✅/□ 符号 + 文字），符合用户认知。

### 总结

1. 核心逻辑：通过 `useState` 维护选中状态，点击事件切换状态并触发外部回调；
2. 极简设计：仅保留「状态切换 + 样式区分 + 回调」核心功能，无冗余依赖 / 代码；
3. 复用性：支持自定义初始状态和状态变化回调，可直接嵌入任意 React 项目。

如果需要更贴近原生复选框的视觉样式（而非按钮样式），只需修改 `return` 内的 DOM 结构（如替换为 `input[type="checkbox"] + label` ），核心逻辑完全复用。

如何在 CheckButton 组件中添加禁用状态？

如何在 CheckButton 组件中添加自定义图标？

如何在 CheckButton 组件中添加动画效果？
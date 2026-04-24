## React antd 点击按钮获取文本框内容例子

### 实现思路

1. 使用 React 的 `useState` 钩子来管理文本框的输入值
2. 添加 Ant Design 的 `Input` 组件作为文本框
3. 为按钮添加点击事件处理函数，用于获取并展示文本框内容
4. 保持原有布局结构，合理排列文本框和按钮
   
   ### 完整代码

```jsx
import React, { useState } from 'react';
import { Button, Flex, Input, message } from 'antd';
import { LeftOutlined, RightOutlined } from "@ant-design/icons";
const App = () => {
  // 定义状态来存储文本框的值
  const [inputValue, setInputValue] = useState('');
  // 处理文本框内容变化的函数
  const handleInputChange = (e) => {
    // 更新状态值为文本框当前输入的内容
    setInputValue(e.target.value);
  };
  // 点击按钮获取文本框内容的函数
  const handleGetContent = () => {
    if (!inputValue.trim()) {
      message.warning('文本框不能为空，请输入内容！');
      return;
    }
    // 这里可以根据需求处理文本框内容，比如打印、发送请求等
    message.success(\`获取到的文本框内容：${inputValue}\`);
    console.log('文本框内容：', inputValue);
  };
  return (
    <Flex gap="small" wrap style={{ padding: 20 }}>
      {/* 文本输入框 */}
      <Input
        placeholder="请输入内容..."
        value={inputValue}  // 绑定状态值
        onChange={handleInputChange}  // 绑定内容变化事件
        style={{ width: 300 }}  // 设置文本框宽度
      />
      {/* 按钮 - 点击获取文本框内容 */}
      <Button type="primary" onClick={handleGetContent}>
        获取文本框内容
      </Button>
    </Flex>
  );
};
export default App;
```

### 代码关键部分解释

1. **状态管理** ：
   - `const [inputValue, setInputValue] = useState('');`：创建状态变量 `inputValue` 存储文本框内容， `setInputValue` 用于更新该值。
2. **文本框绑定** ：
   - `value={inputValue}` ：实现 **受控组件** ，文本框的值由 React 状态控制。
   - `onChange={handleInputChange}` ：文本框内容变化时触发，更新状态值。
3. **按钮点击事件** ：
   - `onClick={handleGetContent}` ：点击按钮时触发，首先判断文本框是否为空，非空则通过 `message` 组件提示内容，并在控制台打印。
4. **额外优化** ：
   - 添加 `style={{ padding: 20 }}` 给外层容器增加内边距，提升视觉效果。
   - 给文本框设置固定宽度 `style={{ width: 300 }}` ，避免宽度自适应导致布局混乱。
   - 增加空值判断，提升用户体验。
     
     ### 总结
5. 通过 `useState` 钩子管理文本框的值，实现受控组件是 React 处理表单输入的核心方式。
6. 文本框的 `onChange` 事件用于更新状态，按钮的 `onClick` 事件用于获取并处理状态值。
7. 增加空值校验和友好的提示信息，能显著提升用户体验，是实际开发中的最佳实践。

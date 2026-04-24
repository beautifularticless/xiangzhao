react 日期事件

在 React 中处理日期相关的事件，核心是结合 React 的事件处理机制与 JavaScript 的日期（Date）API。我会从最常用的场景入手，帮你掌握 React 中日期事件的处理方法。

### 一、核心场景：日期选择与事件处理

以下是几个最常见的日期事件处理示例，涵盖输入选择、按钮触发、日期格式化等核心需求。

#### 1\. 基础示例：输入框选择日期并处理

这是最常用的场景（如生日、预约日期选择），通过 `<input type="date">` 获取用户选择的日期，并在 onChange 事件中处理。

jsx

```jsx
import React, { useState } from 'react';

function DatePicker() {
  // 初始化日期状态，默认值为空
  const [selectedDate, setSelectedDate] = useState('');
  
  // 处理日期选择事件
  const handleDateChange = (e) => {
    // e.target.value 是用户选择的日期，格式为 YYYY-MM-DD
    const dateValue = e.target.value;
    setSelectedDate(dateValue);
    
    // 可选：将字符串日期转为 Date 对象，便于后续处理（如计算、格式化）
    if (dateValue) {
      const dateObj = new Date(dateValue);
      console.log('选择的日期对象：', dateObj);
      console.log('格式化日期（年-月-日）：', \`${dateObj.getFullYear()}-${dateObj.getMonth() + 1}-${dateObj.getDate()}\`);
    }
  };

  return (
    <div>
      <h3>选择日期</h3>
      {/* type="date" 会渲染浏览器自带的日期选择器 */}
      <input
        type="date"
        value={selectedDate}
        onChange={handleDateChange}
        placeholder="选择日期"
      />
      {selectedDate && (
        <p>你选择的日期是：{selectedDate}</p>
      )}
    </div>
  );
}

export default DatePicker;
```

**关键说明** ：

- `<input type="date">` 的 `value` 格式固定为 `YYYY-MM-DD` ，这是 HTML 标准，与 JavaScript Date 对象的格式不同。
- `getMonth()` 返回的是 0-11（0 代表 1 月），所以需要 `+1` 才是实际月份。
- 事件处理函数 `handleDateChange` 是 React 的合成事件，用法与原生 JS 一致，但无需手动绑定 this（函数组件优势）。

#### 2\. 进阶示例：按钮触发日期计算（如 “获取今天 / 昨天 / 明天”）

处理点击事件时计算日期，适用于 “快速选择” 类场景。

jsx

```jsx
import React, { useState } from 'react';

function DateActions() {
  const [currentDate, setCurrentDate] = useState('');
  
  // 格式化日期为 YYYY-MM-DD
  const formatDate = (date) => {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0'); // 补零，如 02 月
    const day = String(date.getDate()).padStart(2, '0');
    return \`${year}-${month}-${day}\`;
  };

  // 处理“获取今天”按钮点击
  const handleTodayClick = () => {
    const today = new Date();
    setCurrentDate(formatDate(today));
  };

  // 处理“获取昨天”按钮点击
  const handleYesterdayClick = () => {
    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1); // 日期减1天
    setCurrentDate(formatDate(yesterday));
  };

  return (
    <div>
      <button onClick={handleTodayClick}>获取今天</button>
      <button onClick={handleYesterdayClick}>获取昨天</button>
      {currentDate && <p>当前日期：{currentDate}</p>}
    </div>
  );
}

export default DateActions;
```

**关键说明** ：

- `padStart(2, '0')` 用于补零，确保月份 / 日期始终是两位（如 1 月 → 01 月），符合用户习惯。
- `setDate()` 是 Date 对象的核心方法，可直接修改日期（支持加减），无需手动计算月份 / 年份。

#### 3\. 实战扩展：第三方日期组件（Ant Design）

实际项目中，原生 `<input type="date">` 样式难以定制，通常使用 UI 库的日期组件（如 Ant Design 的 DatePicker），事件处理逻辑类似：

jsx

```jsx
import React, { useState } from 'react';
import { DatePicker, Space } from 'antd';
import 'antd/dist/reset.css'; // 引入 Ant Design 样式

function AntdDatePicker() {
  const [date, setDate] = useState(null);

  // 处理日期选择（Ant Design 的 onChange 接收 moment 对象）
  const handleDateChange = (dateObj, dateString) => {
    setDate(dateObj);
    console.log('选择的日期（字符串）：', dateString); // 格式：YYYY-MM-DD
    console.log('选择的日期（moment 对象）：', dateObj);
  };

  return (
    <Space direction="vertical" size={16}>
      <h3>Ant Design 日期选择器</h3>
      <DatePicker onChange={handleDateChange} />
      {date && <p>选择的日期：{date.format('YYYY年MM月DD日')}</p>}
    </Space>
  );
}

export default AntdDatePicker;
```

**前置条件** ：需先安装依赖：

bash

运行

```bash
npm install antd moment --save
```

### 二、常见问题与注意事项

1. **时区问题** ：JavaScript 的 Date 对象默认使用本地时区，若需处理 UTC 时间，可使用 `new Date(Date.UTC(year, month, day))` 。
2. **日期格式化** ：原生 Date API 格式化能力有限，复杂场景可使用 `dayjs` 或 `moment` 库（推荐 dayjs，体积更小）。
3. **空值处理** ：用户未选择日期时， `e.target.value` 为空字符串，需在处理函数中做非空判断，避免报错。

### 总结

1. React 中处理日期事件的核心是：通过 `onChange` / `onClick` 等合成事件获取日期值，结合 JavaScript Date API 处理（格式化、计算）。
2. `<input type="date">` 的值格式固定为 `YYYY-MM-DD` ，处理时需注意月份补零和 `getMonth()` 从 0 开始的特性。
3. 实际项目中优先使用 UI 库（如 Ant Design）的日期组件，事件逻辑与原生一致，但格式化更便捷。
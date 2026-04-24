React键盘事件

在 React 中处理键盘事件是前端开发的常见需求（比如表单回车提交、快捷键操作等），React 对原生键盘事件做了封装，使用方式更统一且符合 React 组件化思想。下面我会从基础到进阶，带你全面理解 React 中的键盘事件。

### 一、React 常用的键盘事件类型

React 提供了和原生一致的键盘事件，主要分为三类（均为 **合成事件** ，跨浏览器兼容）：

表格

| 事件名 | 触发时机 | 常用场景 |
| --- | --- | --- |
| `onKeyDown` | 按键按下时（持续按住会重复触发） | 监听快捷键、实时响应按键 |
| `onKeyUp` | 按键松开时 | 确认按键操作完成 |
| `onKeyPress` | 按下能产生字符的键时（已废弃） | 不推荐使用，改用 `onKeyDown` |

### 二、基础使用示例

#### 1\. 监听单个元素的键盘事件（比如输入框回车提交）

jsx

```jsx
import React, { useState } from 'react';

function InputWithEnter() {
  const [inputValue, setInputValue] = useState('');

  // 处理键盘按下事件
  const handleKeyDown = (e) => {
    // 1. 获取按键信息：e.key（按键名称）、e.keyCode（按键编码，已废弃）
    console.log('按下的键：', e.key); // 比如回车会输出 "Enter"，数字1输出 "1"
    console.log('按键编码：', e.keyCode); // 回车是13（不推荐使用，建议用e.key）

    // 2. 示例：回车提交输入内容
    if (e.key === 'Enter') {
      alert(\`提交的内容：${inputValue}\`);
      setInputValue(''); // 清空输入框
      // 阻止原生行为（比如表单默认提交）
      e.preventDefault();
    }

    // 3. 示例：按ESC清空输入框
    if (e.key === 'Escape') {
      setInputValue('');
    }
  };

  return (
    <input
      type="text"
      value={inputValue}
      onChange={(e) => setInputValue(e.target.value)}
      onKeyDown={handleKeyDown} // 绑定键盘按下事件
      placeholder="输入内容后按回车提交，ESC清空"
    />
  );
}

export default InputWithEnter;
```

#### 2\. 监听全局键盘事件（比如页面快捷键）

如果需要监听整个页面的键盘事件（比如按 `Ctrl+S` 保存），需要在组件挂载时给 `document` / `window` 绑定事件，卸载时移除（避免内存泄漏）：

jsx

```jsx
import React, { useEffect } from 'react';

function GlobalKeyListener() {
  // 定义全局键盘事件处理函数
  const handleGlobalKeyDown = (e) => {
    // 监听 Ctrl+S 快捷键
    if (e.ctrlKey && e.key === 's') {
      e.preventDefault(); // 阻止浏览器默认的保存页面行为
      alert('执行自定义保存操作');
    }

    // 监听 Alt+D 快捷键
    if (e.altKey && e.key === 'd') {
      alert('触发 Alt+D 快捷键');
    }
  };

  // 挂载时绑定事件，卸载时移除
  useEffect(() => {
    document.addEventListener('keydown', handleGlobalKeyDown);

    // 清理函数：组件卸载时移除事件监听
    return () => {
      document.removeEventListener('keydown', handleGlobalKeyDown);
    };
  }, []); // 空依赖：只执行一次

  return <div>页面全局快捷键监听（按 Ctrl+S / Alt+D 测试）</div>;
}

export default GlobalKeyListener;
```

### 三、关键知识点说明

1. **合成事件 vs 原生事件** ：React 的键盘事件是 “合成事件”，已经做了跨浏览器兼容，无需自己处理浏览器差异；如果需要访问原生事件对象，可通过 `e.nativeEvent` 获取。
2. **按键判断的推荐方式** ：
	- 推荐使用 `e.key` （语义化名称，比如 `Enter` / `Escape` / `ArrowUp` / `a` / `1` ），不推荐 `e.keyCode` （数字编码，已废弃）。
	- 常用按键的 `e.key` 值：
		- 回车： `Enter`
		- 退出： `Escape`
		- 方向键： `ArrowUp` / `ArrowDown` / `ArrowLeft` / `ArrowRight`
		- 空格： `Space`
		- 删除： `Backspace` / `Delete`
3. **修饰键判断** ：可通过以下属性判断是否按下修饰键（Ctrl/Shift/Alt/Win）：
	- `e.ctrlKey` ：是否按下 Ctrl 键
	- `e.shiftKey` ：是否按下 Shift 键
	- `e.altKey` ：是否按下 Alt 键
	- `e.metaKey` ：是否按下 Win 键（Windows）/ Command 键（Mac）
4. **阻止默认行为** ：使用 `e.preventDefault()` 阻止浏览器默认行为（比如回车提交表单、Ctrl+S 保存页面）；如果需要停止事件冒泡，使用 `e.stopPropagation()` 。

### 四、常见问题与注意事项

1. **事件绑定到非可聚焦元素** ：只有可聚焦元素（input/button/textarea 等）才能直接触发键盘事件；如果要给 div/span 等非可聚焦元素绑定键盘事件，需要给元素添加 `tabIndex="0"` （使其可聚焦），比如：
	jsx
	```jsx
	<div tabIndex="0" onKeyDown={handleKeyDown}>
	  可聚焦的 div（点击后按回车测试）
	</div>
	```
2. **避免内存泄漏** ：全局事件（绑定到 document/window）必须在组件卸载时移除监听（通过 useEffect 的清理函数），否则会导致内存泄漏。

### 总结

1. React 中常用的键盘事件是 `onKeyDown` / `onKeyUp` （ `onKeyPress` 已废弃），均为跨浏览器的合成事件；
2. 判断按键推荐使用 `e.key` （语义化名称），修饰键可通过 `e.ctrlKey` / `e.shiftKey` 等判断；
3. 全局键盘事件需在 useEffect 中绑定，并在组件卸载时移除，避免内存泄漏；非可聚焦元素需加 `tabIndex="0"` 才能触发键盘事件。

如何在 React 中同时监听多个元素的键盘事件？

除了 onKeyDown，还有哪些常用的 React 事件？

如何阻止 React 中的键盘事件冒泡？
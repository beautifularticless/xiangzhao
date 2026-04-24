react 键盘快捷键

在 React 中实现键盘快捷键，最常用、最简洁的方案是使用 **`react-hotkeys-hook`** 钩子，也可以用原生事件监听或其他库。下面给你完整实现与最佳实践。

---

### 一、使用 react-hotkeys-hook（推荐）

#### 1\. 安装

bash

运行

```bash
npm install react-hotkeys-hook
# 或
yarn add react-hotkeys-hook
```

#### 2\. 基础用法（全局快捷键）

jsx

```jsx
import { useHotkeys } from 'react-hotkeys-hook';

function App() {
  // 全局监听 Ctrl+S / Cmd+S
  useHotkeys(
    'ctrl+s, cmd+s',
    (event) => {
      event.preventDefault(); // 阻止浏览器默认保存
      alert('执行保存操作');
    },
    { preventDefault: true } // 统一阻止默认行为
  );

  // 监听 ESC 关闭弹窗
  useHotkeys('esc', () => {
    console.log('按下 ESC');
  });

  return <div>按 Ctrl+S 保存</div>;
}
export default App;
```

#### 3\. 作用域快捷键（仅在某个元素内生效）

jsx

```jsx
import { useHotkeys } from 'react-hotkeys-hook';
import { useRef } from 'react';

function InputWithShortcut() {
  const inputRef = useRef(null);

  // 仅在 input 内触发 Ctrl+Enter
  useHotkeys(
    'ctrl+enter',
    () => {
      alert(\`提交内容：${inputRef.current.value}\`);
    },
    { target: inputRef } // 指定触发元素
  );

  return <input ref={inputRef} placeholder="按 Ctrl+Enter 提交" />;
}
```

#### 4\. 启用 / 禁用快捷键

jsx

```jsx
import { useHotkeys } from 'react-hotkeys-hook';
import { useState } from 'react';

function ToggleShortcut() {
  const [enabled, setEnabled] = useState(true);

  useHotkeys(
    'ctrl+k',
    () => alert('打开命令面板'),
    { enabled } // 受控启用/禁用
  );

  return (
    <button onClick={() => setEnabled(!enabled)}>
      {enabled ? '禁用 Ctrl+K' : '启用 Ctrl+K'}
    </button>
  );
}
```

#### 5\. 常用快捷键写法

表格

| 写法 | 说明 |
| --- | --- |
| `ctrl+s` | Ctrl+S（Windows/Linux） |
| `cmd+s` | Cmd+S（Mac） |
| `ctrl+s, cmd+s` | 跨平台兼容 |
| `shift+a` | Shift+A |
| `alt+d` | Alt/Option+D |
| `esc` | 退出键 |
| `enter` | 回车 |
| `space` | 空格 |
| `arrowup` / `arrowdown` | 上下箭头 |
| `f1-f12` | 功能键 |

---

### 二、原生实现（不依赖库）

通过 `useEffect` 监听 `keydown` 事件，适合简单场景。

jsx

```jsx
import { useEffect } from 'react';

function NativeShortcut() {
  useEffect(() => {
    const handleKeyDown = (e) => {
      // Ctrl+S
      if ((e.ctrlKey || e.metaKey) && e.key === 's') {
        e.preventDefault();
        alert('原生实现：保存');
      }
      // ESC
      if (e.key === 'Escape') {
        alert('原生实现：ESC');
      }
    };

    document.addEventListener('keydown', handleKeyDown);
    return () => document.removeEventListener('keydown', handleKeyDown);
  }, []);

  return <div>原生监听快捷键</div>;
}
```

---

### 三、其他常用库

- **`use-keyboard-shortcuts`** ：轻量、声明式配置
- **`react-ctrlk`** ：专注 Cmd+K 命令面板场景
- **`react-keyboardist`** ：自动忽略输入框内事件，适合全局导航

---

### 四、最佳实践

1. **阻止默认行为** ：覆盖浏览器快捷键（如 `Ctrl+S` ）时必须 `preventDefault`
2. **作用域隔离** ：用 `target` 或组件内监听，避免全局冲突
3. **跨平台兼容** ：同时写 `ctrl+key, cmd+key`
4. **内存清理** ：原生监听必须在 `useEffect` 清理函数中移除
5. **可访问性** ：提供鼠标操作备选，不要仅依赖快捷键

---

### 五、完整示例：带命令面板的快捷键系统

jsx

```jsx
import { useState } from 'react';
import { useHotkeys } from 'react-hotkeys-hook';

function CommandPalette() {
  const [open, setOpen] = useState(false);

  // 打开/关闭命令面板
  useHotkeys('ctrl+k, cmd+k', () => setOpen(!open), { preventDefault: true });

  // ESC 关闭
  useHotkeys('esc', () => setOpen(false), { enabled: open });

  return (
    <div>
      <h1>按 Ctrl+K 打开命令面板</h1>
      {open && (
        <div style={{ position: 'fixed', top: 100, left: '50%', transform: 'translateX(-50%)', background: '#fff', padding: 20, boxShadow: '0 0 10px rgba(0,0,0,0.2)' }}>
          <input autoFocus placeholder="搜索命令..." />
          <p>按 ESC 关闭</p>
        </div>
      )}
    </div>
  );
}
export default CommandPalette;
```

---

需要我帮你把上面的示例改成 **TypeScript 版本** ，并加上完整的类型定义吗？

参考 11 篇资料

如何使用原生事件监听实现React键盘快捷键？

除了react-hotkeys-hook，还有哪些库可以实现React键盘快捷键？

如何在React中实现组合键的键盘快捷键？
## 创建React Vite项目

第一步：
在Windows系统下,打开命令终端窗口cmd.exe
第二步：执行创建项目命令

```
npm create vite@latest react-app
```

执行命令后会显示如下结果

```
PS C:\Users\users\Desktop> npm create vite@latest react-app

> npx
> create-vite react-app

|
*  Select a framework:
|  > Vanilla
|    Vue
|    React
|    Preact
|    Lit
|    Svelte
|    Solid
|    Ember
|    Qwik
|    Angular
|    Marko
|    Others
```

你执行的 `npm create vite@latest react-app` 是使用 Vite 快速创建 React 项目的核心命令，我会完整讲解这个命令的作用、执行后的交互流程，以及后续的项目初始化、运行步骤，确保你能顺利搭建并启动 React 项目。

### 一、命令解析

`npm create vite@latest react-app` 拆解：

- `npm create`：等同于 `npx create-*`，是 npm 提供的快速创建项目的快捷方式；
- `vite@latest`：指定使用最新版本的 Vite 脚手架；
- `react-app`：是你要创建的项目文件夹名称（可自定义，比如 `my-react-project`）。
  
  ### 二、完整操作流程（从执行命令到启动项目）
  
  #### 1. 执行核心命令
  
  在终端（CMD/PowerShell/终端）中输入：
  
  ```bash
  npm create vite@latest react-app
  ```
  
  #### 2. 命令执行后的交互选择（关键步骤）
  
  执行命令后，终端会弹出交互选项，按以下步骤选择（适配 React 项目）：
  
  | 交互提示                    | 选择内容               | 说明               |
  | ----------------------- | ------------------ | ---------------- |
  | `? Project name:`       | 直接回车（默认 react-app） | 确认项目名称，也可修改      |
  | `? Select a framework:` | 选择 `React`         | 指定项目框架为 React    |
  | `? Select a variant:`   | 推荐选 `JavaScript`   | 新手先选 JS，熟悉后可选 TS |
  
  #### 3. 进入项目目录并安装依赖
  
  创建完成后，终端会提示进入项目文件夹并安装依赖，执行：
  
  ```bash
  # 进入项目目录
  cd react-app
  # 安装项目依赖（Vite 项目核心依赖，如 react、react-dom、vite 等）
  npm install
  ```
  
  #### 4. 启动开发服务器
  
  依赖安装完成后，启动本地开发服务：
  
  ```bash
  npm run dev
  ```
  
  #### 5. 访问项目
  
  启动成功后，终端会输出类似以下内容：
  
  ```
  VITE v5.0.0 ready in 300 ms
  ➜ Local: http://localhost:5173/
  ➜ Network: use --host to expose
  ```
  
  打开浏览器访问 `http://localhost:5173`，就能看到 Vite + React 的默认页面，说明项目搭建成功。
  
  ### 三、常见问题与注意事项
1. **npm 版本过低**：如果执行命令报错，先升级 npm 到最新版本：
   
   ```bash
   npm install -g npm@latest
   ```
2. **依赖安装缓慢**：可切换淘宝镜像加速：
   
   ```bash
   npm config set registry https://registry.npmmirror.com
   ```
3. **端口被占用**：启动时如果提示 5173 端口被占用，Vite 会自动切换到空闲端口（如 5174），只需访问终端提示的新地址即可。
   
   ### 总结
4. `npm create vite@latest react-app` 是 Vite 创建 React 项目的核心命令，`react-app` 是项目名（可自定义）；
5. 执行命令后需交互选择 `React` 框架和 `JavaScript` 变体（新手推荐）；
6. 完成创建后需执行 `cd react-app` → `npm install` → `npm run dev` 三步，即可启动项目并访问 `localhost:5173`。

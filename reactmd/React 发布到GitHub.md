react 发布到GitHub

将 React 项目发布到 GitHub 主要分为 **代码托管** 和 **页面部署（GitHub Pages）** 两个核心环节。下面我会一步步教你完成整个流程，从代码上传到在线访问。

### 一、前置准备

1. 确保本地已安装 `git` ，并配置好 GitHub 账号（用户名、邮箱）：
	bash
	运行
	```bash
	git config --global user.name "你的GitHub用户名"
	git config --global user.email "你的GitHub注册邮箱"
	```
2. 已有 React 项目（如果没有，可通过 `npx create-react-app my-app` 快速创建）。
3. GitHub 上新建一个空仓库（不要勾选 `Initialize this repository with a README` ）。

### 二、步骤 1：将 React 代码推送到 GitHub 仓库

#### 1\. 进入项目根目录，初始化 git（如果未初始化）

bash

运行

```bash
cd 你的react项目目录
git init
```

#### 2\. 添加所有文件到暂存区

bash

运行

```bash
git add .
```

#### 3\. 提交代码

bash

运行

```bash
git commit -m "初始化React项目"
```

#### 4\. 关联 GitHub 远程仓库

将下面的 `你的用户名` 和 `仓库名` 替换为实际值：

bash

运行

```bash
git remote add origin https://github.com/你的用户名/仓库名.git
```

#### 5\. 推送到 GitHub

bash

运行

```bash
git push -u origin main  # 如果默认分支是master，替换为master
```

### 三、步骤 2：部署 React 项目到 GitHub Pages（在线访问）

GitHub Pages 可以免费托管静态页面，React 打包后是静态文件，适合部署到这里。

#### 1\. 安装 gh-pages 依赖

bash

运行

```bash
npm install gh-pages --save-dev
```

#### 2\. 修改 package.json 配置

在 `package.json` 中添加 / 修改以下配置（关键！）：

#### 3\. 执行部署命令

bash

运行

```bash
npm run deploy
```

执行完成后，GitHub 会自动创建 `gh-pages` 分支，所有静态文件会推送到这个分支。

#### 4\. 配置 GitHub Pages 访问

1. 打开 GitHub 仓库 → 点击 `Settings` → 左侧找到 `Pages` ；
2. 在 `Build and deployment` 下的 `Source` 选择 `Deploy from a branch` ；
3. `Branch` 选择 `gh-pages` ，文件夹选择 `/ (root)` ，点击 `Save` ；
4. 等待 1-2 分钟，页面会显示访问地址（如 `https://你的用户名.github.io/仓库名` ）。

### 四、常见问题解决

1. **部署后页面空白** ：
	- 检查 `homepage` 配置是否正确（必须和仓库名一致）；
	- 若使用 React Router，需改用 `HashRouter` 而非 `BrowserRouter` （GitHub Pages 不支持路由刷新）。
2. **推送代码提示权限错误** ：
	- 改用 SSH 地址关联仓库（ `git remote add origin git@github.com:你的用户名/仓库名.git` ）；
	- 或在 GitHub 设置中生成个人访问令牌（PAT），推送时用令牌作为密码。
3. **gh-pages 命令找不到** ：
	- 确保依赖安装成功，或全局安装 `npm install -g gh-pages` 。

### 总结

1. 发布 React 代码到 GitHub 核心是通过 `git` 命令将本地代码推送到远程仓库；
2. 部署在线页面需安装 `gh-pages` ，配置 `homepage` 和部署脚本，最终通过 GitHub Pages 访问；
3. 注意路由适配（HashRouter）和 homepage 配置正确性，避免页面空白问题。

如何在 React 项目中使用 GitHub Pages？

如何在 React 项目中使用 GitHub Actions？

如何在 React 项目中使用 TypeScript？
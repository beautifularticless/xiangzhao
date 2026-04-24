本地运行 react build 后的文件

当你执行 `npm run build` 构建 React 项目后，会生成一个 `build` 文件夹，里面是静态的 HTML/CSS/JS 文件。直接双击 HTML 文件打开会因为浏览器的跨域 / 路径限制无法正常运行，需要用本地服务器来托管这些文件。

下面提供 **3 种简单易用的方法** ，按「新手友好度」排序：

### 方法 1：使用 serve（推荐，最简单）

这是 React 官方文档推荐的方式，专门用于托管静态文件。

#### 步骤：

1. 全局安装 `serve` （只需安装一次）：
	bash
	运行
	```bash
	npm install -g serve
	```
2. 进入 React 项目根目录，运行命令托管 `build` 文件夹：
	bash
	运行
	```bash
	serve -s build
	```
3. 终端会输出访问地址（通常是 `http://localhost:3000` 或 `http://localhost:5000` ），直接在浏览器打开即可。

#### 关键说明：

- `-s` 参数是「单页应用（SPA）」模式，确保 React Router 的路由能正常工作（比如刷新页面不会 404）。
- 停止服务：按 `Ctrl + C` 即可。

### 方法 2：使用 Python 内置服务器（无需额外安装）

如果你的电脑已安装 Python（大部分系统自带），可以直接用内置服务器：

#### 步骤：

1. 进入 `build` 文件夹（先 cd 到项目根目录）：
	bash
	运行
	```bash
	cd build
	```
2. 根据 Python 版本运行命令：
	- Python 3.x：
		bash
		运行
		```bash
		python -m http.server 3000
		```
	- Python 2.x：
		bash
		运行
		```bash
		python -m SimpleHTTPServer 3000
		```
3. 访问 `http://localhost:3000` 即可。

#### 注意：

这种方式 **不支持 React Router 的刷新路由** （刷新会 404），仅适合测试无路由的简单 React 项目。

### 方法 3：使用 http-server（备选）

和 `serve` 类似，也是常用的静态服务器：

#### 步骤：

1. 全局安装：
	bash
	运行
	```bash
	npm install -g http-server
	```
2. 进入项目根目录，运行：
	bash
	运行
	```bash
	http-server ./build -p 3000
	```
3. 访问 `http://localhost:3000` 。

### 常见问题解决

1. **端口被占用** ：把命令中的 `3000` 换成其他数字（比如 `8080` ），例如 `serve -s build -p 8080` 。
2. **路由刷新 404** ：必须用 `serve -s` 模式，或确保服务器配置了「SPA 回退到 index.html」（Python 内置服务器不支持）。
3. **build 文件夹不存在** ：先执行 `npm run build` 构建项目，确认 `build` 文件夹生成后再启动服务器。

### 总结

1. **推荐用 `serve -s build`** ：支持 React Router，操作最简单，符合官方最佳实践。
2. 避免直接双击 HTML 文件：会因路径 / 跨域问题导致资源加载失败。
3. 端口冲突时，通过 `-p` 参数指定自定义端口（如 `serve -s build -p 8080` ）。

如何使用 serve 命令的其他参数？

除了文中提到的方法，还有哪些方式可以托管 React build 后的文件？

如何在生产环境中部署 React 应用？
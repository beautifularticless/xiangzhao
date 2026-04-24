react 发布到nginx

将 React 项目部署到 Nginx 是前端开发中非常常见的操作，我会一步步教你完成整个流程，从打包 React 项目到配置 Nginx 并验证部署效果。

### 一、准备工作

1. 确保你的 React 项目可以正常运行（本地 `npm start` 能启动）
2. 安装好 Node.js（用于打包）和 Nginx（用于部署）
3. 了解服务器的基础操作（如果部署到远程服务器）

### 二、步骤 1：打包 React 项目

首先需要将 React 项目打包成静态文件（HTML/CSS/JS），这是部署的基础。

#### 1.1 打包命令（本地执行）

进入你的 React 项目根目录，执行：

bash

运行

```bash
# 安装依赖（如果还没装）
npm install

# 打包生产环境版本
npm run build
```

#### 1.2 打包结果说明

执行完成后，项目根目录会生成一个 `build` 文件夹，里面就是所有需要部署的静态文件：

- `build/index.html` ：项目入口文件
- `build/static` ：包含 CSS、JS、图片等静态资源

#### 1.3 关键配置（解决路由问题）

如果你的 React 项目使用了 `react-router-dom` 做路由（比如 BrowserRouter），需要先修改 `package.json` ，添加 **主页路径** （避免打包后资源路径错误）：

### 三、步骤 2：配置 Nginx

#### 2.1 复制打包文件到 Nginx 目录

首先将本地 `build` 文件夹中的所有文件，复制到 Nginx 的静态资源目录：

- **本地 / 测试服务器** ：推荐复制到 `/usr/share/nginx/html` （Nginx 默认静态目录）
- **远程服务器** ：可以用 `scp` 命令传输，比如：

#### 2.2 修改 Nginx 配置文件

Nginx 的核心配置文件通常在 `/etc/nginx/nginx.conf` ，或 `/etc/nginx/conf.d/default.conf` （推荐修改这个，更灵活）。

##### 2.2.1 编辑配置文件

bash

运行

```bash
# 编辑默认配置文件
vim /etc/nginx/conf.d/default.conf
```

##### 2.2.2 完整的 Nginx 配置示例（关键）

替换原有内容为以下配置（注释已标注关键要点）：

### 四、步骤 3：启动 / 重启 Nginx 并验证

#### 4.1 Nginx 常用命令

bash

运行

```bash
# 检查配置文件是否有语法错误（必做！）
nginx -t

# 启动 Nginx
nginx

# 重启 Nginx（修改配置后需要执行）
nginx -s reload

# 停止 Nginx
nginx -s stop
```

#### 4.2 验证部署效果

1. 打开浏览器，访问 `http://你的服务器IP` （或 `http://localhost` 如果是本地）
2. 验证：
	- 首页能正常加载
	- 路由跳转正常
	- 刷新页面（比如 `/about` 页面）不会出现 404 错误
	- 静态资源（图片、CSS/JS）能正常加载

### 五、常见问题及解决

1. **刷新页面 404** ：
	- 原因：Nginx 找不到对应路由的文件（React 路由是前端路由）
	- 解决：确保配置中加了 `try_files $uri $uri/ /index.html;`
2. **静态资源路径错误（404）** ：
	- 原因： `package.json` 中的 `homepage` 配置错误，或 Nginx 的 `root` 路径不对
	- 解决：检查 `homepage` 为 `./` ，且 Nginx 的 `root` 指向正确的打包目录
3. **Nginx 启动失败** ：
	- 先执行 `nginx -t` 检查配置语法错误
	- 检查 80 端口是否被占用（ `netstat -tulpn | grep 80` ）
4. **跨域问题** ：
	- 如果 React 调用后端接口跨域，需要在 Nginx 中配置反向代理，示例：

---

### 总结

1. **核心步骤** ：React 项目打包（ `npm run build` ）→ 复制静态文件到 Nginx 目录 → 配置 Nginx（重点解决路由刷新 404）→ 重启 Nginx 验证。
2. **关键配置** ：Nginx 中的 `try_files $uri $uri/ /index.html;` 是解决 React 路由刷新 404 的核心。
3. **注意事项** ：打包前确保 `package.json` 的 `homepage` 配置正确，修改 Nginx 配置后先执行 `nginx -t` 检查语法。

如何在 Nginx 中配置反向代理？

如何在 Nginx 中配置负载均衡？

如何在 Nginx 中配置缓存？
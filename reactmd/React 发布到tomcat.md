react 发布到tomcat

将 React 项目部署到 Tomcat 服务器，核心是先把 React 项目打包成静态文件，再将打包产物放到 Tomcat 的指定目录下。下面我会一步步教你完整的部署流程，包括常见问题的解决方法。

### 一、前置准备

1. 确保本地已安装：Node.js（用于打包 React 项目）、Tomcat 服务器（建议 8.5+ 版本）。
2. 确认 React 项目能在本地正常运行（ `npm start` 可启动）。

### 二、步骤 1：打包 React 项目

React 项目默认使用 `create-react-app` 构建，打包流程如下：

#### 1.1 配置打包基础路径（关键）

Tomcat 部署时，项目通常不是根路径（比如 `http://localhost:8080/your-project` ），需要先修改 React 的打包路径：

- 打开项目根目录的 `package.json` 文件，添加 `homepage` 字段：
	- 如果你的项目要部署在 Tomcat 的根路径（ `http://localhost:8080/` ）， `homepage` 也可以设为 `/` ；
	- 如果部署在子路径（比如 `http://localhost:8080/my-app` ），则设为 `/my-app/` 。

#### 1.2 执行打包命令

在项目根目录打开终端，执行打包命令：

bash

运行

```bash
# 安装依赖（首次打包或依赖更新时执行）
npm install

# 打包生成静态文件
npm run build
```

打包完成后，项目根目录会生成 `build` 文件夹，里面就是可部署的静态文件（HTML/CSS/JS/ 图片等）。

### 三、步骤 2：部署到 Tomcat

#### 2.1 复制打包文件到 Tomcat

1. 找到 Tomcat 的安装目录，进入 `webapps` 文件夹（Tomcat 会自动识别该目录下的项目）；
2. 方式 1：部署为根路径（访问 `http://localhost:8080/` ）
	- 删除 `webapps` 下的 `ROOT` 文件夹（默认的 Tomcat 欢迎页）；
	- 将 `build` 文件夹内的 **所有文件** 复制到 `webapps/ROOT` 目录（如果没有 ROOT 文件夹，新建一个）。
3. 方式 2：部署为子路径（访问 `http://localhost:8080/your-app` ）
	- 在 `webapps` 下新建文件夹（比如 `your-app` ）；
	- 将 `build` 文件夹内的所有文件复制到 `webapps/your-app` 目录。

#### 2.2 启动 Tomcat

1. 进入 Tomcat 的 `bin` 目录：
	- Windows：双击 `startup.bat` ；
	- Linux/Mac：执行 `./startup.sh` 。
2. 访问测试：
	- 根路径部署： `http://localhost:8080` ；
	- 子路径部署： `http://localhost:8080/your-app` 。

### 四、常见问题及解决

#### 问题 1：刷新页面出现 404 错误

原因：React 路由（BrowserRouter）使用 HTML5 History 模式，Tomcat 不识别前端路由路径，刷新时会直接请求后端，导致 404。解决方法：配置 Tomcat 的重定向规则（添加 `web.xml` 和 `rewrite.config` ）：

1. 在 Tomcat 的 `conf` 目录下，找到 `web.xml` ，确保开启 `rewrite` 功能（Tomcat 8.5+ 默认支持）；
2. 在你的项目目录（比如 `webapps/your-app/WEB-INF` ）新建 `web.xml` ，内容如下：
	xml
	```xml
	<?xml version="1.0" encoding="UTF-8"?>
	<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
	         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
	         http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
	         version="4.0">
	    <rewrite>
	        <rule>
	            <name>React Router Rewrite</name>
	            <condition test="%{REQUEST_FILENAME} !-f" />
	            <condition test="%{REQUEST_FILENAME} !-d" />
	            <condition test="%{REQUEST_URI} !^/api" /> <!-- 排除后端接口路径 -->
	            <from>^/(.*)$</from>
	            <to type="redirect">/index.html</to>
	        </rule>
	    </rewrite>
	</web-app>
	```
3. 或者简化方案：将 React 路由改为 `HashRouter` （路径带 `#` ，比如 `http://localhost:8080/your-app/#/home` ），无需配置 Tomcat，刷新不会 404。

#### 问题 2：静态资源加载失败（404）

原因：打包路径配置错误，导致 CSS/JS 文件路径不对。解决：

- 确认 `package.json` 中的 `homepage` 配置正确（比如子路径部署时设为 `/your-app/` ）；
- 打包后检查 `build/index.html` 中的资源路径，确保是相对路径或正确的绝对路径。

#### 问题 3：Tomcat 端口被占用

解决：修改 Tomcat 的 `conf/server.xml` 文件，修改端口号（默认 8080）：

xml

```xml
<Connector port="8081" protocol="HTTP/1.1"
           connectionTimeout="20000"
           redirectPort="8443" />
```

修改后重启 Tomcat，访问 `http://localhost:8081/your-app` 。

### 总结

1. 部署 React 到 Tomcat 的核心是：先通过 `npm run build` 打包成静态文件，再将打包产物放到 Tomcat 的 `webapps` 目录；
2. 非根路径部署时，必须配置 `package.json` 中的 `homepage` 为相对路径或对应子路径；
3. 刷新页面 404 问题，优先用 `HashRouter` 简化解决，或配置 Tomcat 的 rewrite 规则适配 `BrowserRouter` 。

如何解决 React 项目打包后在 Tomcat 中出现的资源路径问题？

如何在 Tomcat 中配置静态资源映射？

如何在 React 项目中使用环境变量？
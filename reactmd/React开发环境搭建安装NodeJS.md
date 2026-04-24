## 搭建React开发环境安装NodeJS

第一步：

打开网站[Node.js — Download Node.js®](https://nodejs.org/en/download)

```
https://nodejs.org/en/download
```

第二步：

下载node.js安装包，根据软件提示安装nodejs，配置环境变量

第三步：

打开终端，以管理员方式，执行命令，检查是否安装成功，如果有相关软件和版本提示，说明安装成功

```
node -v
npm -v
```

常见异常1：找不到该命令，原因：没有配置用户环境变量

常见异常2：找不到该命令，原因：没有使用管理员账户安装

第四步：

打开终端，使用npm安装pnpm，(pnpm - 速度快、节省磁盘空间的软件包管理器)

```
npm install -g pnpm
```

验证安装是否成功：

```
pnpm --version
```

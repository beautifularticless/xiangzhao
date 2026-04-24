rust https

Rust 实现 HTTPS 主流方案分两类： **客户端（reqwest/ureq）** 、 **服务端（axum+rustls/hyper-rustls）** ；优先用 **纯 Rust 栈（rustls）** ，避免 OpenSSL 依赖与编译问题。

---

### 一、客户端 HTTPS（reqwest，最常用）

#### 1\. 依赖

```toml
# Cargo.toml
[dependencies]
reqwest = { version = "0.12", features = ["json", "rustls-tls"] }
tokio = { version = "1", features = ["full"] }
```

- 默认启用 **rustls** （纯 Rust TLS，无 OpenSSL）。
- 如需系统 TLS：启用 `native-tls` 或 `native-tls-vendored` 。

#### 2\. 异步 HTTPS 请求

```rust
use reqwest::Client;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client=Client::new();
    let res=client
        .get("https://httpbin.org/get")
        .send()
        .await?;

    println!("Status: {}", res.status());
    let body=res.text().await?;
    println!("Body: {}", body);
    Ok(())
}
```

#### 3\. 自定义 TLS 配置（根证书 / 跳过验证）

```rust
use reqwest::ClientBuilder;
use rustls::Certificate;
use std::fs::File;
use std::io::Read;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // 1. 加载自定义根证书
    let mut cert_file=File::open("ca.pem")?;
    let mut cert_data=Vec::new();
    cert_file.read_to_end(&mut cert_data)?;
    let cert=Certificate(cert_data);

    // 2. 配置 TLS
    let client=ClientBuilder::new()
        .use_rustls_tls()
        .add_root_certificate(cert)
        .danger_accept_invalid_certs(true) // 仅开发用！
        .build()?;

    let res=client.get("https://localhost:8443").send().await?;
    println!("{}", res.status());
    Ok(())
}
```

---

### 二、服务端 HTTPS（axum+rustls，生产首选）

#### 1\. 生成自签名证书（开发）

```bash
# 安装 openssl（Linux/macOS）
sudo apt install openssl

# 生成证书+私钥（PEM 格式）
openssl req -x509 -newkey rsa:4096 \
  -keyout localhost-key.pem \
  -out localhost.pem \
  -days 365 -sha256 -subj "/CN=localhost"
```

#### 2\. 依赖

```toml
# Cargo.toml
[dependencies]
axum = "0.7"
axum-server = { version = "0.6", features = ["rustls"] }
rustls = "0.21"
rustls-pemfile = "1.0"
tokio = { version = "1", features = ["full"] }
```

#### 3\. HTTPS 服务代码

```rust
use axum::{routing::get, Router};
use axum_server::tls_rustls::RustlsConfig;
use rustls_pemfile::{certs, pkcs8_private_keys};
use std::fs::File;
use std::io::BufReader;

// 路由处理
async fn hello() -> &'static str {
    "Hello, HTTPS!"
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // 1. 加载证书+私钥
    let cert_chain={
        let mut f=BufReader::new(File::open("localhost.pem")?);
        certs(&mut f)?
            .into_iter()
            .map(rustls::Certificate)
            .collect()
    };

    let private_key={
        let mut f=BufReader::new(File::open("localhost-key.pem")?);
        pkcs8_private_keys(&mut f)?
            .into_iter()
            .map(rustls::PrivateKey)
            .next()
            .ok_or("No private key")?
    };

    // 2. TLS 配置
    let tls_config=RustlsConfig::from_parts(cert_chain, private_key);

    // 3. 路由
    let app=Router::new().route("/", get(hello));

    // 4. 启动 HTTPS 服务（8443 端口）
    axum_server::bind_rustls(([127, 0, 0, 1], 8443), tls_config)
        .serve(app.into_make_service())
        .await?;

    Ok(())
}
```

#### 4\. 测试

```bash
curl -k https://localhost:8443  # -k 跳过证书验证（开发用）
```

---

### 三、其他方案

#### 1\. hyper-rustls（底层，自定义服务）

```toml
hyper = { version = "1", features = ["full"] }
hyper-rustls = "0.24"
rustls = "0.21"
tokio = { version = "1", features = ["rt-multi-thread"] }
```

#### 2\. ureq（轻量阻塞客户端）

```toml
ureq = { version = "2", features = ["rustls"] }
```

```rust
let res=ureq::get("https://httpbin.org/get").call()?;
println!("{}", res.into_string()?);
```

---

### 四、生产最佳实践

1. **证书管理** ：用 Let’s Encrypt（certbot）获取免费可信证书，自动续期。
2. **TLS 版本** ：强制 TLS 1.2+，禁用老旧算法。
3. **安全配置** ：
	- 客户端： **不跳过证书验证** ，仅开发用 `danger_accept_invalid_certs` 。
		- 服务端：私钥文件权限设为 **600** ，防止泄露。
4. **性能** ： **rustls 纯 Rust 实现** ，性能接近 OpenSSL，无 GC 开销。

---

### 五、常见问题

- **编译失败（OpenSSL）** ：改用 `rustls-tls` 特性，避免系统 OpenSSL 依赖。
- **证书不被信任** ：生产环境用正规 CA 证书；开发可导入自签名证书到系统信任库。

要不要我把上面的代码整理成一个可直接运行的工程模板（含 Cargo.toml、证书生成脚本和完整 src/main.rs），你直接编译就能用？

如何在服务端使用Rust实现HTTPS？

分享一些Rust实现HTTPS的代码示例

如何在Rust中配置和使用自签名证书进行HTTPS通信？
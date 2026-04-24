rust ssl

Rust 生态里做 SSL/TLS 主要两条路：

1. **rustls** ：纯 Rust 实现，无 OpenSSL 依赖，安全、现代、只支持 TLS1.2/1.3。
2. **openssl（rust-openssl）** ：绑定系统 OpenSSL，功能全、兼容旧协议，但要装 OpenSSL 开发库。

下面给你最简可用示例（同步 + 异步）。

---

## 一、rustls（推荐，纯 Rust）

### Cargo.toml

```toml
[dependencies]
rustls = "0.23"
tokio = { version = "1.0", features = ["rt-multi-thread", "macros"] }
tokio-rustls = "0.26"
webpki-roots = "0.25"  # 根证书
```

### 1\. 异步客户端（tokio + rustls）

```rust
use std::sync::Arc;
use tokio::net::TcpStream;
use tokio_rustls::rustls::{ClientConfig, RootCertStore, ServerName};
use tokio_rustls::TlsConnector;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // 1. 配置根证书
    let mut root_store = RootCertStore::empty();
    root_store.extend(webpki_roots::TLS_SERVER_ROOTS.iter().cloned());

    let config = ClientConfig::builder()
        .with_root_certificates(root_store)
        .with_no_client_auth();

    let connector = TlsConnector::from(Arc::new(config));

    // 2. 连接
    let stream = TcpStream::connect(("example.com", 443)).await?;
    let domain = ServerName::try_from("example.com")?;
    let mut tls_stream = connector.connect(domain, stream).await?;

    // 3. 发 HTTP 请求
    tls_stream.write_all(b"GET / HTTP/1.1\r\nHost: example.com\r\n\r\n").await?;

    let mut buf = Vec::new();
    tls_stream.read_to_end(&mut buf).await?;
    println!("{}", String::from_utf8_lossy(&buf));

    Ok(())
}
```

### 2\. 异步服务端（axum + rustls HTTPS）

```toml
# Cargo.toml
axum = "0.7"
axum-server = { version = "0.6", features = ["tls-rustls"] }
```

```rust
use axum::{routing::get, Router};
use axum_server::tls_rustls::RustlsConfig;

async fn hello() -> &'static str {
    "Hello, HTTPS!"
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // 证书+私钥（PEM 格式）
    let config = RustlsConfig::from_pem_file("cert.pem", "key.pem").await?;

    let app = Router::new().route("/", get(hello));

    axum_server::bind_rustls(("0.0.0.0", 443), config)
        .serve(app.into_make_service())
        .await?;

    Ok(())
}
```

---

## 二、openssl（绑定系统 OpenSSL）

### Cargo.toml

```toml
[dependencies]
openssl = "0.10"
```

### 1\. 同步客户端

```rust
use openssl::ssl::{SslConnector, SslMethod};
use std::io::{Read, Write};
use std::net::TcpStream;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let connector = SslConnector::builder(SslMethod::tls())?.build();

    let stream = TcpStream::connect(("example.com", 443))?;
    let mut stream = connector.connect("example.com", stream)?;

    stream.write_all(b"GET / HTTP/1.1\r\nHost: example.com\r\n\r\n")?;

    let mut res = Vec::new();
    stream.read_to_end(&mut res)?;
    println!("{}", String::from_utf8_lossy(&res));

    Ok(())
}
```

### 2\. 同步服务端

```rust
use openssl::ssl::{SslAcceptor, SslFiletype, SslMethod};
use std::net::{TcpListener, TcpStream};
use std::sync::Arc;
use std::thread;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut acceptor = SslAcceptor::mozilla_intermediate(SslMethod::tls())?;
    acceptor.set_private_key_file("key.pem", SslFiletype::PEM)?;
    acceptor.set_certificate_chain_file("cert.pem")?;
    acceptor.check_private_key()?;
    let acceptor = Arc::new(acceptor.build());

    let listener = TcpListener::bind(("0.0.0.0", 443))?;
    println!("Listening on :443");

    for stream in listener.incoming() {
        let stream = stream?;
        let acceptor = acceptor.clone();
        thread::spawn(move || {
            let mut stream = acceptor.accept(stream).unwrap();
            stream.write_all(b"Hello, OpenSSL!\n").unwrap();
        });
    }

    Ok(())
}
```

---

## 三、选型建议

- **新项目 / 追求安全无依赖** ：选 **rustls + tokio-rustls** 。
- **需要兼容旧系统 / 旧协议（TLS1.0/1.1）** ：选 **openssl** 。
- **生产环境** ：rustls 默认只开 TLS1.2/1.3、安全套件，更安全；openssl 需手动禁用弱协议 / 弱加密。

---

如果你告诉我：

- 是客户端还是服务端
- 同步还是异步（tokio）
- 是否需要自签名证书 / 双向认证

我可以直接给你一份可直接跑的完整工程（含证书生成命令）。
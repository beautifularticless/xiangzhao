rust http

Rust 的 HTTP 生态分三块： **底层基础库（http、hyper）** 、 **客户端（reqwest 为主）** 、 **服务端框架（Axum、Actix‑Web、Rocket）** ，全链路异步、高性能、内存安全。

---

### 一、基础库：http + hyper

- **http** ：只定义 **通用 HTTP 类型** （Request/Response/Uri/Method/StatusCode/HeaderMap）， **不做 IO** ，是所有 HTTP 库的 “标准库”。
- **hyper** ：Rust 官方异步 HTTP 实现，支持 **HTTP/1.1 + HTTP/2** ，底层 IO，无 GC、零成本抽象，性能极高；Axum、Warp、reqwest 都基于它。

Cargo.toml

```toml
[dependencies]
http = "1.1"
hyper = { version = "1.1", features = ["full"] }
tokio = { version = "1.0", features = ["rt-multi-thread", "macros"] }
```

---

### 二、HTTP 客户端：reqwest（推荐）

#### 1\. 异步 GET（JSON）

```rust
use reqwest;
use std::collections::HashMap;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let resp = reqwest::get("https://httpbin.org/ip")
        .await?
        .json::<HashMap<String, String>>()
        .await?;
    println!("{resp:#?}");
    Ok(())
}
```

#### 2\. 异步 POST（JSON）

```rust
use reqwest::Client;
use serde_json::json;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = Client::new();
    let resp = client
        .post("https://httpbin.org/post")
        .json(&json!({"name": "Rust", "age": 20}))
        .await?;
    println!("{}", resp.text().await?);
    Ok(())
}
```

---

### 三、HTTP 服务端：主流框架对比

表格

| 框架 | 运行时 | 性能（QPS） | 特点 | 适用场景 |
| --- | --- | --- | --- | --- |
| **Axum** | Tokio | 152k | 官方推荐、路由简洁、Tower 生态 | 高性能 API、微服务 |
| **Actix‑Web** | Actix | 148k | 极快、Actor 模型、功能全 | 高并发服务、Web 应用 |
| **Rocket** | Tokio | 120k | 类型安全、宏驱动、易上手 | 快速原型、小型服务 |

#### 1\. Axum 最简服务（Hello World）

Cargo.toml

```toml
[dependencies]
axum = "0.7"
tokio = { version = "1.0", features = ["rt-multi-thread", "macros"] }
```

main.rs

```rust
use axum::{routing::get, Router};

#[tokio::main]
async fn main() {
    let app = Router::new().route("/", get(|| async { "Hello, Axum!" }));
    axum::Server::bind(&([127, 0, 0, 1], 3000).into())
        .serve(app.into_make_service())
        .await
        .unwrap();
}
```

#### 2\. Actix‑Web 示例

```rust
use actix_web::{web, App, HttpServer, Responder};

async fn index() -> impl Responder {
    "Hello, Actix‑Web!"
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| App::new().route("/", web::get().to(index)))
        .bind(("127.0.0.1", 8080))?
        .run()
        .await
}
```

---

### 四、选型建议

- **客户端** ：优先 **reqwest** （简单、稳定、功能全）；极致性能 / 自定义连接池用 **hyper** 。
- **服务端** ：
	- 新手 / 快速开发 → **Rocket** （类型安全、宏友好）。
		- 高性能 API / 微服务 → **Axum** （官方、Tower 生态、简洁）。
		- 超高并发 / 复杂业务 → **Actix‑Web** （Actor 模型、极致性能）。

---

### 五、扩展生态

- **中间件** ：tower（Axum）、actix‑web‑middleware（Actix），含限流、日志、CORS、认证。
- **WebSocket** ：axum‑ws、actix‑web‑ws，原生支持、高性能。
- **HTTP/3** ：quinn（底层）、reqwest‑quinn（客户端）、axum‑quinn（服务端）。

需要我把以上示例整理成一个可直接运行的 **Axum+reqwest 最小项目模板** 吗？

如何使用reqwest发送HTTP请求？

介绍一下Rust语言的特点

分享一些Rust语言的学习资源
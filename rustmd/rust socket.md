rust socket

Rust 做 Socket 主要分两类： **标准库同步（std::net） **和** 异步（tokio）** ，常用 TCP、UDP。下面给可直接运行的最小示例。

---

## 一、标准库：TCP 同步（最基础）

### 1\. TCP 服务端（std）

```rust
// tcp_server.rs
use std::net::{TcpListener, TcpStream};
use std::io::{Read, Write};

fn handle_client(mut stream: TcpStream) {
    let mut buf = [0; 1024];
    match stream.read(&mut buf) {
        Ok(n) if n > 0 => {
            let msg = String::from_utf8_lossy(&buf[..n]);
            println!("收到：{}", msg);
            let _ = stream.write_all(b"hello from server");
        }
        _ => {}
    }
}

fn main() {
    let listener = TcpListener::bind(("127.0.0.1", 8080)).unwrap();
    println!("监听 8080...");
    for stream in listener.incoming() {
        match stream {
            Ok(s) => handle_client(s),
            Err(e) => eprintln!("accept err:{}", e),
        }
    }
}
```

### 2\. TCP 客户端（std）

```rust
// tcp_client.rs
use std::net::TcpStream;
use std::io::{Read, Write};

fn main() {
    let mut stream = TcpStream::connect(("127.0.0.1", 8080)).unwrap();
    stream.write_all(b"hello from client").unwrap();

    let mut buf = [0; 1024];
    let n = stream.read(&mut buf).unwrap();
    println!("收到：{}", String::from_utf8_lossy(&buf[..n]));
}
```

运行：

```bash
# 终端1
rustc tcp_server.rs && ./tcp_server

# 终端2
rustc tcp_client.rs && ./tcp_client
```

---

## 二、标准库：UDP 同步

### UDP 服务端

```rust
// udp_server.rs
use std::net::UdpSocket;

fn main() {
    let socket = UdpSocket::bind("127.0.0.1:9999").unwrap();
    let mut buf = [0; 1024];
    loop {
        let (n, src) = socket.recv_from(&mut buf).unwrap();
        let msg = String::from_utf8_lossy(&buf[..n]);
        println!("from {}: {}", src, msg);
        socket.send_to(b"udp pong", src).unwrap();
    }
}
```

### UDP 客户端

```rust
// udp_client.rs
use std::net::UdpSocket;

fn main() {
    let socket = UdpSocket::bind("127.0.0.1:0").unwrap(); // 随机端口
    socket.send_to(b"udp ping", "127.0.0.1:9999").unwrap();

    let mut buf = [0; 1024];
    let (n, _) = socket.recv_from(&mut buf).unwrap();
    println!("收到：{}", String::from_utf8_lossy(&buf[..n]));
}
```

---

## 三、异步 TCP（tokio，生产常用）

### Cargo.toml

```toml
[dependencies]
tokio = { version = "1.0", features = ["full"] }
```

### 异步服务端

```rust
// async_tcp_server.rs
use tokio::net::{TcpListener, TcpStream};
use tokio::io::{AsyncReadExt, AsyncWriteExt};

async fn handle_client(mut stream: TcpStream) {
    let mut buf = [0; 1024];
    if let Ok(n) = stream.read(&mut buf).await {
        if n > 0 {
            let msg = String::from_utf8_lossy(&buf[..n]);
            println!("收到：{}", msg);
            let _ = stream.write_all(b"async hello").await;
        }
    }
}

#[tokio::main]
async fn main() {
    let listener = TcpListener::bind("127.0.0.1:8080").await.unwrap();
    println!("async 监听 8080...");
    loop {
        let (stream, _) = listener.accept().await.unwrap();
        tokio::spawn(handle_client(stream));
    }
}
```

### 异步客户端

```rust
// async_tcp_client.rs
use tokio::net::TcpStream;
use tokio::io::{AsyncReadExt, AsyncWriteExt};

#[tokio::main]
async fn main() {
    let mut stream = TcpStream::connect("127.0.0.1:8080").await.unwrap();
    stream.write_all(b"async client msg").await.unwrap();

    let mut buf = [0; 1024];
    let n = stream.read(&mut buf).await.unwrap();
    println!("收到：{}", String::from_utf8_lossy(&buf[..n]));
}
```

---

## 四、常用要点

1. **std::net**
	- `TcpListener` ：服务端监听
		- `TcpStream` ：TCP 连接流
		- `UdpSocket` ：UDP 套接字（无连接）
2. **tokio**
	- 异步非阻塞，高并发首选
		- `#[tokio::main]` 标记异步入口
		- `tokio::spawn` 开协程处理连接
3. **常用方法**

---

要不要我把上面示例整理成一个可直接编译运行的 **Cargo 工程模板** ，包含完整目录结构和可一键运行的脚本？
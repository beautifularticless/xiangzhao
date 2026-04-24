rust时间日期

Rust 标准库只提供 **系统时间 + 时长** （ `std::time` ），日常开发几乎都用 **chrono** crate 做日期时间、格式化、时区与计算。下面从 “标准库 → chrono 基础 → 格式化 / 解析 → 时区 → 常用计算” 一步步给你完整示例。

---

## 一、标准库 std::time（仅基础时间戳 / 时长）

```rust
use std::time::{SystemTime, UNIX_EPOCH, Duration, Instant};

fn main() {
    // 1. 系统当前时间（距 1970-01-01 UTC 的时间）
    let now = SystemTime::now();
    let ts = now.duration_since(UNIX_EPOCH).unwrap().as_secs();
    println!("当前时间戳（秒）：{}", ts);

    // 2. 时长 Duration
    let one_hour = Duration::from_hours(1);
    let thirty_sec = Duration::from_secs(30);
    println!("1小时+30秒：{:?}", one_hour + thirty_sec);

    // 3. 高精度计时（Instant，单调递增）
    let start = Instant::now();
    std::thread::sleep(Duration::from_millis(100));
    let elapsed = start.elapsed();
    println!("耗时：{:?}", elapsed);
}
```

---

## 二、chrono 快速入门（必用）

### 1\. 安装（Cargo.toml）

```toml
[dependencies]
chrono = { version = "0.4", features = ["serde"] } # 常用：序列化支持
# 如需完整时区（如 Asia/Shanghai），加：
# chrono = { version = "0.4", features = ["serde", "tz"] }
# chrono-tz = "0.8"
```

### 2\. 核心类型

- `DateTime<Utc>` ：带时区的 UTC 时间（推荐存储）
- `DateTime<Local>` ：带时区的本地时间
- `NaiveDateTime` ：无时区的日期时间（ `YYYY-MM-DD HH:MM:SS` ）
- `NaiveDate` / `NaiveTime` ：纯日期 / 纯时间
- `Duration` ：时间间隔（天 / 时 / 分 / 秒）

### 3\. 获取当前时间

```rust
use chrono::{Utc, Local, DateTime};

fn main() {
    // UTC 时间（推荐用于数据库、日志）
    let utc_now: DateTime<Utc> = Utc::now();
    println!("UTC 现在：{}", utc_now);

    // 本地时间（系统时区，如 UTC+8）
    let local_now: DateTime<Local> = Local::now();
    println!("本地现在：{}", local_now);
}
```

---

## 三、格式化与解析（最常用）

### 1\. 格式化（format + 格式符）

```rust
use chrono::Local;

fn main() {
    let now = Local::now();
    // 常用格式符：
    // %Y 年 %m 月 %d 日 %H 时 %M 分 %S 秒 %z 时区
    let fmt1 = now.format("%Y-%m-%d %H:%M:%S").to_string();
    let fmt2 = now.format("%Y年%m月%d日 %H:%M:%S").to_string();
    println!("标准格式：{}", fmt1);
    println!("中文格式：{}", fmt2);
}
```

### 2\. 字符串解析 → 时间

```rust
use chrono::{NaiveDateTime, DateTime, Utc, Local, ParseError};

fn main() -> Result<(), ParseError> {
    // 1. 解析无时区字符串 → NaiveDateTime
    let s = "2026-04-24 22:30:00";
    let dt = NaiveDateTime::parse_from_str(s, "%Y-%m-%d %H:%M:%S")?;
    println!("解析结果：{}", dt);

    // 2. 解析带时区 → DateTime<Utc>/Local
    let s_utc = "2026-04-24T22:30:00Z"; // RFC3339
    let dt_utc = DateTime::parse_from_rfc3339(s_utc)?;
    println!("RFC3339 解析：{}", dt_utc);

    Ok(())
}
```

---

## 四、时区转换（UTC ↔ 北京时间）

### 1\. 固定偏移（UTC+8，最常用）

```rust
use chrono::{Utc, Local, FixedOffset, DateTime};

fn main() {
    let utc_now = Utc::now();
    // 北京时间：UTC+8（8*3600 秒）
    let cst = FixedOffset::east_opt(8 * 3600).unwrap();
    let cst_now: DateTime<FixedOffset> = utc_now.with_timezone(&cst);

    println!("UTC：{}", utc_now);
    println!("北京时间：{}", cst_now);

    // 本地时间转 UTC
    let local_now = Local::now();
    let utc_from_local: DateTime<Utc> = DateTime::from(local_now);
    println!("本地转 UTC：{}", utc_from_local);
}
```

### 2\. 命名时区（需 tz 特性 + chrono-tz）

```rust
use chrono::{DateTime, TimeZone};
use chrono_tz::Asia::Shanghai;

fn main() {
    // 上海时间（Asia/Shanghai）
    let sh_now = Shanghai::now();
    println!("上海时间：{}", sh_now);

    // 转 UTC
    let utc = sh_now.with_timezone(&chrono_tz::UTC);
    println!("上海 → UTC：{}", utc);
}
```

---

## 五、时间计算（加减、差值）

```rust
use chrono::{Utc, Duration, NaiveDate};

fn main() {
    let now = Utc::now();

    // 1. 加法：1天2小时30分钟后
    let later = now + Duration::days(1) + Duration::hours(2) + Duration::minutes(30);
    println!("1天2小时30分后：{}", later);

    // 2. 减法：3小时前
    let earlier = now - Duration::hours(3);
    println!("3小时前：{}", earlier);

    // 3. 计算两个时间差
    let diff = later - earlier;
    println!("时间差：{} 小时", diff.num_hours());
    println!("时间差：{} 天", diff.num_days());

    // 4. 日期计算
    let today = NaiveDate::from_ymd_opt(2026, 4, 24).unwrap();
    let tomorrow = today + Duration::days(1);
    println!("明天：{}", tomorrow);
}
```

---

## 六、常用格式符速查表

表格

| 符号 | 说明 | 示例 |
| --- | --- | --- |
| %Y | 4 位年 | 2026 |
| %m | 2 位月 | 04 |
| %d | 2 位日 | 24 |
| %H | 24 小时制 | 22 |
| %M | 分钟 | 30 |
| %S | 秒 | 59 |
| %z | 时区偏移 | +08:00 |
| %F | 等价 % Y-% m-% d | 2026-04-24 |
| %T | 等价 % H:% M:% S | 22:30:59 |

---

## 七、最佳实践总结

1. **存储用 UTC** ：数据库、日志统一存 `DateTime<Utc>` ，避免时区混乱。
2. **展示用本地 / 北京时间** ：前端 / 界面显示时转 `Local` 或 `UTC+8` 。
3. **格式化用 `%Y-%m-%d %H:%M:%S`** ：通用、易解析、跨语言兼容。
4. **无时区场景用 `NaiveDateTime`** ：如纯日期计算、无跨时区需求。

需要我把以上代码整理成一个可直接运行的 `main.rs` ，并补充时间戳与日期互转的示例吗？
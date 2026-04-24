rust生成markdown文档

在 Rust 中生成 Markdown 文档主要有两大场景： **代码中动态生成 Markdown 字符串** （用于输出报告、README 等）和 **为 Rust 项目生成 API 文档** 。以下是两套完整的实践方案。


### 一、动态生成 Markdown（代码中构造）

如果你需要在程序运行时，通过代码逻辑拼接生成 Markdown 文件内容，推荐使用 `markdown-builder` 库。

#### 1\. 添加依赖

```bash
cargo add markdown-builder
```

#### 2\. 代码示例（基础用法）

```rust
use markdown_builder::{Markdown, ImageBuilder, ListBuilder};

fn main() {
    // 1. 创建文档
    let mut doc = Markdown::new();

    // 2. 一级标题
    doc.heading(1, "Rust 生成 Markdown 示例");

    // 3. 段落
    doc.paragraph("这是一个使用 Rust 代码动态生成的 Markdown 文档。");
    doc.paragraph("支持**粗体**、*斜体*、\`行内代码\`等基础语法。");

    // 4. 二级标题
    doc.heading(2, "功能列表");

    // 5. 无序列表
    let mut list = ListBuilder::unordered();
    list.item("支持标题、段落、列表");
    list.item("支持代码块、图片、链接");
    list.item("支持表格、引用");
    doc.list(list);

    // 6. 三级标题 + 代码块
    doc.heading(3, "Rust 代码示例");
    doc.code_block(
        "rust",
        r#"fn main() {
    println!("Hello, Markdown!");
}"#
    );

    // 7. 图片
    let image = ImageBuilder::new()
        .url("https://www.rust-lang.org/static/images/rust-logo-blk.svg")
        .text("Rust Logo")
        .build();
    doc.image(image);

    // 8. 链接
    doc.paragraph("访问 [Rust 官网](https://www.rust-lang.org/) 了解更多。");

    // 9. 引用
    doc.blockquote("Rust 是一门赋予每个人构建可靠且高效软件能力的语言。");

    // 10. 渲染为字符串并保存
    let markdown_content = doc.render();
    std::fs::write("output.md", &markdown_content).expect("写入文件失败");

    println!("Markdown 文档已生成：output.md");
}
```

#### 3\. 生成效果 (output.md)

```markdown
# Rust 生成 Markdown 示例

这是一个使用 Rust 代码动态生成的 Markdown 文档。

支持**粗体**、*斜体*、\`行内代码\`等基础语法。

## 功能列表

- 支持标题、段落、列表
- 支持代码块、图片、链接
- 支持表格、引用

### Rust 代码示例

\`\`\`rust
fn main() {
    println!("Hello, Markdown!");
}
```

访问 [Rust 官网](https://www.rust-lang.org/) 了解更多。

> Rust 是一门赋予每个人构建可靠且高效软件能力的语言。

```
---

### 二、生成 Rust 项目 API 文档（rustdoc）
Rust 官方提供内置工具 \`rustdoc\`，能直接从代码注释（支持 Markdown 语法）生成标准的 HTML 文档。

#### 1. 编写文档注释
- **\`///\`**：为**接下来的**项（函数、结构体等）生成文档
- **\`//!\`**：为**当前**项（通常是 crate 或模块）生成文档

\`\`\`rust
//! # 我的数学库
//! 一个简单的数学计算工具库，提供基础运算功能。

/// 计算两个数的和
///
/// # 参数
/// - \`a\`: 第一个整数
/// - \`b\`: 第二个整数
///
/// # 返回值
/// 两个整数的和
///
/// # 示例
/// \`\`\`
/// let result = my_math::add(2, 3);
/// assert_eq!(result, 5);
/// \`\`\`
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}

/// 计算两个数的差
pub fn subtract(a: i32, b: i32) -> i32 {
    a - b
}

/// 代表一个点的结构体
#[derive(Debug)]
pub struct Point {
    /// X 坐标
    pub x: f64,
    /// Y 坐标
    pub y: f64,
}

impl Point {
    /// 创建一个新的点
    pub fn new(x: f64, y: f64) -> Self {
        Point { x, y }
    }
}
```

#### 2\. 生成文档命令

```bash
# 生成项目文档（包含所有依赖）
cargo doc

# 仅生成当前项目文档（速度更快）
cargo doc --no-deps

# 生成并自动在浏览器打开
cargo doc --open

# 运行文档中的示例代码（文档测试）
cargo test --doc
```

#### 3\. 文档位置

生成的 HTML 文档位于项目目录的：

```
target/doc/[crate_name]/index.html
```

---

### 三、其他常用工具

- **`pulldown-cmark`** ：Rust 生态最流行的 Markdown 解析器， `rustdoc` 底层依赖。适合需要解析、转换 Markdown 的场景。
- **`mdbook`** ：用 Rust 编写的文档工具，类似 GitBook。将一系列 Markdown 文件构建成完整的在线书籍，常用于写教程、书籍。
- **`markdown` (crate)** ：支持 CommonMark、GFM、数学公式等全特性的解析 / 渲染库。

需要我帮你生成一个 **可直接运行的完整项目模板** ，包含动态生成 Markdown 并自动保存到文件的功能吗？
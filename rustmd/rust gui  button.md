rust gui button

下面给你几种主流 Rust GUI 库的 Button 写法（可直接编译运行），分别是： **egui / eframe** 、 **Iced** 、 **Druid** 、 **Slint** ，你可以按场景选用。

---

## 一、egui + eframe（最容易上手，跨平台）

### Cargo.toml

```toml
[dependencies]
eframe = "0.22"
egui = "0.22"
```

### 最小示例（带按钮点击）

```rust
use eframe::egui;

fn main() -> Result<(), eframe::Error> {
    let options = eframe::NativeOptions::default();
    eframe::run_native(
        "egui Button Demo",
        options,
        Box::new(|_cc| Box::new(MyApp::default())),
    )
}

#[derive(Default)]
struct MyApp {
    count: i32,
}

impl eframe::App for MyApp {
    fn update(&mut self, ctx: &egui::Context, _frame: &mut eframe::Frame) {
        egui::CentralPanel::default().show(ctx, |ui| {
            ui.heading("egui 按钮示例");

            // 基础按钮
            if ui.button("点击我").clicked() {
                println!("按钮被点击");
            }

            // 带计数的按钮
            ui.horizontal(|ui| {
                if ui.button("-").clicked() {
                    self.count -= 1;
                }
                ui.label(format!("计数：{}", self.count));
                if ui.button("+").clicked() {
                    self.count += 1;
                }
            });

            // 自定义样式按钮
            egui::Button::new("自定义按钮")
                .fill(egui::Color32::BLUE)
                .text_color(egui::Color32::WHITE)
                .corner_radius(8.0)
                .ui(ui);
        });
    }
}
```

![image](https://p3-flow-imagex-sign.byteimg.com/labis/image/ce254794867ed3b052bdf66694343fce~tplv-a9rns2rl98-pc_smart_face_crop-v1:272:204.image?lk3s=8e244e95&rcl=2026042422403575CB083E9D953323DC8E&rrcfp=cee388b0&x-expires=2092401649&x-signature=udCsoJlP3lNyB2KT6e7fiXZyAtc%3D)

---

## 二、Iced（简洁声明式，跨平台）

### Cargo.toml

```toml
[dependencies]
iced = "0.10"
```

### 示例

```rust
use iced::{
    widget::{button, column, text},
    Application, Command, Element, Settings, Theme,
};

fn main() -> iced::Result {
    Counter::run(Settings::default())
}

struct Counter {
    count: i32,
}

#[derive(Debug, Clone, Copy)]
enum Message {
    Increment,
    Decrement,
}

impl Application for Counter {
    type Message = Message;
    type Theme = Theme;
    type Executor = iced::executors::Default;
    type Flags = ();

    fn new(_flags: ()) -> (Self, Command<Message>) {
        (Self { count: 0 }, Command::none())
    }

    fn title(&self) -> String {
        "Iced Button Demo".into()
    }

    fn update(&mut self, message: Message) -> Command<Message> {
        match message {
            Message::Increment => self.count += 1,
            Message::Decrement => self.count -= 1,
        }
        Command::none()
    }

    fn view(&self) -> Element<Message> {
        column![
            button("+").on_press(Message::Increment),
            text(self.count).size(30),
            button("-").on_press(Message::Decrement),
        ]
        .padding(20)
        .into()
    }
}
```

Iced

---

## 三、Druid（原生质感，数据驱动）

### Cargo.toml

```toml
[dependencies]
druid = "0.11"
```

### 示例

```rust
use druid::{
    widget::{Button, Column, Label},
    AppLauncher, Data, Lens, Widget, WidgetExt, WindowDesc,
};

#[derive(Clone, Data, Lens)]
struct AppState {
    count: i32,
}

fn main() {
    let main_window = WindowDesc::new(build_ui())
        .title("Druid Button Demo")
        .window_size((300.0, 200.0));

    let initial_state = AppState { count: 0 };

    AppLauncher::with_window(main_window)
        .launch(initial_state)
        .expect("Failed to launch app");
}

fn build_ui() -> impl Widget<AppState> {
    Column::new()
        .with_child(Label::new(|data: &AppState| format!("计数：{}", data.count)).padding(10))
        .with_child(Button::new("+").on_click(|ctx, data: &mut AppState, _env| {
            data.count += 1;
            ctx.request_update();
        }))
        .with_child(Button::new("-").on_click(|ctx, data: &mut AppState, _env| {
            data.count -= 1;
            ctx.request_update();
        }))
        .padding(20)
}
```

Druid

---

## 四、Slint（UI 用类似 QML 写，Rust 逻辑）

### Cargo.toml

```toml
[dependencies]
slint = "1.0"
```

### 示例

```rust
slint::slint! {
    export component MainWindow inherits Window {
        width: 300px;
        height: 200px;
        title: "Slint Button Demo";

        in-out property <int> count: 0;

        VerticalBox {
            Text { text: "计数：" + count; font-size: 20px; }
            Button {
                text: "+";
                clicked => { count += 1; }
            }
            Button {
                text: "-";
                clicked => { count -= 1; }
            }
        }
    }
}

fn main() {
    MainWindow::new().unwrap().run().unwrap();
}
```

Slint

---

### 选型建议

- **快速做工具 / 调试界面** ：选 **egui**
- **现代简洁跨平台 App** ：选 **Iced**
- **偏原生、数据绑定** ：选 **Druid**
- **UI 设计师写界面、Rust 做逻辑** ：选 **Slint**

你想要我帮你把其中一种改成： **带图标按钮 + 圆角 + 颜色主题 + 禁用状态** 的完整可运行示例吗？

介绍一下Druid库的特点

如何在Rust中使用Slint创建GUI应用程序？

比较一下Rust中egui和Iced的优缺点
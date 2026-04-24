java 获取日期时间

在 Java 中获取日期时间有两种主流方式： **传统的 `java.util.Date` / `Calendar` （JDK 8 之前）** 和 **JDK 8 新增的 `java.time` 包（推荐）** 。 `java.time` 包是线程安全、设计更优雅的新一代日期时间 API，我会重点讲解这种方式。

### 一、JDK 8+ 推荐方式（java.time 包）

#### 1\. 获取当前日期时间（最常用）

java

```java
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;

public class DateTimeDemo {
    public static void main(String[] args) {
        // 1. 获取当前本地日期（只有年月日，无时分秒）
        LocalDate currentDate = LocalDate.now();
        System.out.println("当前日期：" + currentDate); // 输出示例：2026-03-08

        // 2. 获取当前本地时间（只有时分秒，无年月日）
        LocalTime currentTime = LocalTime.now();
        System.out.println("当前时间：" + currentTime); // 输出示例：15:30:45.123

        // 3. 获取当前本地日期时间（年月日+时分秒）
        LocalDateTime currentDateTime = LocalDateTime.now();
        System.out.println("当前日期时间：" + currentDateTime); // 输出示例：2026-03-08T15:30:45.123

        // 4. 获取带时区的当前日期时间（推荐，避免时区问题）
        ZonedDateTime zonedDateTime = ZonedDateTime.now();
        System.out.println("带时区的当前日期时间：" + zonedDateTime); // 输出示例：2026-03-08T15:30:45.123+08:00[Asia/Shanghai]

        // 5. 格式化日期时间（自定义格式）
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String formattedDateTime = currentDateTime.format(formatter);
        System.out.println("格式化后的日期时间：" + formattedDateTime); // 输出示例：2026-03-08 15:30:45
    }
}
```

#### 2\. 关键类说明

表格

| 类名 | 作用 | 示例输出 |
| --- | --- | --- |
| `LocalDate` | 本地日期（年月日） | 2026-03-08 |
| `LocalTime` | 本地时间（时分秒 + 纳秒） | 15:30:45.123 |
| `LocalDateTime` | 本地日期时间（年月日时分秒） | 2026-03-08T15:30:45.123 |
| `ZonedDateTime` | 带时区的日期时间 | 2026-03-08T15:30:45.123+08:00\[Asia/Shanghai\] |
| `DateTimeFormatter` | 日期时间格式化 / 解析工具 | 自定义格式（如 yyyy-MM-dd HH:mm:ss） |

#### 3\. 获取指定日期时间

java

```java
// 获取指定日期（2026年3月8日）
LocalDate specifiedDate = LocalDate.of(2026, 3, 8);
// 获取指定时间（15点30分45秒）
LocalTime specifiedTime = LocalTime.of(15, 30, 45);
// 获取指定日期时间（2026年3月8日 15:30:45）
LocalDateTime specifiedDateTime = LocalDateTime.of(2026, 3, 8, 15, 30, 45);

System.out.println("指定日期：" + specifiedDate); // 2026-03-08
System.out.println("指定时间：" + specifiedTime); // 15:30:45
System.out.println("指定日期时间：" + specifiedDateTime); // 2026-03-08T15:30:45
```

### 二、传统方式（JDK 8 之前，不推荐）

仅作兼容旧代码参考，缺点是线程不安全、API 设计混乱：

java

```java
import java.util.Date;
import java.text.SimpleDateFormat;

public class OldDateTimeDemo {
    public static void main(String[] args) {
        // 1. 获取当前日期时间
        Date currentDate = new Date();
        System.out.println("原始Date：" + currentDate); // 输出示例：Sun Mar 08 15:30:45 CST 2026

        // 2. 格式化Date
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String formattedDate = sdf.format(currentDate);
        System.out.println("格式化后的Date：" + formattedDate); // 输出示例：2026-03-08 15:30:45
    }
}
```

### 三、核心注意事项

1. `DateTimeFormatter` 是线程安全的，可全局复用； `SimpleDateFormat` 是非线程安全的，多线程环境下需注意（或使用 `ThreadLocal` ）。
2. 如果涉及跨时区业务（如国际项目），优先使用 `ZonedDateTime` 而非 `LocalDateTime` 。
3. 自定义格式化模板时，注意区分大小写：
	- `yyyy` ：4 位年， `MM` ：2 位月（01-12）， `dd` ：2 位日（01-31）
	- `HH` ：24 小时制（00-23）， `hh` ：12 小时制（01-12）， `mm` ：分， `ss` ：秒

### 总结

1. **推荐使用 JDK 8+ 的 `java.time` 包** （ `LocalDate` / `LocalTime` / `LocalDateTime` ），线程安全且 API 更清晰。
2. 格式化日期时间优先用 `DateTimeFormatter` ，避免传统的 `SimpleDateFormat` 线程安全问题。
3. 如需处理时区，使用 `ZonedDateTime` 而非无时区的 `LocalDateTime` 。

如何在 Java 中获取指定日期时间？

如何在 Java 中进行日期时间的计算？

如何在 Java 中进行日期时间的格式化和解析？
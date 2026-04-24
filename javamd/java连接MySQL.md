Java连接MySQL

### Java 连接 MySQL 完整教程

我会用最简单易懂的方式，带你完成 Java 连接 MySQL 的全过程，包含核心代码、环境准备和常见问题解决。

### 一、环境准备

#### 1\. 下载 MySQL 驱动包

Java 连接 MySQL 需要用到官方驱动 `mysql-connector-java` ，推荐使用 Maven 依赖（最便捷）：

xml

```xml
<!-- Maven 依赖（推荐 MySQL 8.x 版本） -->
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.33</version>
    <scope>runtime</scope>
</dependency>
```

如果不用 Maven，可手动下载 JAR 包并添加到项目依赖：

- 下载地址： [https://mvnrepository.com/artifact/mysql/mysql-connector-java](https://mvnrepository.com/artifact/mysql/mysql-connector-java)

#### 2\. 关键版本说明

表格

| MySQL 版本 | 驱动版本 | 驱动类名 | URL 前缀 |
| --- | --- | --- | --- |
| MySQL 8.x | 8.x | com.mysql.cj.jdbc.Driver | jdbc:mysql://... |
| MySQL 5.x | 5.x | com.mysql.jdbc.Driver | jdbc:mysql://... |

### 二、完整连接代码（MySQL 8.x）

以下是可直接运行的代码，包含连接、查询、关闭资源的完整流程：

java

```java
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class MySQLConnection {
    // 数据库连接信息（需替换为你的实际配置）
    private static final String URL = "jdbc:mysql://localhost:3306/你的数据库名?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String USER = "root"; // 你的 MySQL 用户名
    private static final String PASSWORD = "你的 MySQL 密码"; // 你的 MySQL 密码

    public static void main(String[] args) {
        // 声明连接、语句、结果集对象（需手动关闭）
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            // 1. 加载驱动（MySQL 8.x 可省略，自动加载）
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 2. 获取数据库连接
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("数据库连接成功！");

            // 3. 创建 Statement 对象，执行 SQL
            stmt = conn.createStatement();
            String sql = "SELECT * FROM 你的表名"; // 替换为你的表名
            rs = stmt.executeQuery(sql);

            // 4. 处理查询结果
            while (rs.next()) {
                // 根据字段名获取值（替换为你的字段）
                int id = rs.getInt("id");
                String name = rs.getString("name");
                System.out.println("id: " + id + ", name: " + name);
            }

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("数据库连接失败！");
        } finally {
            // 5. 关闭资源（逆序关闭：ResultSet → Statement → Connection）
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
```

### 三、代码关键说明

1. **URL 参数解析**
	plaintext
	```
	jdbc:mysql://localhost:3306/数据库名?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
	```
	- `localhost:3306` ：MySQL 服务器地址和端口（默认 3306）
	- `useSSL=false` ：关闭 SSL 连接（开发环境建议关闭）
	- `serverTimezone=UTC` ：设置时区（解决 MySQL 8.x 时区报错）
	- `allowPublicKeyRetrieval=true` ：允许公钥检索（解决连接权限问题）
2. **核心步骤**
	- 加载驱动： `Class.forName("com.mysql.cj.jdbc.Driver")` （MySQL 8.x 可省略）
	- 获取连接： `DriverManager.getConnection(URL, USER, PASSWORD)`
	- 执行 SQL： `Statement.executeQuery(sql)` （查询）/ `executeUpdate(sql)` （增删改）
	- 关闭资源：必须在 `finally` 中关闭，避免资源泄漏
3. **异常处理**
	- 捕获 `Exception` 是为了简化示例，实际开发建议捕获具体异常（如 `SQLException` ）

### 四、常见问题解决

1. **时区报错** ：添加 `serverTimezone=UTC` 或 `serverTimezone=Asia/Shanghai`
2. **驱动类找不到** ：检查驱动包是否添加到项目依赖
3. **连接拒绝** ：确认 MySQL 服务已启动，地址 / 端口 / 用户名 / 密码正确
4. **权限不足** ：给 MySQL 用户授权（如 `GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '密码';`）

### 总结

1. Java 连接 MySQL 核心依赖 `mysql-connector-java` 驱动，MySQL 8.x 和 5.x 驱动类名有差异，需注意匹配。
2. 连接核心步骤：加载驱动 → 获取连接 → 执行 SQL → 处理结果 → 关闭资源，其中关闭资源必须放在 `finally` 中。
3. URL 参数需包含时区、SSL 等配置，避免常见连接报错。

如果需要更优雅的写法（如使用 `PreparedStatement` 防止 SQL 注入、数据库连接池），可以告诉我，我会补充对应的代码示例。

如何在 Java 中执行增删改操作？

如何在 Java 中处理 MySQL 连接异常？

如何在 Java 中使用 PreparedStatement 进行数据库操作？
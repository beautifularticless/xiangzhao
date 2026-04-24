Java创建Mysql数据库

在 Java 中创建 MySQL 数据库，核心思路是：通过 JDBC 连接 MySQL 服务器（注意不是连接某个具体数据库），然后执行 `CREATE DATABASE` SQL 语句。下面我会提供完整的可运行代码，并详细解释每一步。

### 前置条件

1. 确保 MySQL 服务已启动，且你有创建数据库的权限（如 root 用户）。
2. 项目中引入 MySQL 的 JDBC 驱动（以 Maven 为例）：

xml

```xml
<!-- pom.xml 中添加依赖 -->
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.33</version> <!-- 推荐使用最新稳定版 -->
</dependency>
```

### 完整代码示例

java

```java
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Java 通过 JDBC 创建 MySQL 数据库
 */
public class CreateMysqlDatabase {
    // MySQL 连接配置（根据你的实际情况修改）
    private static final String MYSQL_URL = "jdbc:mysql://localhost:3306/?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String MYSQL_USER = "root"; // 你的 MySQL 用户名
    private static final String MYSQL_PASSWORD = "123456"; // 你的 MySQL 密码
    private static final String DATABASE_NAME = "my_new_database"; // 要创建的数据库名

    public static void main(String[] args) {
        // 1. 注册驱动（MySQL 8.0+ 可省略，Driver 类会自动注册）
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("驱动注册成功！");
        } catch (ClassNotFoundException e) {
            System.err.println("驱动注册失败：" + e.getMessage());
            return;
        }

        // 2. 建立连接并执行创建数据库语句
        try (
            // 连接 MySQL 服务器（不指定具体数据库）
            Connection conn = DriverManager.getConnection(MYSQL_URL, MYSQL_USER, MYSQL_PASSWORD);
            // 创建 Statement 对象执行 SQL
            Statement stmt = conn.createStatement()
        ) {
            // 3. 执行创建数据库的 SQL（IF NOT EXISTS 避免重复创建报错）
            String createDbSql = "CREATE DATABASE IF NOT EXISTS " + DATABASE_NAME;
            int result = stmt.executeUpdate(createDbSql);
            
            // 4. 验证结果
            if (result == 0) {
                System.out.println("数据库 '" + DATABASE_NAME + "' 创建成功（或已存在）！");
            } else {
                System.out.println("数据库 '" + DATABASE_NAME + "' 创建成功！");
            }

        } catch (SQLException e) {
            System.err.println("创建数据库失败：" + e.getMessage());
            e.printStackTrace();
        }
    }
}
```

### 代码关键部分解释

1. **连接 URL 说明** ：
	- `jdbc:mysql://localhost:3306/?`：连接本地 3306 端口的 MySQL 服务器，`?` 后不指定具体数据库（这是创建数据库的关键）。
	- `useSSL=false` ：关闭 SSL 连接（本地测试常用）。
	- `serverTimezone=UTC` ：指定时区（解决 MySQL 8.0+ 时区报错问题）。
	- `allowPublicKeyRetrieval=true` ：允许公钥检索（解决连接权限问题）。
2. **核心 SQL 语句** ：
	- `CREATE DATABASE IF NOT EXISTS 数据库名` ： `IF NOT EXISTS` 是关键，避免数据库已存在时抛出异常。
3. **资源关闭** ：
	- 使用 `try-with-resources` 语法，自动关闭 `Connection` 和 `Statement` ，无需手动调用 `close()` ，符合 Java 最佳实践。

### 常见问题及解决

1. **报错：Access denied for user 'root'@' [localhost](https://localhost/) ' (using password: YES)** ：
	- 原因：用户名 / 密码错误，或 root 用户无远程 / 本地访问权限。
	- 解决：核对密码，或在 MySQL 中执行授权语句：
		sql
		```sql
		ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '你的密码';
		FLUSH PRIVILEGES;
		```
2. **报错：No suitable driver found for jdbc:mysql:// [localhost:3306/](https://localhost:3306/)** ：
	- 原因：未引入 MySQL 驱动，或驱动版本与 MySQL 版本不兼容。
	- 解决：确认 pom.xml 中依赖已引入，或手动添加驱动 jar 包。

### 总结

1. 创建 MySQL 数据库的核心是：JDBC 连接 MySQL 服务器（不指定具体数据库），执行 `CREATE DATABASE` 语句。
2. 关键配置：URL 不指定数据库、添加 `IF NOT EXISTS` 避免重复创建、配置正确的时区和驱动。
3. 最佳实践：使用 `try-with-resources` 自动关闭资源，避免连接泄漏。

如何在 Java 中连接已存在的 MySQL 数据库？

如何在 Java 中删除 MySQL 数据库？

如何在 Java 中向 MySQL 数据库表中插入数据？
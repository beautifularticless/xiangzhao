Java 修改MySQL root 密码

在 Java 中修改 MySQL 的 root 密码，核心思路是通过 JDBC 连接 MySQL 数据库，然后执行修改密码的 SQL 语句。以下是完整、可直接运行的实现方案，同时会说明不同 MySQL 版本的语法差异。

### 前置条件

1. 确保项目中引入了 MySQL 的 JDBC 驱动（以 MySQL 8.0 为例）：
	xml
	```xml
	<!-- Maven 依赖 -->
	<dependency>
	    <groupId>mysql</groupId>
	    <artifactId>mysql-connector-java</artifactId>
	    <version>8.0.33</version>
	    <scope>runtime</scope>
	</dependency>
	```
2. 确保你能使用旧密码连接 MySQL（否则需要先通过 MySQL 命令行重置密码）。
3. MySQL 8.0+ 与 5.x 版本的密码修改语法不同，代码中会兼容两种情况。

### 完整 Java 代码实现

java

```java
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class ModifyMysqlRootPassword {
    // 数据库连接配置
    private static final String OLD_PASSWORD = "你的旧root密码";
    private static final String NEW_PASSWORD = "你的新root密码";
    // MySQL 8.0+ 驱动类名（5.x 是 com.mysql.jdbc.Driver）
    private static final String DRIVER_CLASS = "com.mysql.cj.jdbc.Driver";
    // 连接URL（8.0+ 需要指定 serverTimezone，5.x 可省略）
    private static final String URL = "jdbc:mysql://localhost:3306/mysql?serverTimezone=UTC&allowPublicKeyRetrieval=true&useSSL=false";
    private static final String USER = "root";

    public static void main(String[] args) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // 1. 加载驱动
            Class.forName(DRIVER_CLASS);
            // 2. 连接数据库（使用旧密码）
            conn = DriverManager.getConnection(URL, USER, OLD_PASSWORD);
            System.out.println("成功连接 MySQL 数据库");

            // 3. 执行修改密码的 SQL（兼容 8.0+ 和 5.x）
            String updateSql;
            // MySQL 8.0+ 使用 ALTER USER 语法（推荐）
            updateSql = "ALTER USER 'root'@'localhost' IDENTIFIED BY ?";
            // 如果是 MySQL 5.x，替换为：
            // updateSql = "SET PASSWORD FOR 'root'@'localhost' = PASSWORD(?)";

            pstmt = conn.prepareStatement(updateSql);
            pstmt.setString(1, NEW_PASSWORD); // 设置新密码
            int affectedRows = pstmt.executeUpdate();

            // 4. 刷新权限（生效修改）
            String flushSql = "FLUSH PRIVILEGES";
            pstmt = conn.prepareStatement(flushSql);
            pstmt.executeUpdate();

            System.out.println("root 密码修改成功！影响行数：" + affectedRows);

        } catch (ClassNotFoundException e) {
            System.err.println("加载 MySQL 驱动失败：" + e.getMessage());
        } catch (SQLException e) {
            System.err.println("数据库操作异常：" + e.getMessage());
            // 常见异常：1045（密码错误）、1133（用户不存在）、1290（MySQL 配置限制）
        } finally {
            // 5. 关闭资源
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.err.println("关闭资源失败：" + e.getMessage());
            }
        }
    }
}
```

### 关键代码解释

1. **驱动加载** ：
	- MySQL 8.0+ 驱动类是 `com.mysql.cj.jdbc.Driver` ，5.x 是 `com.mysql.jdbc.Driver` 。
	- JDBC 4.0+ 后可省略 `Class.forName()` ，驱动会自动加载，但显式加载更稳妥。
2. **连接 URL 参数** ：
	- `serverTimezone=UTC` ：解决 8.0+ 时区报错问题；
	- `allowPublicKeyRetrieval=true` ：解决本地连接时的公钥验证问题；
	- `useSSL=false` ：关闭 SSL 连接（开发环境常用）。
3. **修改密码的 SQL** ：
	- MySQL 8.0+： `ALTER USER 'root'@'localhost' IDENTIFIED BY '新密码'` （推荐，符合官方规范）；
	- MySQL 5.x： `SET PASSWORD FOR 'root'@'localhost' = PASSWORD('新密码')` （5.x 特有语法）；
	- `'root'@'localhost'` ：表示本地的 root 用户，如果是远程连接，可替换为 `'root'@'%'` （% 表示任意主机）。
4. **FLUSH PRIVILEGES** ：刷新权限表，让密码修改立即生效，缺一不可。

### 验证密码是否修改成功

修改后可通过以下代码验证：

java

```java
// 验证新密码连接
try {
    Connection testConn = DriverManager.getConnection(URL, USER, NEW_PASSWORD);
    System.out.println("新密码连接成功，修改生效！");
    testConn.close();
} catch (SQLException e) {
    System.err.println("新密码连接失败：" + e.getMessage());
}
```

### 总结

1. Java 修改 MySQL root 密码的核心是通过 JDBC 执行 `ALTER USER` （8.0+）或 `SET PASSWORD` （5.x）语句，且必须执行 `FLUSH PRIVILEGES` 刷新权限；
2. 关键注意 MySQL 版本差异：8.0+ 驱动类、URL 参数、密码修改语法均与 5.x 不同；
3. 操作前确保旧密码正确，且 root 用户有足够权限（默认 root 拥有最高权限）。

如何在 Java 中使用 JDBC 连接 MySQL 数据库？

除了 Java，还有哪些语言可以修改 MySQL root 密码？

如何在 Java 中使用 JDBC 连接 MySQL 数据库？
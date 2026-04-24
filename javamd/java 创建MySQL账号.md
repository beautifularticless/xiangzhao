Java 创建MySQL账号

在 Java 中创建 MySQL 账号，本质是通过 JDBC 执行 MySQL 的账号创建语句（ `CREATE USER` 、 `GRANT` 等）。以下是完整、可直接运行的实现方案，包含环境准备、代码编写和关键说明。

### 一、前置条件

1. 确保本地 / 远程有 MySQL 服务，且能访问（需有创建账号权限的 root 或管理员账号）。
2. 项目中引入 MySQL JDBC 驱动（以 Maven 为例）：

xml

```xml
<!-- pom.xml 中添加依赖 -->
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.33</version> <!-- 适配你的 MySQL 版本，8.x 推荐 -->
</dependency>
```

### 二、完整代码实现

java

```java
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 * Java 通过 JDBC 创建 MySQL 账号
 */
public class CreateMySQLUser {
    // MySQL 连接配置（替换为你的实际信息）
    private static final String DB_URL = "jdbc:mysql://localhost:3306/mysql?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String ROOT_USER = "root"; // 有创建账号权限的管理员账号
    private static final String ROOT_PASSWORD = "你的root密码"; // 管理员密码

    public static void main(String[] args) {
        // 要创建的新账号信息
        String newUser = "test_user";       // 新账号名
        String newPassword = "test123456";  // 新账号密码
        String host = "localhost";          // 允许访问的主机（% 表示任意主机）
        String database = "test_db";        // 授权访问的数据库（*.* 表示所有数据库）

        try (Connection conn = getConnection()) {
            // 1. 创建账号（如果已存在则忽略，避免报错）
            createUser(conn, newUser, host, newPassword);
            // 2. 给账号授权（核心：指定权限和数据库）
            grantPrivileges(conn, newUser, host, database);
            // 3. 刷新权限（使授权生效）
            flushPrivileges(conn);

            System.out.println("MySQL 账号创建并授权成功！");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * 获取 MySQL 数据库连接
     */
    private static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, ROOT_USER, ROOT_PASSWORD);
    }

    /**
     * 创建 MySQL 账号
     * @param conn 数据库连接
     * @param user 账号名
     * @param host 允许访问的主机（localhost/192.168.%.%/%）
     * @param password 密码
     */
    private static void createUser(Connection conn, String user, String host, String password) throws SQLException {
        String createSql = "CREATE USER IF NOT EXISTS ?@? IDENTIFIED BY ?";
        try (PreparedStatement pstmt = conn.prepareStatement(createSql)) {
            pstmt.setString(1, user);   // 第一个?：账号名
            pstmt.setString(2, host);   // 第二个?：允许访问的主机
            pstmt.setString(3, password); // 第三个?：密码
            pstmt.executeUpdate();
        }
    }

    /**
     * 给账号授权
     * @param conn 数据库连接
     * @param user 账号名
     * @param host 主机
     * @param db 授权的数据库（如 test_db.* 表示test_db下所有表）
     */
    private static void grantPrivileges(Connection conn, String user, String host, String db) throws SQLException {
        // 授权权限：SELECT/INSERT/UPDATE/DELETE（可根据需求调整，如 ALL PRIVILEGES 表示所有权限）
        String grantSql = "GRANT SELECT, INSERT, UPDATE, DELETE ON " + db + ".* TO ?@?";
        try (PreparedStatement pstmt = conn.prepareStatement(grantSql)) {
            pstmt.setString(1, user);
            pstmt.setString(2, host);
            pstmt.executeUpdate();
        }
    }

    /**
     * 刷新权限（MySQL 必须执行此步骤才能让授权生效）
     */
    private static void flushPrivileges(Connection conn) throws SQLException {
        String flushSql = "FLUSH PRIVILEGES";
        try (PreparedStatement pstmt = conn.prepareStatement(flushSql)) {
            pstmt.executeUpdate();
        }
    }
}
```

### 三、关键说明

1. **核心 SQL 语句** ：
	- `CREATE USER IF NOT EXISTS 账号@主机 IDENTIFIED BY 密码` ：创建账号（ `IF NOT EXISTS` 避免重复创建报错）。
	- `GRANT 权限 ON 数据库.表 TO 账号@主机` ：给账号授权（常用权限： `SELECT` / `INSERT` / `UPDATE` / `DELETE` / `ALL PRIVILEGES` ）。
	- `FLUSH PRIVILEGES` ：刷新权限，必须执行否则授权不生效。
2. **主机配置** ：
	- `localhost` ：仅允许本地访问。
	- `%` ：允许任意主机访问（生产环境慎用，建议指定具体 IP / 网段）。
	- `192.168.%.%` ：允许指定网段访问。
3. **安全注意事项** ：
	- 避免硬编码密码：实际开发中建议通过配置文件（如 application.properties）存储账号密码，而非写死在代码中。
	- 最小权限原则：不要给普通账号授予 `ALL PRIVILEGES` ，仅授予业务所需的最小权限。
	- 驱动适配：MySQL 8.0+ 驱动需指定 `serverTimezone` ，且默认认证方式为 `caching_sha2_password` ，若报错可修改账号认证方式：
		sql
		```sql
		ALTER USER 'test_user'@'localhost' IDENTIFIED WITH mysql_native_password BY 'test123456';
		```
4. **测试验证** ：运行代码后，登录 MySQL 执行以下命令验证：
	sql
	```sql
	-- 查看所有账号
	SELECT user, host FROM mysql.user;
	-- 查看账号权限
	SHOW GRANTS FOR 'test_user'@'localhost';
	```

### 总结

1. Java 创建 MySQL 账号的核心是通过 JDBC 执行 `CREATE USER` 、 `GRANT` 、 `FLUSH PRIVILEGES` 三条关键 SQL。
2. 必须使用有管理员权限的账号（如 root）连接 MySQL，且执行授权后需刷新权限才能生效。
3. 生产环境需注意账号权限最小化、密码不硬编码、限制访问主机，保障数据库安全。

如何在 Java 中删除 MySQL 账号？

如何在 Java 中修改 MySQL 账号的密码？

如何在 Java 中查询 MySQL 账号的权限？
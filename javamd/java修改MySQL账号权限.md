Java修改MySQL账号权限

在 Java 中修改 MySQL 账号权限，核心思路是通过 JDBC 执行 MySQL 的权限管理 SQL 语句（如 `GRANT` 、 `REVOKE` 、 `FLUSH PRIVILEGES` ）。下面我会提供完整的可运行代码，并详细解释关键步骤。

### 前置条件

1. 确保项目中引入 MySQL JDBC 驱动（以 Maven 为例）：

xml

```xml
<!-- MySQL 8.0+ 驱动 -->
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.33</version>
    <scope>runtime</scope>
</dependency>
```

1. 拥有足够权限的 MySQL 账号（如 root），用于执行权限修改操作。

### 完整代码示例

java

```java
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 * Java 修改 MySQL 账号权限工具类
 */
public class MysqlPermissionManager {
    // MySQL 连接配置（根据实际情况修改）
    private static final String DB_URL = "jdbc:mysql://localhost:3306/mysql?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String DB_USER = "root"; // 高权限账号
    private static final String DB_PASSWORD = "your_root_password"; // 替换为实际密码

    /**
     * 获取数据库连接
     */
    private static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    /**
     * 给指定 MySQL 账号授权
     * @param targetUser 目标账号（如 "test_user"）
     * @param targetHost 目标主机（如 "localhost" 或 "%" 表示所有主机）
     * @param privileges 权限（如 "SELECT,INSERT" 或 "ALL PRIVILEGES"）
     * @param database 数据库（如 "test_db" 或 "*" 表示所有数据库）
     * @param table 表（如 "user" 或 "*" 表示所有表）
     */
    public static void grantPermission(String targetUser, String targetHost,
                                       String privileges, String database, String table) {
        String grantSql = String.format(
            "GRANT %s ON %s.%s TO '%s'@'%s'",
            privileges, database, table, targetUser, targetHost
        );
        // 执行授权后需要刷新权限
        String flushSql = "FLUSH PRIVILEGES";

        try (Connection conn = getConnection();
             PreparedStatement grantStmt = conn.prepareStatement(grantSql);
             PreparedStatement flushStmt = conn.prepareStatement(flushSql)) {

            // 执行授权语句
            grantStmt.executeUpdate();
            // 刷新权限（必须执行，否则权限不生效）
            flushStmt.executeUpdate();
            System.out.printf("成功给账号 %s@%s 授予 %s 权限（%s.%s）%n",
                targetUser, targetHost, privileges, database, table);

        } catch (SQLException e) {
            System.err.println("授权失败：" + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * 撤销指定 MySQL 账号的权限
     * @param targetUser 目标账号
     * @param targetHost 目标主机
     * @param privileges 要撤销的权限
     * @param database 数据库
     * @param table 表
     */
    public static void revokePermission(String targetUser, String targetHost,
                                        String privileges, String database, String table) {
        String revokeSql = String.format(
            "REVOKE %s ON %s.%s FROM '%s'@'%s'",
            privileges, database, table, targetUser, targetHost
        );
        String flushSql = "FLUSH PRIVILEGES";

        try (Connection conn = getConnection();
             PreparedStatement revokeStmt = conn.prepareStatement(revokeSql);
             PreparedStatement flushStmt = conn.prepareStatement(flushSql)) {

            revokeStmt.executeUpdate();
            flushStmt.executeUpdate();
            System.out.printf("成功撤销账号 %s@%s 的 %s 权限（%s.%s）%n",
                targetUser, targetHost, privileges, database, table);

        } catch (SQLException e) {
            System.err.println("撤销权限失败：" + e.getMessage());
            e.printStackTrace();
        }
    }

    // 测试方法
    public static void main(String[] args) {
        // 示例1：给 test_user@localhost 授予 test_db 库所有表的 SELECT 和 INSERT 权限
        grantPermission("test_user", "localhost", "SELECT,INSERT", "test_db", "*");

        // 示例2：撤销 test_user@localhost 的 INSERT 权限（test_db 库所有表）
        // revokePermission("test_user", "localhost", "INSERT", "test_db", "*");

        // 示例3：给 test_user@% 授予所有数据库所有表的全部权限（谨慎使用）
        // grantPermission("test_user", "%", "ALL PRIVILEGES", "*", "*");
    }
}
```

### 关键代码解释

1. **连接配置** ：
	- `DB_URL` 中 `mysql` 库是 MySQL 存储权限信息的系统库，必须指定； `allowPublicKeyRetrieval=true` 解决 MySQL 8.0 以上的连接权限问题。
	- 替换 `DB_USER` 和 `DB_PASSWORD` 为你的高权限 MySQL 账号密码。
2. **授权方法 `grantPermission`** ：
	- 核心 SQL： `GRANT 权限 ON 数据库.表 TO '账号'@'主机'` ，例如 `GRANT SELECT ON test_db.* TO 'test_user'@'localhost'` 。
	- `FLUSH PRIVILEGES` ：必须执行，否则 MySQL 不会立即加载新的权限配置。
3. **撤销权限方法 `revokePermission`** ：
	- 核心 SQL： `REVOKE 权限 ON 数据库.表 FROM '账号'@'主机'` ，逻辑与授权相反。
4. **资源管理** ：
	- 使用 `try-with-resources` 自动关闭 `Connection` 、 `PreparedStatement` ，避免资源泄漏。

### 常见权限说明

表格

| 权限值 | 说明 |
| --- | --- |
| `ALL PRIVILEGES` | 所有权限（谨慎授予） |
| `SELECT` | 查询权限 |
| `INSERT` | 插入权限 |
| `UPDATE` | 更新权限 |
| `DELETE` | 删除权限 |
| `CREATE/DROP` | 创建 / 删除库 / 表权限 |
| `ALTER` | 修改表结构权限 |

### 注意事项

1. 主机范围： `localhost` 仅允许本地连接， `%` 允许任意主机连接（生产环境需谨慎）。
2. 权限粒度：建议按最小权限原则授予（如仅授予业务库的 SELECT/INSERT，而非 ALL PRIVILEGES）。
3. 异常处理：代码中捕获了 `SQLException` ，可根据业务需求扩展（如记录日志、重试）。

### 总结

1. Java 修改 MySQL 权限的核心是通过 JDBC 执行 `GRANT` / `REVOKE` 语句，且必须执行 `FLUSH PRIVILEGES` 刷新权限。
2. 需使用高权限 MySQL 账号（如 root）执行权限操作，遵循最小权限原则。
3. 代码中通过 `try-with-resources` 保证 JDBC 资源自动释放，避免内存泄漏。

如何在 Java 中撤销 MySQL 账号的权限？

除了 Java，还有哪些语言可以修改 MySQL 账号权限？

如何在 Java 中查询 MySQL 账号的权限？
java生成json

在 Java 中生成 JSON 最常用、最便捷的方式是使用第三方库，其中 **Jackson** 和 **Fastjson2** （阿里出品）是业界主流选择。下面我会分别给出这两种库的完整使用示例，你可以根据需求选择。

### 一、使用 Jackson 生成 JSON（推荐，生态更完善）

Jackson 是 Spring 生态默认的 JSON 处理库，稳定性和兼容性更好。

#### 1\. 先添加依赖（Maven）

xml

```xml
<!-- Jackson 核心依赖 -->
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
    <version>2.16.1</version>
</dependency>
```

#### 2\. 完整代码示例

java

```java
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

// 定义一个实体类（也可以直接用 Map 生成 JSON）
class User {
    private String name;
    private int age;
    private String email;

    // 必须有无参构造器（Jackson 反射需要）
    public User() {}

    // 有参构造器（方便初始化）
    public User(String name, int age, String email) {
        this.name = name;
        this.age = age;
        this.email = email;
    }

    // Getter 和 Setter（Jackson 需要通过 Getter 读取属性）
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}

public class JacksonJsonGenerator {
    public static void main(String[] args) {
        // 1. 创建 ObjectMapper 核心对象（全局单例即可，无需重复创建）
        ObjectMapper objectMapper = new ObjectMapper();

        try {
            // 方式1：将 Java 对象转为 JSON 字符串
            User user = new User("张三", 25, "zhangsan@example.com");
            String userJson = objectMapper.writeValueAsString(user);
            System.out.println("对象转 JSON：" + userJson);
            // 输出：{"name":"张三","age":25,"email":"zhangsan@example.com"}

            // 方式2：将 Map 转为 JSON 字符串（无需定义实体类）
            java.util.Map<String, Object> map = new java.util.HashMap<>();
            map.put("code", 200);
            map.put("msg", "成功");
            map.put("data", user); // 嵌套对象
            String mapJson = objectMapper.writerWithDefaultPrettyPrinter().writeValueAsString(map);
            System.out.println("\nMap 转格式化后的 JSON：\n" + mapJson);
            // 输出格式化后的 JSON，更易读

        } catch (JsonProcessingException e) {
            e.printStackTrace(); // 捕获 JSON 序列化异常
        }
    }
}
```

### 二、使用 Fastjson2 生成 JSON（轻量、性能优）

Fastjson2 是阿里对 Fastjson 的重构版本，解决了旧版本的安全问题，性能更优。

#### 1\. 添加依赖（Maven）

xml

```xml
<dependency>
    <groupId>com.alibaba.fastjson2</groupId>
    <artifactId>fastjson2</artifactId>
    <version>2.0.48</version>
</dependency>
```

#### 2\. 完整代码示例

java

```java
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;

public class Fastjson2Generator {
    public static void main(String[] args) {
        // 方式1：实体类转 JSON
        User user = new User("李四", 30, "lisi@example.com");
        String userJson = JSON.toJSONString(user);
        System.out.println("实体类转 JSON：" + userJson);
        // 输出：{"age":30,"email":"lisi@example.com","name":"李四"}

        // 方式2：手动构建 JSONObject 生成 JSON（灵活）
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("code", 200);
        jsonObject.put("msg", "操作成功");
        jsonObject.put("data", user); // 嵌套对象

        // 格式化输出 JSON
        String prettyJson = JSON.toJSONString(jsonObject, true);
        System.out.println("\n手动构建的格式化 JSON：\n" + prettyJson);
    }
}

// 复用上面定义的 User 类即可（无需额外修改）
```

### 关键说明

1. **实体类要求** ：
	- Jackson 需要实体类有 **无参构造器** 和 **Getter 方法** （否则无法序列化）；
	- Fastjson2 对构造器无强制要求，但建议保留 Getter 以保证兼容性。
2. **格式化输出** ：
	- Jackson：使用 `writerWithDefaultPrettyPrinter()` 方法；
	- Fastjson2： `JSON.toJSONString(obj, true)` 第二个参数为 `true` 即格式化。
3. **空值处理** ：默认情况下，空值属性会被忽略，如需保留可通过配置调整（比如 Jackson 配置 `objectMapper.setSerializationInclusion(JsonInclude.Include.ALWAYS)` ）。

### 总结

1. **Jackson** ：适合 Spring 项目，生态完善、稳定性高，优先推荐；
2. **Fastjson2** ：轻量、性能好，手动构建 JSON 更灵活，适合非 Spring 项目；
3. 核心操作：无论是实体类还是 Map/JSONObject，最终都是通过核心工具类（ `ObjectMapper` / `JSON` ）的 `toJSONString` （或 `writeValueAsString` ）方法生成 JSON 字符串。

如何使用 Jackson 解析 JSON 字符串？

Fastjson2 生成 JSON 的具体步骤是什么？

除了 Jackson 和 Fastjson2，还有哪些常用的 Java JSON 库？
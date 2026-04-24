java 解析json

在 Java 中解析 JSON 是非常常见的开发需求，最主流、易用且符合最佳实践的库是 **Jackson** 和 **Gson** （Google 出品）。下面我会以更常用的 Jackson 为例，带你一步步实现 JSON 解析，同时也会补充 Gson 的用法作为参考。

### 一、前置准备（以 Jackson 为例）

首先需要在项目中引入 Jackson 依赖：

#### Maven 依赖

xml

```xml
<dependencies>
    <!-- Jackson 核心包 -->
    <dependency>
        <groupId>com.fasterxml.jackson.core</groupId>
        <artifactId>jackson-databind</artifactId>
        <version>2.15.2</version> <!-- 建议使用最新稳定版 -->
    </dependency>
</dependencies>
```

#### Gradle 依赖

groovy

```groovy
dependencies {
    implementation 'com.fasterxml.jackson.core:jackson-databind:2.15.2'
}
```

### 二、Jackson 解析 JSON 的核心场景

#### 场景 1：解析 JSON 字符串到自定义实体类（最常用）

假设我们有如下 JSON 字符串，对应一个用户信息：

json

```json
{
  "id": 1,
  "name": "张三",
  "age": 25,
  "isStudent": false,
  "hobbies": ["篮球", "编程"]
}
```

**步骤 1：创建对应的实体类**

java

```java
import java.util.List;

// 实体类字段名要和 JSON 键名一致（或通过注解映射）
public class User {
    private Integer id;
    private String name;
    private Integer age;
    private Boolean isStudent;
    private List<String> hobbies;

    // 必须提供无参构造器（Jackson 反射创建对象需要）
    public User() {}

    // Getter 和 Setter（必须，Jackson 通过反射赋值）
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public Integer getAge() { return age; }
    public void setAge(Integer age) { this.age = age; }
    public Boolean getIsStudent() { return isStudent; }
    public void setIsStudent(Boolean isStudent) { this.isStudent = isStudent; }
    public List<String> getHobbies() { return hobbies; }
    public void setHobbies(List<String> hobbies) { this.hobbies = hobbies; }

    // 重写 toString 方便打印结果
    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", age=" + age +
                ", isStudent=" + isStudent +
                ", hobbies=" + hobbies +
                '}';
    }
}
```

**步骤 2：编写解析代码**

java

```java
import com.fasterxml.jackson.databind.ObjectMapper;

public class JacksonJsonParser {
    public static void main(String[] args) {
        // 1. 定义要解析的 JSON 字符串
        String jsonStr = "{\n" +
                "  \"id\": 1,\n" +
                "  \"name\": \"张三\",\n" +
                "  \"age\": 25,\n" +
                "  \"isStudent\": false,\n" +
                "  \"hobbies\": [\"篮球\", \"编程\"]\n" +
                "}";

        try {
            // 2. 创建 ObjectMapper（Jackson 的核心工具类）
            ObjectMapper objectMapper = new ObjectMapper();

            // 3. 解析 JSON 字符串到 User 对象
            User user = objectMapper.readValue(jsonStr, User.class);

            // 4. 打印结果，验证解析成功
            System.out.println(user);
            // 输出：User{id=1, name='张三', age=25, isStudent=false, hobbies=[篮球, 编程]}

            // 也可以单独获取字段值
            System.out.println("用户名：" + user.getName()); // 输出：用户名：张三
            System.out.println("第一个爱好：" + user.getHobbies().get(0)); // 输出：第一个爱好：篮球
        } catch (Exception e) {
            e.printStackTrace(); // 捕获解析异常（如 JSON 格式错误、字段类型不匹配等）
        }
    }
}
```

#### 场景 2：解析 JSON 到 Map（无需定义实体类）

如果 JSON 结构不固定，或者临时解析，可直接解析到 `Map` ：

java

```java
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.Map;

public class JacksonMapParser {
    public static void main(String[] args) {
        String jsonStr = "{\"id\":1,\"name\":\"张三\",\"age\":25}";

        try {
            ObjectMapper objectMapper = new ObjectMapper();
            // 解析到 Map<String, Object>
            Map<String, Object> userMap = objectMapper.readValue(jsonStr, Map.class);

            // 获取值（注意类型转换）
            Integer id = (Integer) userMap.get("id");
            String name = (String) userMap.get("name");
            System.out.println("id: " + id + ", name: " + name); // 输出：id: 1, name: 张三
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

#### 场景 3：Gson 解析（补充）

如果你想使用 Gson，步骤类似：

1. 引入 Gson 依赖：

xml

```xml
<dependency>
    <groupId>com.google.code.gson</groupId>
    <artifactId>gson</artifactId>
    <version>2.10.1</version>
</dependency>
```

1. 解析代码：

java

```java
import com.google.gson.Gson;

public class GsonParser {
    public static void main(String[] args) {
        String jsonStr = "{\"id\":1,\"name\":\"张三\",\"age\":25}";

        // 1. 创建 Gson 实例
        Gson gson = new Gson();

        // 2. 解析到 User 实体类
        User user = gson.fromJson(jsonStr, User.class);
        System.out.println(user);

        // 解析到 Map
        Map<String, Object> userMap = gson.fromJson(jsonStr, Map.class);
        System.out.println(userMap.get("name"));
    }
}
```

### 三、关键注意事项

1. **字段映射** ：如果 JSON 键名和实体类字段名不一致，可通过注解解决：
	- Jackson： `@JsonProperty("user_name")` （标注在字段上，映射 JSON 的 `user_name` 到该字段）
	- Gson： `@SerializedName("user_name")`
2. **空值 / 默认值** ：Jackson 可通过 `objectMapper.configure(DeserializationFeature.FAIL_ON_NULL_FOR_PRIMITIVES, false)` 避免基本类型（如 int）遇到 null 时报错。
3. **异常处理** ：解析时必须捕获异常（如 `JsonParseException` 、 `JsonMappingException` ），常见原因：JSON 格式错误、字段类型不匹配、缺少无参构造器等。

### 总结

1. Java 解析 JSON 首选 **Jackson** （功能更全）或 Gson（轻量易用），需先引入对应依赖；
2. 解析到自定义实体类是最规范的方式（类型安全），临时解析可使用 Map；
3. 核心注意事项：保证实体类有 **无参构造器** 和 **Getter/Setter** ，处理字段名映射和解析异常。

如何使用 Jackson 解析 JSON 数组？

除了 Jackson 和 Gson，还有哪些常用的 Java JSON 解析库？

如何使用 Gson 解析 JSON 字符串到自定义实体类？
java 获取文件路径

在 Java 中获取文件路径有多种方式，适用于不同场景（如相对路径、绝对路径、项目内资源路径等）。下面我会按常用场景逐一讲解，并提供可直接运行的代码示例。

### 一、基础文件路径获取（File 类）

`java.io.File` 是最基础的文件操作类，可获取文件 / 目录的绝对路径、规范路径等。

#### 代码示例

java

```java
import java.io.File;

public class FilePathDemo {
    public static void main(String[] args) {
        // 1. 构造文件对象（相对路径：相对于项目根目录）
        File file = new File("test.txt");
        
        try {
            // 获取绝对路径（包含完整路径，可能有../等不规范写法）
            String absolutePath = file.getAbsolutePath();
            System.out.println("绝对路径：" + absolutePath);
            
            // 获取规范路径（自动解析../，返回标准化的绝对路径）
            String canonicalPath = file.getCanonicalPath();
            System.out.println("规范路径：" + canonicalPath);
            
            // 获取文件路径（不包含文件名，仅目录）
            String parentPath = file.getParent();
            System.out.println("父目录路径：" + parentPath);
            
            // 判断文件是否存在（避免路径无效）
            if (file.exists()) {
                System.out.println("文件存在，路径有效");
            } else {
                System.out.println("文件不存在，路径无效");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

#### 关键说明

- `getAbsolutePath()` ：无论文件是否存在，都会返回「当前项目目录 + 相对路径」拼接的完整路径（比如 `D:\project\test.txt` ）。
- `getCanonicalPath()` ：会解析路径中的 `../` 、`./` 等，返回操作系统标准化的路径（更推荐使用）。
- 相对路径的基准：在 IDE 中运行时，基准是 **项目根目录** ；打包成 JAR 运行时，基准是 JAR 文件所在目录。

### 二、获取项目内资源文件路径（ClassLoader）

如果文件放在项目的 `resources` 目录（maven/gradle 项目），需要用类加载器（ClassLoader）获取，避免打包后路径失效。

#### 代码示例

java

```java
public class ResourcePathDemo {
    public static void main(String[] args) {
        // 1. 获取 resources 目录下的 test.txt 路径（推荐方式）
        ClassLoader classLoader = ResourcePathDemo.class.getClassLoader();
        // 路径直接写 resources 下的相对路径，无需加 resources/
        String resourcePath = classLoader.getResource("test.txt").getPath();
        
        // 处理中文路径编码问题（URL 编码会把中文转成 %xx 格式，需解码）
        try {
            resourcePath = java.net.URLDecoder.decode(resourcePath, "UTF-8");
            System.out.println("资源文件路径：" + resourcePath);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // 2. 另一种方式：通过 Class 类获取（需注意路径开头）
        String pathByClass = ResourcePathDemo.class.getResource("/test.txt").getPath();
        System.out.println("通过 Class 获取路径：" + pathByClass);
    }
}
```

#### 关键说明

- `ClassLoader.getResource("文件名")` ：路径无需加 `/` ，直接写 `resources` 下的文件名。
- `Class.getResource("/文件名")` ：路径必须以 `/` 开头，代表 `resources` 根目录。
- 中文路径需解码： `URLDecoder.decode(path, "UTF-8")` ，否则中文会变成 `%E4%B8%AD` 这类编码。

### 三、Java NIO 方式（Path/Paths 类）

Java 7+ 推荐使用 NIO 的 `Path` 接口，操作更简洁、功能更丰富。

#### 代码示例

java

```java
import java.nio.file.Path;
import java.nio.file.Paths;

public class NioPathDemo {
    public static void main(String[] args) {
        // 1. 构造 Path 对象
        Path path = Paths.get("test.txt");
        
        // 获取绝对路径
        Path absolutePath = path.toAbsolutePath();
        System.out.println("NIO 绝对路径：" + absolutePath);
        
        // 解析规范路径
        try {
            Path canonicalPath = path.toRealPath(); // 等价于 File 的 getCanonicalPath()
            System.out.println("NIO 规范路径：" + canonicalPath);
        } catch (Exception e) {
            System.out.println("文件不存在，无法获取规范路径");
        }
        
        // 获取文件名/父路径
        System.out.println("文件名：" + path.getFileName());
        System.out.println("父路径：" + path.getParent());
    }
}
```

#### 关键说明

- `Paths.get("路径")` ：替代 `new File()` ，更简洁。
- `toRealPath()` ：会自动解析符号链接、`../` 等，且要求文件必须存在（否则抛异常）。
- NIO 路径操作更灵活，支持路径拼接（ `path.resolve("subdir/test.txt")` ）、路径比较等。

### 四、注意事项

1. 跨平台兼容：Java 路径分隔符用 `/` 即可（Windows/Linux 都支持），避免直接写 `\` （Windows 分隔符）。
2. JAR 包内资源：如果文件打包在 JAR 中， `File` 类无法直接访问（JAR 是压缩包），需用 `getResourceAsStream()` 读取内容，而非获取路径。
3. 空指针防范： `getResource()` 如果找不到文件会返回 `null` ，需先判空再使用。

### 总结

1. 基础文件操作：用 `File` 类的 `getCanonicalPath()` 获取标准化绝对路径，优先于 `getAbsolutePath()` 。
2. 项目内资源：用 `ClassLoader.getResource()` ，注意中文路径解码和 `/` 路径前缀。
3. 现代开发：推荐使用 Java NIO 的 `Path/Paths` 类，功能更全、跨平台性更好。

如何使用类加载器获取项目内资源文件路径？

除了 File 类和类加载器，还有哪些方式可以在 Java 中获取文件路径？

如何在 Java 中获取指定目录下的所有文件路径？
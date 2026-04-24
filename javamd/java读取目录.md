Java读取目录

在 Java 中读取目录（文件夹）内容是非常常见的操作，Java 提供了两套主要的 API：传统的 `java.io.File` 类和更现代、功能更强大的 `java.nio.file` 包（Java 7+ 推荐使用）。下面我会分别展示这两种方式，并重点讲解推荐的 NIO 方式。

### 一、使用现代的 NIO.2 API（推荐）

`java.nio.file` 包提供了更简洁、更高效的文件系统操作方式，支持流式处理、文件属性查询等高级功能。

#### 完整代码示例

java

```java
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.stream.Stream;

public class ReadDirectoryNIO {
    public static void main(String[] args) {
        // 1. 定义要读取的目录路径（替换成你自己的目录）
        String directoryPath = "C:\\test"; // Windows 路径示例
        // String directoryPath = "/home/user/test"; // Linux/Mac 路径示例
        Path dirPath = Paths.get(directoryPath);

        // 2. 检查目录是否存在且是目录
        if (!Files.exists(dirPath) || !Files.isDirectory(dirPath)) {
            System.out.println("目录不存在或不是有效目录！");
            return;
        }

        // 3. 读取目录下的所有文件/子目录（非递归）
        System.out.println("=== 读取目录下的所有内容（非递归）===");
        try (Stream<Path> pathStream = Files.list(dirPath)) {
            // 遍历并打印每个文件/目录的名称
            pathStream.forEach(path -> {
                // 判断是文件还是目录
                String type = Files.isDirectory(path) ? "目录" : "文件";
                System.out.println(type + ": " + path.getFileName());
            });
        } catch (IOException e) {
            System.err.println("读取目录失败：" + e.getMessage());
        }

        // 4. 递归读取目录下的所有内容（包括子目录）
        System.out.println("\n=== 递归读取目录下的所有内容 ===");
        try (Stream<Path> walkStream = Files.walk(dirPath)) {
            walkStream.forEach(path -> {
                String type = Files.isDirectory(path) ? "目录" : "文件";
                System.out.println(type + ": " + path);
            });
        } catch (IOException e) {
            System.err.println("递归读取目录失败：" + e.getMessage());
        }
    }
}
```

#### 关键代码解释

1. **Paths.get(directoryPath)** ：将字符串路径转换为 `Path` 对象（NIO 的核心路径表示）。
2. **Files.exists() / Files.isDirectory()** ：检查路径是否存在且是目录，避免操作无效路径。
3. **Files.list(dirPath)** ：获取目录下直接子项（文件 / 子目录）的流， **非递归** ，使用 try-with-resources 自动关闭流（避免资源泄漏）。
4. **Files.walk(dirPath)** ：递归遍历目录下所有层级的文件 / 目录，默认最大深度为 `Integer.MAX_VALUE` ，也可以指定深度（如 `Files.walk(dirPath, 2)` 表示只遍历 2 层）。
5. **path.getFileName()** ：获取文件 / 目录的名称（不含上级路径）；直接打印 `path` 会输出完整路径。

### 二、使用传统的 File 类

虽然 NIO 更推荐，但了解传统的 `File` 类也很有必要（兼容旧代码）。

#### 完整代码示例

java

```java
import java.io.File;

public class ReadDirectoryFile {
    public static void main(String[] args) {
        // 定义目录路径
        String directoryPath = "C:\\test";
        File directory = new File(directoryPath);

        // 检查目录有效性
        if (!directory.exists() || !directory.isDirectory()) {
            System.out.println("目录不存在或不是有效目录！");
            return;
        }

        // 读取目录下的直接子项（非递归）
        System.out.println("=== 读取目录下的所有内容（非递归）===");
        File[] files = directory.listFiles(); // 返回目录下的所有文件/目录数组
        if (files != null) { // 防止返回 null（如权限不足）
            for (File file : files) {
                String type = file.isDirectory() ? "目录" : "文件";
                System.out.println(type + ": " + file.getName());
            }
        }

        // 递归读取所有内容
        System.out.println("\n=== 递归读取目录下的所有内容 ===");
        listAllFiles(directory);
    }

    // 递归遍历目录的方法
    private static void listAllFiles(File dir) {
        File[] files = dir.listFiles();
        if (files == null) return;

        for (File file : files) {
            String type = file.isDirectory() ? "目录" : "文件";
            System.out.println(type + ": " + file.getAbsolutePath());
            // 如果是目录，继续递归
            if (file.isDirectory()) {
                listAllFiles(file);
            }
        }
    }
}
```

#### 关键代码解释

1. **new File(directoryPath)** ：创建 File 对象表示目录。
2. **directory.listFiles()** ：返回目录下所有直接子项的 File 数组，可能返回 `null` （如权限不足），必须判空。
3. **递归方法 listAllFiles ()** ：手动实现递归遍历，遍历到子目录时再次调用自身。

### 三、注意事项

1. **权限问题** ：读取目录时可能因权限不足导致 `listFiles()` 返回 null 或 NIO 抛出 `IOException` ，需捕获异常并处理。
2. **路径分隔符** ：Windows 使用 `\` ，Linux/Mac 使用 `/` ，推荐使用 `File.separator` 或 Paths API 自动适配（如 `Paths.get("C:", "test")` ）。
3. **资源关闭** ：NIO 的 Stream 必须关闭，使用 try-with-resources 是最佳实践；File 类无流需要关闭。

### 总结

1. **推荐使用 NIO.2 API（Files/Path）** ：代码更简洁、支持流式处理、异常处理更规范，是 Java 7+ 的标准做法。
2. **非递归读取** ：用 `Files.list()` （NIO）或 `listFiles()` （File）；递归读取用 `Files.walk()` （NIO）或手动递归（File）。
3. **核心检查** ：操作目录前必须先通过 `exists()` 和 `isDirectory()` 验证目录有效性，避免空指针或无效操作。

如何使用 Java NIO.2 API 读取目录下的文件内容？

Java 中读取目录时如何处理文件编码问题？

除了 NIO.2 API，还有其他方式读取目录吗？
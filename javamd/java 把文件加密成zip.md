Java 把文件加密成zip

我会帮你实现一个完整的 Java 程序，用于将文件加密压缩成 ZIP 格式。Java 标准库本身不支持 ZIP 加密，所以我们需要使用成熟的第三方库 `zip4j` ，它是处理加密 ZIP 文件的最佳选择之一。

### 实现思路

1. 引入 `zip4j` 依赖（Maven/Gradle）
2. 编写工具类，实现单个文件 / 多个文件加密压缩为 ZIP
3. 支持设置密码、压缩级别等参数
4. 增加异常处理，保证程序健壮性

### 完整代码实现

#### 第一步：添加依赖

如果使用 Maven，在 `pom.xml` 中添加：

xml

```xml
<dependency>
    <groupId>net.lingala.zip4j</groupId>
    <artifactId>zip4j</artifactId>
    <version>2.11.5</version> <!-- 使用最新稳定版 -->
</dependency>
```

如果使用 Gradle，在 `build.gradle` 中添加：

groovy

```groovy
dependencies {
    implementation 'net.lingala.zip4j:zip4j:2.11.5'
}
```

#### 第二步：加密压缩工具类

java

```java
import net.lingala.zip4j.ZipFile;
import net.lingala.zip4j.model.ZipParameters;
import net.lingala.zip4j.model.enums.AesKeyStrength;
import net.lingala.zip4j.model.enums.CompressionLevel;
import net.lingala.zip4j.model.enums.CompressionMethod;
import net.lingala.zip4j.model.enums.EncryptionMethod;

import java.io.File;
import java.util.Arrays;

/**
 * ZIP 加密压缩工具类
 */
public class EncryptedZipUtils {

    /**
     * 将单个文件加密压缩为 ZIP
     * @param sourceFilePath 源文件路径（如：D:/test.txt）
     * @param zipFilePath 生成的 ZIP 文件路径（如：D:/test.zip）
     * @param password ZIP 解压密码
     * @throws Exception 处理过程中的异常
     */
    public static void encryptFileToZip(String sourceFilePath, String zipFilePath, String password) throws Exception {
        // 校验源文件是否存在
        File sourceFile = new File(sourceFilePath);
        if (!sourceFile.exists() || sourceFile.isDirectory()) {
            throw new IllegalArgumentException("源文件不存在或不是文件：" + sourceFilePath);
        }

        // 初始化 ZIP 文件（会自动创建不存在的文件）
        ZipFile zipFile = new ZipFile(zipFilePath, password.toCharArray());

        // 设置 ZIP 参数
        ZipParameters zipParameters = new ZipParameters();
        zipParameters.setCompressionMethod(CompressionMethod.DEFLATE); // 压缩方式（DEFLATE 是标准压缩）
        zipParameters.setCompressionLevel(CompressionLevel.NORMAL);    // 压缩级别（NORMAL 平衡压缩率和速度）
        zipParameters.setEncryptFiles(true);                          // 启用加密
        zipParameters.setEncryptionMethod(EncryptionMethod.AES);      // 加密方式（AES 更安全）
        zipParameters.setAesKeyStrength(AesKeyStrength.KEY_STRENGTH_256); // AES 256位加密

        // 添加文件到 ZIP
        zipFile.addFile(sourceFile, zipParameters);
        zipFile.close(); // 关闭资源
    }

    /**
     * 将多个文件加密压缩为 ZIP
     * @param sourceFilePaths 源文件路径列表
     * @param zipFilePath 生成的 ZIP 文件路径
     * @param password ZIP 解压密码
     * @throws Exception 处理过程中的异常
     */
    public static void encryptFilesToZip(String[] sourceFilePaths, String zipFilePath, String password) throws Exception {
        if (sourceFilePaths == null || sourceFilePaths.length == 0) {
            throw new IllegalArgumentException("源文件列表不能为空");
        }

        // 初始化 ZIP 文件
        ZipFile zipFile = new File(zipFilePath).exists() 
            ? new ZipFile(zipFilePath, password.toCharArray()) 
            : new ZipFile(zipFilePath, password.toCharArray());

        // 设置 ZIP 参数（同单个文件）
        ZipParameters zipParameters = new ZipParameters();
        zipParameters.setCompressionMethod(CompressionMethod.DEFLATE);
        zipParameters.setCompressionLevel(CompressionLevel.NORMAL);
        zipParameters.setEncryptFiles(true);
        zipParameters.setEncryptionMethod(EncryptionMethod.AES);
        zipParameters.setAesKeyStrength(AesKeyStrength.KEY_STRENGTH_256);

        // 遍历添加文件
        for (String sourcePath : sourceFilePaths) {
            File sourceFile = new File(sourcePath);
            if (sourceFile.exists() && !sourceFile.isDirectory()) {
                zipFile.addFile(sourceFile, zipParameters);
            } else {
                System.err.println("跳过无效文件：" + sourcePath);
            }
        }

        zipFile.close();
    }

    // 测试方法
    public static void main(String[] args) {
        try {
            // 测试单个文件加密压缩
            String sourceFile = "D:/test.txt";       // 待加密的源文件
            String zipFile = "D:/test_encrypted.zip"; // 生成的加密 ZIP
            String password = "123456";              // 解压密码
            encryptFileToZip(sourceFile, zipFile, password);
            System.out.println("单个文件加密压缩完成！");

            // 测试多个文件加密压缩
            /*
            String[] sourceFiles = {"D:/file1.txt", "D:/file2.pdf", "D:/image.jpg"};
            String multiZipFile = "D:/multi_files_encrypted.zip";
            encryptFilesToZip(sourceFiles, multiZipFile, "654321");
            System.out.println("多个文件加密压缩完成！");
            */
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("加密压缩失败：" + e.getMessage());
        }
    }
}
```

### 代码关键部分解释

1. **ZipParameters 参数配置** ：
	- `CompressionMethod.DEFLATE` ：标准 ZIP 压缩方式（比 STORE 更节省空间）
	- `CompressionLevel.NORMAL` ：平衡压缩率和速度（可选：FASTEST、NORMAL、ULTRA）
	- `EncryptionMethod.AES` ：使用 AES 加密（比 ZIP\_STANDARD 更安全）
	- `AesKeyStrength.KEY_STRENGTH_256` ：256 位 AES 加密（最高安全级别）
2. **核心方法** ：
	- `encryptFileToZip` ：处理单个文件加密压缩
	- `encryptFilesToZip` ：处理多个文件加密压缩
	- 都包含了文件存在性校验，避免空指针或无效文件问题
3. **异常处理** ：
	- 校验源文件是否存在、是否为文件
	- 捕获并打印异常信息，方便排查问题

### 使用说明

1. 替换代码中的 `sourceFile` 、 `zipFile` 、 `password` 为实际路径和密码
2. 运行 `main` 方法即可生成加密的 ZIP 文件
3. 生成的 ZIP 文件需要输入密码才能解压（支持所有主流解压工具：WinRAR、7-Zip 等）

### 总结

1. Java 实现 ZIP 加密需依赖第三方库 `zip4j` ，标准库不支持加密功能；
2. 核心是通过 `ZipParameters` 配置加密方式（AES 256 位）和压缩参数，再通过 `ZipFile` 添加文件；
3. 实际使用时需注意文件路径合法性、密码安全性，以及资源关闭（ `zipFile.close()` ）。

如果需要压缩文件夹（而非单个文件），只需将 `addFile` 替换为 `addFolder` 即可，核心逻辑完全一致。

如何使用 Java 解压缩 ZIP 文件？

除了 zip4j 库，还有哪些 Java 库可以实现文件加密成 zip？

如何在 Java 中实现对 ZIP 文件的加密强度设置？
Java 加密种类

Java 中提供了丰富的加密算法支持，这些算法主要分为几大类，每种都有其特定的应用场景和安全特性。我会从新手易懂的角度，为你梳理 Java 中最常用的加密种类、核心概念和简单示例。

### 一、加密算法的核心分类

Java 中的加密算法主要基于 **JCA (Java Cryptography Architecture)** 和 **JCE (Java Cryptography Extension)** 实现，核心分为以下 4 大类：

#### 1\. 对称加密（对称密钥加密）

- **核心特点** ：加密和解密使用 **同一个密钥** ，算法简单、加解密速度快，适合加密大量数据。
- **缺点** ：密钥传输和保管风险高（一旦密钥泄露，数据就会被破解）。
- **Java 中常用实现** ：
	- AES（Advanced Encryption Standard）：目前最主流、最安全的对称加密算法，推荐优先使用。
	- DES/3DES：DES 已被破解，3DES 是 DES 的改进版，但效率低于 AES，逐步被淘汰。
	- Blowfish、RC4 等（非主流，仅作了解）。

**AES 简单示例（Java 实现）** ：

java

```java
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
import java.util.Base64;

public class AesEncryptor {
    // 算法名称
    private static final String ALGORITHM = "AES";
    // 加密模式和填充方式（新手记住这个组合即可）
    private static final String TRANSFORMATION = "AES/ECB/PKCS5Padding";

    // 生成 AES 密钥（128位，Java 默认支持，256位需配置无限制策略文件）
    public static SecretKey generateAesKey() throws Exception {
        KeyGenerator keyGen = KeyGenerator.getInstance(ALGORITHM);
        keyGen.init(128); // 密钥长度：128/192/256
        return keyGen.generateKey();
    }

    // 加密
    public static String encrypt(String plainText, SecretKey secretKey) throws Exception {
        Cipher cipher = Cipher.getInstance(TRANSFORMATION);
        cipher.init(Cipher.ENCRYPT_MODE, secretKey);
        byte[] encryptedBytes = cipher.doFinal(plainText.getBytes("UTF-8"));
        // 转 Base64 方便存储/传输
        return Base64.getEncoder().encodeToString(encryptedBytes);
    }

    // 解密
    public static String decrypt(String cipherText, SecretKey secretKey) throws Exception {
        Cipher cipher = Cipher.getInstance(TRANSFORMATION);
        cipher.init(Cipher.DECRYPT_MODE, secretKey);
        byte[] decryptedBytes = cipher.doFinal(Base64.getDecoder().decode(cipherText));
        return new String(decryptedBytes, "UTF-8");
    }

    // 测试
    public static void main(String[] args) throws Exception {
        String originalText = "Hello, Java Encryption!";
        // 生成密钥
        SecretKey key = generateAesKey();
        // 加密
        String encrypted = encrypt(originalText, key);
        System.out.println("加密后：" + encrypted);
        // 解密
        String decrypted = decrypt(encrypted, key);
        System.out.println("解密后：" + decrypted);
    }
}
```

#### 2\. 非对称加密（公钥加密）

- **核心特点** ：使用 **一对密钥** （公钥 + 私钥），公钥公开，私钥保密；用公钥加密的数据只能用私钥解密，反之亦然。
- **优点** ：密钥传输安全； **缺点** ：加解密速度慢，适合加密少量数据（如对称加密的密钥）。
- **Java 中常用实现** ：
	- RSA：应用最广泛的非对称加密算法，支持加密和数字签名。
	- DSA：仅用于数字签名，不支持加密。
	- ECC（椭圆曲线加密）：更轻量，同等安全级别下密钥长度更短，适合移动端。

**RSA 简单示例（Java 实现）** ：

java

```java
import javax.crypto.Cipher;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.util.Base64;

public class RsaEncryptor {
    private static final String ALGORITHM = "RSA";

    // 生成 RSA 密钥对（1024/2048位，2048位更安全）
    public static KeyPair generateRsaKeyPair() throws Exception {
        KeyPairGenerator keyGen = KeyPairGenerator.getInstance(ALGORITHM);
        keyGen.initialize(2048);
        return keyGen.generateKeyPair();
    }

    // 公钥加密
    public static String encrypt(String plainText, PublicKey publicKey) throws Exception {
        Cipher cipher = Cipher.getInstance(ALGORITHM);
        cipher.init(Cipher.ENCRYPT_MODE, publicKey);
        byte[] encryptedBytes = cipher.doFinal(plainText.getBytes("UTF-8"));
        return Base64.getEncoder().encodeToString(encryptedBytes);
    }

    // 私钥解密
    public static String decrypt(String cipherText, PrivateKey privateKey) throws Exception {
        Cipher cipher = Cipher.getInstance(ALGORITHM);
        cipher.init(Cipher.DECRYPT_MODE, privateKey);
        byte[] decryptedBytes = cipher.doFinal(Base64.getDecoder().decode(cipherText));
        return new String(decryptedBytes, "UTF-8");
    }

    // 测试
    public static void main(String[] args) throws Exception {
        String originalText = "RSA Test";
        // 生成密钥对
        KeyPair keyPair = generateRsaKeyPair();
        PublicKey publicKey = keyPair.getPublic();
        PrivateKey privateKey = keyPair.getPrivate();

        // 公钥加密
        String encrypted = encrypt(originalText, publicKey);
        System.out.println("公钥加密后：" + encrypted);
        // 私钥解密
        String decrypted = decrypt(encrypted, privateKey);
        System.out.println("私钥解密后：" + decrypted);
    }
}
```

#### 3\. 哈希算法（摘要算法）

- **核心特点** ：将任意长度的数据转换为 **固定长度的哈希值** （摘要），是 **不可逆** 的（无法从哈希值还原原始数据）。
- **核心用途** ：验证数据完整性（如文件校验）、存储密码（不存储明文，只存哈希值）。
- **Java 中常用实现** ：
	- MD5（128 位）：已被破解，仅用于非安全场景的校验。
	- SHA 系列：SHA-1（160 位，逐步淘汰）、SHA-256/SHA-512（安全，推荐使用）。
	- HMAC：带密钥的哈希算法（如 HMAC-SHA256），既验证数据完整性，又验证密钥，适合接口签名。

**SHA-256 + HMAC 示例** ：

java

```java
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.security.MessageDigest;
import java.util.Base64;

public class HashUtils {
    // 纯 SHA-256 哈希
    public static String sha256(String plainText) throws Exception {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hashBytes = digest.digest(plainText.getBytes("UTF-8"));
        // 转十六进制字符串
        StringBuilder hexString = new StringBuilder();
        for (byte b : hashBytes) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) hexString.append('0');
            hexString.append(hex);
        }
        return hexString.toString();
    }

    // HMAC-SHA256（带密钥的哈希）
    public static String hmacSha256(String plainText, String key) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        SecretKeySpec secretKey = new SecretKeySpec(key.getBytes("UTF-8"), "HmacSHA256");
        mac.init(secretKey);
        byte[] hmacBytes = mac.doFinal(plainText.getBytes("UTF-8"));
        return Base64.getEncoder().encodeToString(hmacBytes);
    }

    // 测试
    public static void main(String[] args) throws Exception {
        String originalText = "Test Hash";
        String key = "mySecretKey123";

        // SHA-256 哈希
        String sha256Result = sha256(originalText);
        System.out.println("SHA-256 结果：" + sha256Result);

        // HMAC-SHA256 结果
        String hmacResult = hmacSha256(originalText, key);
        System.out.println("HMAC-SHA256 结果：" + hmacResult);
    }
}
```

#### 4\. 数字签名

- **核心特点** ：基于非对称加密 + 哈希算法，用于 **验证数据来源的真实性** 和 **数据完整性** （防篡改、防抵赖）。
- **流程** ：发送方用私钥对数据的哈希值签名 → 接收方用发送方的公钥验证签名。
- **Java 中常用实现** ：RSA、DSA、ECDSA（椭圆曲线签名）。

### 二、Java 加密开发的注意事项

1. **密钥安全** ：对称加密的密钥、非对称加密的私钥必须妥善保管，避免硬编码在代码中。
2. **填充方式** ：对称加密需指定填充方式（如 PKCS5Padding），否则会抛出异常；ECB 模式不安全，实际开发推荐用 CBC/GCM 模式（需初始化向量 IV）。
3. **字符编码** ：加解密时统一使用 UTF-8 编码，避免乱码。
4. **性能考量** ：大量数据加密优先用 AES（对称），仅对密钥 / 少量数据用 RSA（非对称）。

### 总结

1. **对称加密** （AES 为主）：加解密速度快，密钥共享风险高，适合加密大量数据；
2. **非对称加密** （RSA 为主）：加解密速度慢，密钥传输安全，适合加密少量数据或签名；
3. **哈希算法** （SHA-256/HMAC 为主）：不可逆，用于数据完整性验证、密码存储。

新手入门优先掌握 AES（对称）、RSA（非对称）、SHA-256（哈希）这三种核心算法，基本能覆盖 90% 的日常加密需求。

对称加密的密钥是如何生成和管理的？

非对称加密的原理和应用场景是什么？

如何在 Java 中使用非对称加密算法？
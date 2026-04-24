Java 数组

### Java 数组详解

数组是 Java 中最基础的容器之一，用于 **存储固定长度、相同数据类型** 的一组数据。可以把它理解成一排编号的格子，每个格子只能放同一种类型的数据，且格子数量一旦确定就不能改变。

---

### 一、数组的核心概念

1. **固定长度** ：创建数组时必须指定长度，后续无法扩容 / 缩容。
2. **相同类型** ：数组中所有元素的类型必须一致（如全是 int、全是 String）。
3. **索引访问** ：数组元素通过「索引」（从 0 开始）访问，例如 `arr[0]` 是第一个元素， `arr[length-1]` 是最后一个。
4. **内存连续** ：数组在内存中是连续存储的，访问速度快。

---

### 二、数组的创建与初始化

Java 中创建数组有 3 种常见方式，推荐前两种（更规范）：

#### 方式 1：声明 + 初始化（静态初始化）

直接指定数组元素，JVM 自动计算长度。

java

```java
// 语法：数据类型[] 数组名 = {元素1, 元素2, ...};
// 示例1：int 类型数组
int[] nums = {10, 20, 30, 40};

// 示例2：String 类型数组
String[] names = {"张三", "李四", "王五"};
```

#### 方式 2：声明长度 + 后续赋值（动态初始化）

先指定长度，再通过索引逐个赋值（未赋值时，基本类型有默认值：int=0、boolean=false，引用类型 = null）。

java

```java
// 语法：数据类型[] 数组名 = new 数据类型[长度];
// 示例：创建长度为 5 的 int 数组
int[] scores = new int[5];
// 赋值
scores[0] = 90;
scores[1] = 85;
scores[2] = 95;
// 未赋值的元素默认是 0
System.out.println(scores[3]); // 输出 0
```

#### 方式 3：声明 + 初始化（完整写法，较少用）

java

```java
int[] ages = new int[]{18, 20, 22}; // 效果和方式1一致
```

---

### 三、数组的常用操作

#### 1\. 访问数组元素

通过索引访问，注意 **索引越界会抛出 ArrayIndexOutOfBoundsException** （新手常见错误）。

java

```java
public class ArrayDemo {
    public static void main(String[] args) {
        int[] nums = {10, 20, 30};
        // 访问第一个元素
        System.out.println(nums[0]); // 输出 10
        // 访问最后一个元素
        System.out.println(nums[nums.length - 1]); // 输出 30（length 是数组的长度属性）
        
        // 错误示例：索引越界（数组长度为3，最大索引是2）
        // System.out.println(nums[3]); // 运行报错
    }
}
```

#### 2\. 遍历数组

遍历即逐个访问数组元素，有 2 种常用方式：

java

```java
public class ArrayTraverse {
    public static void main(String[] args) {
        String[] fruits = {"苹果", "香蕉", "橙子"};
        
        // 方式1：普通 for 循环（可控制索引，适合需要修改元素的场景）
        for (int i = 0; i < fruits.length; i++) {
            System.out.println("索引" + i + "：" + fruits[i]);
        }
        
        // 方式2：增强 for 循环（foreach，简洁，仅读取元素）
        for (String fruit : fruits) {
            System.out.println(fruit);
        }
    }
}
```

**输出结果** ：

plaintext

```
索引0：苹果
索引1：香蕉
索引2：橙子
苹果
香蕉
橙子
```

#### 3\. 数组的常见工具类（Arrays）

Java 提供 `java.util.Arrays` 类，封装了数组的常用操作（排序、查找、转字符串等），需先导入：

java

```java
import java.util.Arrays;

public class ArraysUtil {
    public static void main(String[] args) {
        int[] arr = {3, 1, 4, 2};
        
        // 1. 数组转字符串（方便打印）
        System.out.println(Arrays.toString(arr)); // 输出 [3, 1, 4, 2]
        
        // 2. 排序（默认升序）
        Arrays.sort(arr);
        System.out.println(Arrays.toString(arr)); // 输出 [1, 2, 3, 4]
        
        // 3. 二分查找（需先排序，找到返回索引，未找到返回负数）
        int index = Arrays.binarySearch(arr, 3);
        System.out.println(index); // 输出 2（排序后 3 在索引 2 位置）
        
        // 4. 填充数组（所有元素设为指定值）
        int[] newArr = new int[5];
        Arrays.fill(newArr, 8);
        System.out.println(Arrays.toString(newArr)); // 输出 [8, 8, 8, 8, 8]
    }
}
```

---

### 四、多维数组（以二维数组为例）

二维数组可以理解成「数组的数组」，比如表格（行 + 列）：

java

```java
public class TwoDArray {
    public static void main(String[] args) {
        // 初始化一个 2 行 3 列的二维数组
        int[][] matrix = {
            {1, 2, 3},
            {4, 5, 6}
        };
        
        // 遍历二维数组
        for (int i = 0; i < matrix.length; i++) { // 遍历行
            for (int j = 0; j < matrix[i].length; j++) { // 遍历列
                System.out.print(matrix[i][j] + " ");
            }
            System.out.println(); // 换行
        }
    }
}
```

**输出结果** ：

plaintext

```
1 2 3 
4 5 6
```

---

### 总结

1. **核心特性** ：Java 数组是固定长度、同类型的连续存储容器，通过索引（从 0 开始）访问元素。
2. **常用操作** ：创建（静态 / 动态初始化）、遍历（for/foreach）、工具类（Arrays 排序 / 转字符串 / 查找）。
3. **注意事项** ：避免索引越界（ArrayIndexOutOfBoundsException），多维数组本质是「数组的数组」。

如果需要针对数组的某一具体场景（如数组扩容、数组拷贝、数组去重）深入讲解，可以告诉我。

如何遍历 Java 数组？

Java 数组和集合类有什么区别？

如何在 Java 中复制数组？
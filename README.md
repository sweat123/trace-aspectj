# Trace Aspectj

## Usage

Add maven to your project pom.xml

```xml
<dependency>
    <groupId>com.laomei.trace</groupId>
    <artifactId>trace-aspectj</artifactId>
    <version>1.0-SNAPSHOT</version>
</dependency>
```

Add aspectj maven plugin

```xml
<plugin>
    <groupId>org.codehaus.mojo</groupId>
    <artifactId>aspectj-maven-plugin</artifactId>
    <version>1.7</version>
    <configuration>
        <complianceLevel>1.8</complianceLevel>
        <source>1.8</source>
        <target>1.8</target>
        <aspectLibraries>
            <aspectLibrary>
                <groupId>com.laomei.trace</groupId>
                <artifactId>trace-aspectj</artifactId>
            </aspectLibrary>
        </aspectLibraries>
    </configuration>
    <executions>
        <execution>
            <phase>compile</phase>
            <goals>
                <goal>compile</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```

Add `@Trace` to the method which you want to trace;

## Result 

You can get information from log file;

## Example

Java class

```java
public class Main {

    public static void main(String[] args) throws InterruptedException {
        Main main = new Main();
        main.hello(1);
        main.test();
    }

    @Trace
    public void test() {
        System.out.println("test");
    }

    @Trace
    public void hello(int i) throws InterruptedException {
        System.out.println("hello");
        hi1();
        hi2();
        hi3();
        TimeUnit.SECONDS.sleep(1);
    }

    @Trace
    public void hi1() throws InterruptedException {
        System.out.println("hi");
        TimeUnit.SECONDS.sleep(1);
    }

    @Trace
    public void hi2() throws InterruptedException {
        System.out.println("hi");
        TimeUnit.SECONDS.sleep(1);
        hi3();
    }
    @Trace
    public void hi3() {
        System.out.println("sleep");
    }
}
```

Console log

```text
hello
hi
20:48:10.225 [main] INFO  com.laomei.trace.TraceQueue - prefix-1-2|com.laomei.test.aspectj.trace.Main|hi1|1002ms
hi
20:48:11.258 [main] INFO  com.laomei.trace.TraceQueue - prefix-1-3-4|com.laomei.test.aspectj.trace.Main|hi3|30ms
20:48:11.258 [main] INFO  com.laomei.trace.TraceQueue - prefix-1-3|com.laomei.test.aspectj.trace.Main|hi2|1031ms
20:48:11.258 [main] INFO  com.laomei.trace.TraceQueue - prefix-1-5|com.laomei.test.aspectj.trace.Main|hi3|0ms
sleep
sleep
20:48:12.258 [main] INFO  com.laomei.trace.TraceQueue - prefix-1|com.laomei.test.aspectj.trace.Main|hello|3435ms
test
20:48:12.258 [main] INFO  com.laomei.trace.TraceQueue - prefix-6|com.laomei.test.aspectj.trace.Main|test|0ms
```

The format of the trace message:

`id|className|methodName|time cost`

- `hello()` is the first method will be traced; The id of this method is `prefix-1`
- `hi1()` is the sub method in `hello()`; This is the second method which is traced; Id is 
`prefix-1-2`
- `hi2()` is third method which is traced; Id is `prefix-1-3`
- `hi3()` will be accessed in `hi2()`; Id is `prefix-1-3-4`
- `test()` is the last method will be traced; Id is `prefix-6`

1. From these data, you can know that the order of the methods is not in sequential; 
2. But method which is called later will have a more large id; Like `h1()` and `h2()`
3. Methods which are in the same level (`hello()` and `test()`), the format of the id will be same; Method which is called later will have a large id;
4. Although the message is not friendly, but the have topology sort; We can know the order of method and how long each method cost;

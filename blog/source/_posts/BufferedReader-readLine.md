---
title: BufferedReader.readLine() 的使用中遇到的问题
date: 2016-06-13 22:15:00
categories:
- Java 编程
tags: 
- Java
description: 
---

## 前言
遇到这么一个问题，需要从网络上下载图片到本地，单元测试一直停不下来，有次让单元测试跑起来之后，自己出去吃了个早饭回来发现
单元测试还没有跑完。然后跟断点发现程序阻塞在 **readLine()** 方法上了。

<!-- more -->

## BufferedReader
**BufferedReader** 是由 **Reader** 类扩展而来，提供通用的缓冲方式文本读取，而且提供了很实用的 **readLine** 方法，也就是今天
我要重点说的那个方法。**BufferReader** 的作用是为 **Reader** 提供缓冲功能。 **readLine** 方法一次读取一个文本行，从字符输入流中读取
文本，缓冲各个字符，从而提供字符、数组和行的高效读取。

```java
 StringBuffer sb = new StringBuffer();
    BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String line = null;
            while ((line = reader.readLine()) != null) {
            System.out.println(¨---here¨);
                sb.append(line);
            }
```
然后程序就阻塞在了 ** while ((line = reader.readLine()) != null)** 这一行。System.out.println(¨---here¨); 这一句始终没有打印。

那么，程序为什么会阻塞呢？那么我们就需要了解一下 **readLine** 这个
方法了。
**readLine** 是一个阻塞方法，在没有读取到数据的时候并不会返回 **null** 。**readLine** 只有在数据流发生异常时才会返回null值。如果
不指定 **buffer** 大小，则** readLine** 的 **buffer** 默认大小是 **8192** 个字符。在没有达到buffer大小之前，只有遇到**"/r"、"/n"、"/r/n"**才会返回。
这个时候这个时候，我就在猜想到底是我的图片太小，不足 **8192** 个字符呢？还是说别的什么原因才导致 **readLine** 才没有一直返回。。
为了不让程序阻塞，可以设置超时时间，但是这个不是解决问题的最终办法。因为这个 url 上的图片通过浏览器是可以正常访问，且完全
可以通过浏览器下载到本地。断点一路跟来，最后锁定问题出在了这一句 **conn.getInputStream()** 因为 **InputStream** 流的原因，导致 **readine** 读不到数据才一直阻塞

InputStream 我是通过一下方式获取的。
```java
      HttpURLConnection conn = (HttpURLConnection) new URL(picURL).openConnection();
        conn.setRequestProperty("Accept-Charset", "utf-8");
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

        conn.setConnectTimeout(timeout * 1000);
        conn.setReadTimeout(timeout * 1000);

        return conn.getInputStream();
```

看代码似乎没有什么问题，但是通过在控制台打印我发现来，**conn.getContentEncoding()** 的值为 **null** 和 **gzip** 的会导致 **readLine** 阻塞。这个时候问题就有两种解决方案了
一种是，在返回 **InputStream** 流的时候进行类型判断，还有一种方案就是换一种图片下载的方式。

## 总结
- 通过在网上查资料，大多数人都建议在使用socket之类的数据流时，要避免使用 **readLine**。
- **conn.getInputStream()** 有可能会获取到 gzip 流，我们可以通过 **new GZIPInputStream(conn.getInputStream())** 来解压我们的流。

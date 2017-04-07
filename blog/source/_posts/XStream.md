---
title: XStream 之 JavaBean 与 XML 相互转换
date: 2017-04-07 22:22:00
categories:
- 工具代码
tags: 
- java
- xml
- xStream
description: 
---

# 前言 
最近重构老项目，接口返回值为 xml 。不想使用老项目中的方式，遂 google 下，试图寻找一个现成的 JavaBean 与 XML 相互转换的工具。于是就与 XStream 邂逅
了。使用之初，也发现了不少问题，于是有了此篇记录。

#引入
maven 引入非常方便，只需要在 _pom.xml_ 引入如下代码

```xml
<dependency>
    <groupId>com.thoughtworks.xstream</groupId>
    <artifactId>xstream</artifactId>
    <version>1.4.9</version>
</dependency>
```
不是 maven 工程的需要自行导图 jar 包，_xstream-1.4.9.jar_ (其他版本也是可以的，1.4.9 目前是最新版本)

#简单的 JavaBean 转 XML


稍后继续，要开始干活了，半夜压测。。。。。。。。。。。。。

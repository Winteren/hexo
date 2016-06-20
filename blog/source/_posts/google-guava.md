---
title: Google Guava Cache 学习笔记
date: 2016-06-15 00:00:00
categories:
- 学习笔记
tags: 
- Java 编程
- Guava
- Cache
description: 
---
## 缓存
缓存主要作用是就是预读取（预先读取将要载入的数据）、存储临时访问过的数据和对写入的数据进行暂时存放。

<!-- more -->

## 比较常见的几种缓存
- 本地缓存
- 分布式缓存
- 数据库缓存
- CPU 缓存
- Http 缓存

## Guava Cache
Guava Cache 是一个全内存的本地缓存，它提供了线程安全的实现机制。使用缓存就意味着你要牺牲一部分内存空间


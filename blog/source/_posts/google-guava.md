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
Guava Cache 是一个全内存的本地缓存，它提供了线程安全的实现机制。使用缓存就意味着你要牺牲一部分内存空间。

## Guava Cache 有两种创建方式
### CacheLoader 
LoadingCache 是附带 CacheLoader 构建而成的缓存实现，创建自己的 CacheLoader 通常只需要简单的实现 `V load(K key) throws Exception` 方法。
官网的范例如下：

```java
LoadingCache<Key, Graph> graphs = CacheBuilder.newBuilder()
        .maximumSize(1000)
        .build(
            new CacheLoader<Key, Graph>() {
                public Graph load(Key key) throws AnyException {
                    return createExpensiveGraph(key);
                }
            });
 
...
try {
    return graphs.get(key);
} catch (ExecutionException e) {
    throw new OtherException(e.getCause());
}

```

参照官网的范例，我的测试代码如下：

```java
private LoadingCache<String,List<User>> cache = null;
    @Before
    public void loadCache(){
        cache = CacheBuilder
                .newBuilder()
                .maximumSize(1000)
                .expireAfterAccess(2, TimeUnit.SECONDS)
                .build(new CacheLoader<String, List<User>>() {
                    @Override
                    public List<User> load(String key) throws Exception {
                        return userService.getAllUser();
                    }
                });
    }
    
    @Test
    public  void testLoadingCache(){
        try {
             System.out.println(cache.get("user"));
             System.out.println(cache.get("user"));
             Thread.sleep(5000);//这里主要是为了测试expireAfterAccess(2, TimeUnit.SECONDS)
             System.out.println(cache.get("user"));
             System.out.println(cache.get("user"));
        } catch (Exception e) {
            System.out.println("---"+e.getMessage());
        }
    }
```

从 `LoadingCache` 查询的正规方式是试用 `get(k)` 方法。这个方法要么返回已经缓存的值，要么使用 `CacheLoader` 向缓存原子地加载新值。由于 `CacheLoader` 可能抛出异常，`LoadingCache.get(k)` 也声明为抛出 `ExecutionException` 异常。如果你定义的 `CacheLoader` 没有声明任何检查型异常，则可通过 `getUnchecked(k)` 查找缓存，但必须注意，一旦 `CacheLoader` 声明了检查异常，就可以不调用 `getUnchecked(k)`。
官网示例：

```java 
LoadingCache<Key, Graph> graphs = CacheBuilder.newBuilder()
        .expireAfterAccess(10, TimeUnit.MINUTES)
        .build(
            new CacheLoader<Key, Graph>() {
                public Graph load(Key key) { // no checked exception
                    return createExpensiveGraph(key);
                }
            });
 
...
return graphs.getUnchecked(key);
```

### Callable
所有类型的 `Guava Cache` ，不管有没有自动加载功能，都支持 `get(K,Callable<V>)` 方法。这个方法返回缓存中相应的值，或者用给定的 `Callable` 运算并把结果加到缓存中。在整个加载方法完成前，缓存项相关的可观察状态都不会更改。这个方法简便第实现了模式 **“如果有缓存则返回；否则运算、缓存、然后返回”**。
官网示例：

```java
Cache<Key, Graph> cache = CacheBuilder.newBuilder()
        .maximumSize(1000)
        .build(); // look Ma, no CacheLoader

...
try {
    // If the key wasn't in the "easy to compute" group, we need to
    // do things the hard way.
    cache.get(key, new Callable<Key, Graph>() {
        @Override
        public Value call() throws AnyException {
            return doThingsTheHardWay(key);
        }
    });
} catch (ExecutionException e) {
    throw new OtherException(e.getCause());
}

```

**[参考资料](http://ifeve.com/google-guava-cachesexplained/)**

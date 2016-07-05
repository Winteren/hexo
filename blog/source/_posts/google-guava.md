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

参照官网的范例，我的测试代码如下：

```java
 private Cache<String,List<User>> cache = null;
    private List<User> users = null;
    @Before
    public void callableCache(){
        cache = CacheBuilder.newBuilder().maximumSize(1000).build();
        try {
                users = cache.get("user", new Callable<List<User>>() {
                public List<User> call() throws Exception {
                return userService.getAllUser();
                }
            });
        } catch (ExecutionException e) {
            e.printStackTrace();
        }
    }
    
    @Test
    public void testCallableCache() throws Exception{

        System.out.println("user value : " + users);
        System.out.println("user value : " + users);
        System.out.println("user value : " + users);
        System.out.println("user value : " + users);
    }
    
```

使用 `cache.put(key,value)` 方法可以直接向缓存中插入值，这回直接覆盖掉给定键之前映射的值。使用 `Cache.asMap()` 视图提供的任何方法也能修改缓存。但请注意，`asMap` 视图的任何方法都不能保证缓存项被院子地加载到缓存中。进一步说，`asMap` 视图的原子运算在 **Guava Cache** 的原子加载范畴之外，所以相比于 `Cache.asMap().putIfAbsent(K,V)`, `Cache.get(K,Callable<K>)` 应该总是优先使用。

## Cache 参数说明：

回收的参数：

### 基于容量的回收(size-based eviction)
- CacheBuilder.maximumSize(long):如果要规定缓存项的数据不超过固定值，只需要设置该参数。缓存将尝试回收最近没有使用或总体上很少使用的缓存项。_警告：在缓存项的数目达到限定值之前，缓存就可能进行回收操作，通常来说，这种情况发生在缓存项的数目逼近限定值时。_ 
- CacheBuilder.weigher(Weigher):不同的缓存项有不同的 “权重” (weights). 例如，如果你的缓存值，占据完全不同的内存空间可以设置该参数指定一个权重函数，并用 `CacheBuilder.maxumumWeigher(long)` 指定最大总重。
- CacheBuilder.maxumumWeigher(long):指定权重最大总重。_在权重限定场景中，除了要注意回收也是在冲了逼近限定值时就进行了，还要知道重量是在缓存创建时计算的，因此要考虑重量计算的复杂度。_

### 定时回收(Timed Eviction)
- expireAfterAccess(long, TimeUnit):缓存项在给定时间内没有被读/写访问，则回收。_请注意这种缓存的回收顺序和基于大小回收一样。_
- expireAfterWrite(long, TimeUnit):缓存项在给定时间内没有被写访问（创建或覆盖），则回收。_如果认为缓存数据总是在固定时候会变得陈旧不可用，这种回收方式是可取的。_
### 引用的回收(Reference-based Eviction)
通过使用弱引用的键、或弱引用的值、或软引用的值，Guava Cache 可以把缓存设置为允许垃圾回收：
- CacheBuilder.weakKeys():使用弱引用存储键，当键没有其它（强或软）引用时，缓存项可以被垃圾回收。因为垃圾回收仅依赖恒等式`（==）`，使用弱医用建的缓存用 `==` 而不是 `equals` 比较键。
- CacheBuilder.weakValues():使用弱引用存储值。当值没有其它（强或软）引用是，缓存项可以被垃圾回收。因为垃圾回收仅依赖恒等式`（==）`而不是 `equals` 比较值。
- CacheBuilder.softValues():使用软引用存储值。软引用只有在响应内存需要是，才按照全局最近最少使用的顺序回收。考虑到使用软引用的性能影响。我们通常建议使用更有性能预测性的缓存大小限定。使用软引用值的缓存同样用 `==` 而不是 `equals` 比较值。

### 显式清除

任何时候，你都可以显式地清除缓存项，而不是等到它被回收：  
- Cache.invalidate(key):个别清除。
- Cache.invalidateAll(keys):批量清除。
- Cache.invalidateAll():清除所有缓存项。

### 移除监听器
- CacheBuilder.removalListener(RemovalListener):通过 `CacheBuilder.removalListener(RemovalListener)` 可以声明一个监听器，一边缓存项被移除是做一些额外操作。缓存项被移除是，`RemovalListener` 会获取移除通知 `RemovalNotification`,其中包含移除原因 `RemovalCause`、键和值。_请注意，RemovalListener 抛出的任何异常都会记录到日志后被丢弃 swallowed 。_



**[参考资料](http://ifeve.com/google-guava-cachesexplained/)**

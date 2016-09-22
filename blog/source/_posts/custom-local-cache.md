---
title: 通过 HashMap 实现本地缓存
date: 2016-09-22 20:30:00
categories:
- Java 编程
tags: 
- Java
- HashMap
description: 
---

## 引言
  本地缓存在我们的工作中是比较常见的一种技术手段，不管是分布式缓存，还是本地缓存，或多或少我们都会使用到，本地缓存比较常用的数 Guava 缓存。
今天我们不聊 Guava，而是聊一聊怎样通过 HashMap 来实现一个本地缓存。

<!-- more -->

## 实现
通过 HashMap 实现本地缓存相当简单，废话不多说，先上代码:

``` java
public enum UserCache {

	instance;

	// 日志记录器
	private final static org.apache.logging.log4j.Logger log = org.apache.logging.log4j.LogManager.getLogger(UserCache.class);

	HashMap<Integer, String> UserMap = new HashMap<Integer, String>();

	static {
		UserCache.instance.init();
	}

	/**
	 * 初始化缓存
	 *
	 */
	public void init() {

		log.info("初始化 User 缓存初始化开始...");

		// web容器中获取上下文
		WebApplicationContext context = ContextLoader.getCurrentWebApplicationContext();
		IUserDao UserDao = (IUserDao) context.getBean("UserDaoImpl");

		List<User> Users = UserDao.selectAll();
		int count = 0;
		for (User User : Users) {
			count++;
			UserMap.put(User.getUserId(), JSON.toJSONString(User));
		}

		if (Users.size() != count) {
			log.error("User 数据未完全加载！");
		}
		log.info("共计加载：" + count);
		log.info("初始化 User 缓存初始化结束！");

	}

	public HashMap<Integer, String> getPhoneAttr() {
		return UserMap;
	}
}
```

代码是不是相当简单，聪明的你一定能看懂这段代码。那么，请聪明的你再猜猜，我是怎么刷新缓存的？对了，就是定时器，用定时器去定时的刷新缓存。
整个设计跟实现是不是都很简单啊？
先欠个债，稍后补充。。。

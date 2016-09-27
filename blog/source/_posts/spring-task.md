---
title: Spring 定时器的两种简单实现
date: 2016-09-27 14:55:00
categories:
- Java 编程
tags: 
- Spring
- Java
description: 
---

# Spring 定时任务的两种简单实现

前段时间参与的项目，有一个定时作业来定时的拉取数据。最近得空整理一下我所了解的基于 Spring 的定时器的两种简单实现。

<!-- more -->

## Spring 定时任务基于 XML

Spring 定时任务基于 XML 的实现正是在我们项目中应用的。Spring3.0 以后自带的 task 大大的方便了我们的实现定时任务。

### 定时任务类

``` java
public class Task01 {
    public void printJob(){
        System.out.println("************定时打印---XML**************");
    }
}
```

就是一个普通的类，其中，`printJob()` 是我们需要定时执行的任务方法。

### XML

```xml
<beans xmlns="http://www.springframework.org/schema/beans" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:p="http://www.springframework.org/schema/p" xmlns:c="http://www.springframework.org/schema/c" xmlns:tool="http://www.springframework.org/schema/tool" xmlns:util="http://www.springframework.org/schema/util" xmlns:context="http://www.springframework.org/schema/context" xmlns:jee="http://www.springframework.org/schema/jee" xmlns:lang="http://www.springframework.org/schema/lang" xmlns:task="http://www.springframework.org/schema/task" xmlns:cache="http://www.springframework.org/schema/cache" xmlns:aop="http://www.springframework.org/schema/aop" xmlns:tx="http://www.springframework.org/schema/tx" xmlns:mvc="http://www.springframework.org/schema/mvc" xmlns:jdbc="http://www.springframework.org/schema/jdbc" xmlns:jms="http://www.springframework.org/schema/jms"
	xsi:schemaLocation="http://www.springframework.org/schema/beans
	http://www.springframework.org/schema/beans/spring-beans.xsd
	http://www.springframework.org/schema/tool
	http://www.springframework.org/schema/tool/spring-tool.xsd
	http://www.springframework.org/schema/util
	http://www.springframework.org/schema/util/spring-util.xsd
	http://www.springframework.org/schema/context
	http://www.springframework.org/schema/context/spring-context.xsd
	http://www.springframework.org/schema/jee
	http://www.springframework.org/schema/jee/spring-jee.xsd
	http://www.springframework.org/schema/lang
	http://www.springframework.org/schema/lang/spring-lang.xsd
	http://www.springframework.org/schema/task
	http://www.springframework.org/schema/task/spring-task.xsd
	http://www.springframework.org/schema/cache
	http://www.springframework.org/schema/cache/spring-cache.xsd
	http://www.springframework.org/schema/aop
	http://www.springframework.org/schema/aop/spring-aop.xsd
	http://www.springframework.org/schema/tx
	http://www.springframework.org/schema/tx/spring-tx.xsd
	http://www.springframework.org/schema/mvc
	http://www.springframework.org/schema/mvc/spring-mvc.xsd
	http://www.springframework.org/schema/jdbc
	http://www.springframework.org/schema/jdbc/spring-jdbc.xsd
	http://www.springframework.org/schema/jms
	http://www.springframework.org/schema/jms/spring-jms.xsd">

	<task:annotation-driven />
  
	<!-- 定时任务（每隔5秒执行一次） -->
	<bean id="Task01" class="com.apple.springmvc.task.Task01"></bean>
	<task:scheduled-tasks>
		<task:scheduled ref="Task01" method="printJob" cron="*/5 * * * * ?" />
	</task:scheduled-tasks>

</beans>
```

在 XML 里我们可以设置定时任务的执行频率或者执行时间，关于定时任务 `cron` 的语法可以参照我之前的一篇博客，[定时器语法](http://blog.xueni.ren/2016/07/15/timer-grammar-xml/) 
来修改成符合成你业务需求的。

## Spring 定时任务基于注解

因为用的 `Spring` 框架，其实基于注解来实现定时任务相对来说方便很多。

### 定时任务类

``` java
@Component("task")
public class Task02 {
    @Scheduled(cron = "*/7 * * * * ?")
    public void printJob2() {
        System.out.println("************定时打印---注解**************");
    }
}
```

这里我们主要用到了两个注解 `@Component` 和 `@Scheduled` 。

### XML

```xml
<beans xmlns="http://www.springframework.org/schema/beans" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:p="http://www.springframework.org/schema/p" xmlns:c="http://www.springframework.org/schema/c" xmlns:tool="http://www.springframework.org/schema/tool" xmlns:util="http://www.springframework.org/schema/util" xmlns:context="http://www.springframework.org/schema/context" xmlns:jee="http://www.springframework.org/schema/jee" xmlns:lang="http://www.springframework.org/schema/lang" xmlns:task="http://www.springframework.org/schema/task" xmlns:cache="http://www.springframework.org/schema/cache" xmlns:aop="http://www.springframework.org/schema/aop" xmlns:tx="http://www.springframework.org/schema/tx" xmlns:mvc="http://www.springframework.org/schema/mvc" xmlns:jdbc="http://www.springframework.org/schema/jdbc" xmlns:jms="http://www.springframework.org/schema/jms"
	xsi:schemaLocation="http://www.springframework.org/schema/beans
	http://www.springframework.org/schema/beans/spring-beans.xsd
	http://www.springframework.org/schema/tool
	http://www.springframework.org/schema/tool/spring-tool.xsd
	http://www.springframework.org/schema/util
	http://www.springframework.org/schema/util/spring-util.xsd
	http://www.springframework.org/schema/context
	http://www.springframework.org/schema/context/spring-context.xsd
	http://www.springframework.org/schema/jee
	http://www.springframework.org/schema/jee/spring-jee.xsd
	http://www.springframework.org/schema/lang
	http://www.springframework.org/schema/lang/spring-lang.xsd
	http://www.springframework.org/schema/task
	http://www.springframework.org/schema/task/spring-task.xsd
	http://www.springframework.org/schema/cache
	http://www.springframework.org/schema/cache/spring-cache.xsd
	http://www.springframework.org/schema/aop
	http://www.springframework.org/schema/aop/spring-aop.xsd
	http://www.springframework.org/schema/tx
	http://www.springframework.org/schema/tx/spring-tx.xsd
	http://www.springframework.org/schema/mvc
	http://www.springframework.org/schema/mvc/spring-mvc.xsd
	http://www.springframework.org/schema/jdbc
	http://www.springframework.org/schema/jdbc/spring-jdbc.xsd
	http://www.springframework.org/schema/jms
	http://www.springframework.org/schema/jms/spring-jms.xsd">

	<task:annotation-driven />
	<context:component-scan base-package="com.apple.springmvc.task"/>
</beans>
```

以上就是 `Spring-task` 的两种简单实现，因为代码很简单，就不做过多解释了。

---
title: SpringMVC 整合Mongodb
date: 2016-06-06 22:27:45
categories:
- 学习笔记
tags: 
- SpringMVC
- 整合Mongod
description: 
---

# 引言
平时都在用 SpringMVC 进行开发，但是，基本上都是在用 SpringMVC+Mybatis+MySQL 进行开发。对于 Mongodb 只是听说过，
自己实际没有操作过，近期，在工作之余决定研究一下 Mongodb 。
<!-- more -->
那么，开始进入正题吧，此次我构建的项目是 SpringMVC+Mongodb+Maven ，有不对之处，还望指出。

作为一个 Maven 工程，我们还是先从 pom.xml 文件开始把,在 pom.xml 里配置我们的工程所依赖的 jar。
pom.xml

```xml

<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.apple</groupId>
  <artifactId>MongoDemo</artifactId>
  <packaging>war</packaging>
  <version>0.0.1-SNAPSHOT</version>
  <name>MongoDemo Maven Webapp</name>
  <url>http://maven.apache.org</url>
  <!-- 属性配置 -->
	<properties>
		<project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
		<jdk.version>1.7</jdk.version>
	</properties>
	
	<dependencies>
		<!-- Spring4支持 -->
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-core</artifactId>
			<version>4.1.0.RELEASE</version>
		</dependency>
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-context</artifactId>
			<version>4.1.0.RELEASE</version>
		</dependency>
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-expression</artifactId>
			<version>4.1.0.RELEASE</version>
		</dependency>
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-beans</artifactId>
			<version>4.1.0.RELEASE</version>
		</dependency>
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-aop</artifactId>
			<version>4.1.0.RELEASE</version>
		</dependency>
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-web</artifactId>
			<version>4.1.0.RELEASE</version>
		</dependency>
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-webmvc</artifactId>
			<version>4.1.0.RELEASE</version>
		</dependency>
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-tx</artifactId>
			<version>4.1.0.RELEASE</version>
		</dependency>
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-context-support</artifactId>
			<version>4.1.0.RELEASE</version>
		</dependency>
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-test</artifactId>
			<version>4.1.0.RELEASE</version>
		</dependency>
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-jdbc</artifactId>
			<version>4.1.0.RELEASE</version>
		</dependency>

		<!-- spring-data-mongodb -->
		<dependency>
			<groupId>org.springframework.data</groupId>
			<artifactId>spring-data-mongodb</artifactId>
			<version>1.7.1.RELEASE</version>
		</dependency>

		<!-- mongodb 驱动-->
		<dependency>
			<groupId>org.mongodb</groupId>
			<artifactId>mongo-java-driver</artifactId>
			<version>3.2.2</version>
		</dependency>


		<!-- WEB -->
		<dependency>
			<groupId>javax.servlet</groupId>
			<artifactId>javax.servlet-api</artifactId>
			<version>3.1.0</version>
			<scope>provided</scope> <!-- 编译需要而发布不需要的jar包 -->
		</dependency>

		<!-- 阿里JSON包 -->
		<dependency>
			<groupId>com.alibaba</groupId>
			<artifactId>fastjson</artifactId>
			<version>1.2.7</version>
		</dependency>

		<!-- log4j2核心包 -->
		<dependency>
			<groupId>org.apache.logging.log4j</groupId>
			<artifactId>log4j-core</artifactId>
			<version>2.5</version>
		</dependency>

		<!-- 单元测试 -->
		<dependency>
			<groupId>junit</groupId>
			<artifactId>junit</artifactId>
			<version>4.12</version>
		</dependency>

	</dependencies>

	<!-- 项目构建配置 -->
	<build>
		<plugins>
			<!-- 资源  -->
			<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-resources-plugin</artifactId>
				<version>2.7</version>
				<configuration>
					<encoding>${project.build.sourceEncoding}</encoding>
				</configuration>
			</plugin> 
			<!-- 编译 -->
			<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-compiler-plugin</artifactId>
				<version>3.5.1</version>
				<configuration>
					<source>${jdk.version}</source>
					<target>${jdk.version}</target>
					<encoding>${project.build.sourceEncoding}</encoding>
					<showWarnings>true</showWarnings>
					<optimize>true</optimize>
				</configuration>
			</plugin>
			<!-- 发布 -->
			<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-war-plugin</artifactId>
				<version>2.6</version>
				<configuration>
					<warName>/</warName>
				</configuration>
			</plugin>
		</plugins>
	</build>
</project>

```



接着就是web.xml 文件，有一点我们需要明确的就是， web.xml 文件并不是 web 工程所必须的，但是，一般情况下，我们都是以 web.xml 作为我们 web工程的
入口。
web.xml

``` xml

<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://java.sun.com/xml/ns/javaee" xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_3_0.xsd" id="WebApp_ID" version="3.0">
  <context-param>
    <param-name>contextConfigLocation</param-name>
     <param-value>
			classpath:spring/applicationContext-dao.xml,
			classpath:spring/applicationContext-service.xml
		</param-value>
  </context-param>
  <listener>
    <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
  </listener>
  <filter>
    <filter-name>encodingFilter</filter-name>
    <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
    <init-param>
      <param-name>encoding</param-name>
      <param-value>UTF-8</param-value>
    </init-param>
    <init-param>
      <param-name>forceEncoding</param-name>
      <param-value>true</param-value>
    </init-param>
  </filter>
  <filter-mapping>
    <filter-name>encodingFilter</filter-name>
    <url-pattern>*.json</url-pattern>
  </filter-mapping>
  <filter-mapping>
    <filter-name>encodingFilter</filter-name>
    <url-pattern>*.jsonp</url-pattern>
  </filter-mapping>
  <filter-mapping>
    <filter-name>encodingFilter</filter-name>
    <url-pattern>*.do</url-pattern>
  </filter-mapping>
  <servlet>
    <servlet-name>springmvc</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    <init-param>
      <param-name>contextConfigLocation</param-name>
      <param-value>classpath:spring/applicationContext-mvc.xml</param-value>
    </init-param>
    <load-on-startup>1</load-on-startup>
  </servlet>
  <servlet-mapping>
    <servlet-name>springmvc</servlet-name>
    <url-pattern>*.json</url-pattern>
  </servlet-mapping>
  <servlet-mapping>
    <servlet-name>springmvc</servlet-name>
    <url-pattern>*.jsonp</url-pattern>
  </servlet-mapping>
  <servlet-mapping>
    <servlet-name>springmvc</servlet-name>
    <url-pattern>*.do</url-pattern>
  </servlet-mapping>
  <servlet-mapping>
    <servlet-name>springmvc</servlet-name>
    <url-pattern>*.action</url-pattern>
  </servlet-mapping>
  <welcome-file-list>
    <welcome-file>index.html</welcome-file>
    <welcome-file>index.htm</welcome-file>
    <welcome-file>index.jsp</welcome-file>
  </welcome-file-list>
</web-app>

``` 

db.properties 文件

```xml

mongo.host=127.0.0.1
mongo.port=27017
mongo.username=
mongo.password=
mongo.database=test

```


applicationContext-mvc.xml


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

	<!-- 扫描包 -->
	<context:component-scan base-package="com.apple.mongo.controller" />

	<!-- 这个配置用于返回json或者jsonp,具体的序列化器可以自定义 -->
	<mvc:annotation-driven>
		<mvc:message-converters register-defaults="false"> <!-- 注意：不设置为false的话存在性能问题差1倍 -->
			<bean class="web.converter.RestResponseMessageConverter">
				<property name="features">
					<array>
						<util:constant static-field="com.alibaba.fastjson.serializer.SerializerFeature.QuoteFieldNames" /><!-- 输出key时是否使用双引号,默认为true -->
						<util:constant static-field="com.alibaba.fastjson.serializer.SerializerFeature.WriteMapNullValue" /><!-- 是否输出值为null的字段,默认为false -->
						<util:constant static-field="com.alibaba.fastjson.serializer.SerializerFeature.WriteEnumUsingToString" />
						<util:constant static-field="com.alibaba.fastjson.serializer.SerializerFeature.SkipTransientField" />
						<util:constant static-field="com.alibaba.fastjson.serializer.SerializerFeature.WriteDateUseDateFormat" />
						<util:constant static-field="com.alibaba.fastjson.serializer.SerializerFeature.DisableCheckSpecialChar" />
					</array>
				</property>
			</bean>
		</mvc:message-converters>
	</mvc:annotation-driven>

	<!-- 启动Spring MVC的注解功能，完成请求和注解POJO的映射,解决@ResponseBody乱码问题, 需要在annotation-driven之前,否则乱码问题同样无法解决 -->
	<bean class="org.springframework.web.servlet.mvc.annotation.AnnotationMethodHandlerAdapter">
		<property name="messageConverters">
			<list>
				<bean class="org.springframework.http.converter.StringHttpMessageConverter">
					<property name="supportedMediaTypes">
						<list>
							<bean class="org.springframework.http.MediaType">
								<constructor-arg index="0" value="text" />
								<constructor-arg index="1" value="plain" />
								<constructor-arg index="2" value="UTF-8" />
							</bean>
						</list>
					</property>
				</bean>
			</list>
		</property>
	</bean>

	<!-- 视图 -->
	<bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
		<property name="prefix" value="/WEB-INF/pages/" /><!-- 前缀路径 -->
		<property name="suffix" value="" /><!-- 后缀 -->
	</bean>

</beans>

```

applicationContext-dao.xml


```xml

<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:p="http://www.springframework.org/schema/p"
	   xmlns:context="http://www.springframework.org/schema/context"
	   xmlns:aop="http://www.springframework.org/schema/aop"
	   xmlns:task="http://www.springframework.org/schema/task"
	   xmlns:mongo="http://www.springframework.org/schema/data/mongo"
	   xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans-4.1.xsd
        http://www.springframework.org/schema/context
        http://www.springframework.org/schema/context/spring-context-4.1.xsd
        http://www.springframework.org/schema/aop
        http://www.springframework.org/schema/aop/spring-aop-4.1.xsd
        http://www.springframework.org/schema/data/mongo
        http://www.springframework.org/schema/data/mongo/spring-mongo-1.7.xsd
        http://www.springframework.org/schema/task
        http://www.springframework.org/schema/task/spring-task-4.1.xsd">

	<context:annotation-config />


	<!-- 提供该PropertyPlaceholderConfigurer bean支持把properties文件中的信息读取到XML配置文件的表达式中 -->
	<context:property-placeholder location="classpath:conf/db.properties" />

	<!-- 通过工厂Bean创建mongo连接实例,没有密码就把username和password属性删除了-->
	<mongo:db-factory host="${mongo.host}" port="${mongo.port}" dbname="${mongo.database}" />


	<!-- mongo模板操作对象 -->
	<bean id="mongoTemplate" class="org.springframework.data.mongodb.core.MongoTemplate">
		<constructor-arg name="mongoDbFactory" ref="mongoDbFactory"/>
	</bean>

	<!-- MongoDB GridFS Template 支持，操作mongodb存放的文件 -->
	<mongo:mapping-converter id="converter" db-factory-ref="mongoDbFactory"/>
	<bean id="gridFsTemplate" class="org.springframework.data.mongodb.gridfs.GridFsTemplate">
		<constructor-arg ref="mongoDbFactory"/>
		<constructor-arg ref="converter"/>
	</bean>


	<!-- 使用annotation定义事务
	<tx:annotation-driven transaction-manager="transactionManager" /> -->

	<!-- 扫描实现 -->
	<context:component-scan base-package="com.apple.mongo.dao.impl" />

</beans>

```


applicationContext-service.xml


```xml

<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:p="http://www.springframework.org/schema/p"
	xmlns:c="http://www.springframework.org/schema/c" xmlns:tool="http://www.springframework.org/schema/tool"
	xmlns:util="http://www.springframework.org/schema/util" xmlns:context="http://www.springframework.org/schema/context"
	xmlns:jee="http://www.springframework.org/schema/jee" xmlns:lang="http://www.springframework.org/schema/lang"
	xmlns:task="http://www.springframework.org/schema/task" xmlns:cache="http://www.springframework.org/schema/cache"
	xmlns:aop="http://www.springframework.org/schema/aop" xmlns:tx="http://www.springframework.org/schema/tx"
	xmlns:mvc="http://www.springframework.org/schema/mvc" xmlns:jdbc="http://www.springframework.org/schema/jdbc"
	xmlns:jms="http://www.springframework.org/schema/jms"
	xsi:schemaLocation="
    http://www.springframework.org/schema/beans   
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
    http://www.springframework.org/schema/jms/spring-jms.xsd
    ">
	<!-- 该配置文件主要针对service层(服务层)做配置 -->

	<context:component-scan base-package="com.apple.mongo.service" resource-pattern="**/*ServiceImpl.class" />

</beans>

```






---
title: Tomcat JDBC Pool 多数据源配置
date: 2017-1-4 21:30:00
categories:
- Java 编程
tags: 
- JDBC 
description: 
---
## 前言
多数据源配置示例

<!-- more -->

```xml
<!-- 数据库配置信息 -->
	<context:property-placeholder location="classpath:conf/db.properties" ignore-unresolvable="true" />

	<!-- ================================Tomcat JDBC Pool数据源配置（写）================================================= -->
	<bean id="dataSourceW" class="org.apache.tomcat.jdbc.pool.DataSource" destroy-method="close">
		<property name="poolProperties">
			<bean class="org.apache.tomcat.jdbc.pool.PoolProperties">
				<property name="driverClassName" value="${db_w.driverClassName}" />
				<property name="url" value="${db_w.url}" />
				<property name="username" value="${db_w.username}" />
				<property name="password" value="${db_w.password}" />
				<property name="jmxEnabled" value="${db_w.jmxEnabled}" />
				<property name="testOnBorrow" value="${db_w.testOnBorrow}" />
				<property name="testWhileIdle" value="${db_w.testWhileIdle}" />
				<property name="testOnReturn" value="${db_w.testOnReturn}" />
				<property name="validationInterval" value="${db_w.validationInterval}" />
				<property name="validationQuery" value="${db_w.validationQuery}" />
				<property name="timeBetweenEvictionRunsMillis" value="${db_w.timeBetweenEvictionRunsMillis}" />
				<property name="initialSize" value="${db_w.initialSize}" />
				<property name="maxActive" value="${db_w.maxActive}" />
				<property name="maxIdle" value="${db_w.maxIdle}" />
				<property name="minIdle" value="${db_w.minIdle}" />
				<property name="maxWait" value="${db_w.maxWait}" />
				<property name="minEvictableIdleTimeMillis" value="${db_w.minEvictableIdleTimeMillis}" />
				<property name="logAbandoned" value="${db_w.logAbandoned}" />
				<property name="removeAbandoned" value="${db_w.removeAbandoned}" />
				<property name="removeAbandonedTimeout" value="${db_w.removeAbandonedTimeout}" />
				<property name="jdbcInterceptors" value="${db_w.jdbcInterceptors}" />
			</bean>
		</property>
	</bean>
	<!-- ================================Tomcat JDBC Pool数据源配置（读）================================================= -->
	<bean id="dataSourceR" class="org.apache.tomcat.jdbc.pool.DataSource" destroy-method="close">
		<property name="poolProperties">
			<bean class="org.apache.tomcat.jdbc.pool.PoolProperties">
				<property name="driverClassName" value="${db_r.driverClassName}" />
				<property name="url" value="${db_r.url}" />
				<property name="username" value="${db_r.username}" />
				<property name="password" value="${db_r.password}" />
				<property name="jmxEnabled" value="${db_r.jmxEnabled}" />
				<property name="testOnBorrow" value="${db_r.testOnBorrow}" />
				<property name="testWhileIdle" value="${db_r.testWhileIdle}" />
				<property name="testOnReturn" value="${db_r.testOnReturn}" />
				<property name="validationInterval" value="${db_r.validationInterval}" />
				<property name="validationQuery" value="${db_r.validationQuery}" />
				<property name="timeBetweenEvictionRunsMillis" value="${db_r.timeBetweenEvictionRunsMillis}" />
				<property name="initialSize" value="${db_r.initialSize}" />
				<property name="maxActive" value="${db_r.maxActive}" />
				<property name="maxIdle" value="${db_r.maxIdle}" />
				<property name="minIdle" value="${db_r.minIdle}" />
				<property name="maxWait" value="${db_r.maxWait}" />
				<property name="minEvictableIdleTimeMillis" value="${db_r.minEvictableIdleTimeMillis}" />
				<property name="logAbandoned" value="${db_r.logAbandoned}" />
				<property name="removeAbandoned" value="${db_r.removeAbandoned}" />
				<property name="removeAbandonedTimeout" value="${db_r.removeAbandonedTimeout}" />
				<property name="jdbcInterceptors" value="${db_r.jdbcInterceptors}" />
			</bean>
		</property>
	</bean>

	<!-- Mybatis链接工厂 -->
	<bean id="sqlSessionFactoryW" class="org.mybatis.spring.SqlSessionFactoryBean" p:dataSource-ref="dataSourceW" p:configLocation="classpath:mybatis/configuration.xml" />
	<bean id="sqlSessionFactoryR" class="org.mybatis.spring.SqlSessionFactoryBean" p:dataSource-ref="dataSourceR" p:configLocation="classpath:mybatis/configuration.xml" />
	<bean id="sqlSessionTemplateW" class="org.mybatis.spring.SqlSessionTemplate" c:sqlSessionFactory-ref="sqlSessionFactoryW" scope="prototype" />
	<bean id="sqlSessionTemplateR" class="org.mybatis.spring.SqlSessionTemplate" c:sqlSessionFactory-ref="sqlSessionFactoryR" scope="prototype" />
```

## db.properties
```xml
#---------------------Write---------------------------------
db_w.driverClassName=com.mysql.jdbc.Driver
db_w.url=jdbc:mysql://127.0.01:3306/address_shipping
db_w.username=root
db_w.password=root
db_w.jmxEnabled=true
db_w.testOnBorrow=false
db_w.testWhileIdle=true
db_w.testOnReturn=false
db_w.validationInterval=30000
db_w.validationQuery=select 1
db_w.timeBetweenEvictionRunsMillis=30000
db_w.initialSize=5
db_w.maxActive=20
db_w.maxIdle=5
db_w.minIdle=5
db_w.maxWait=30000
db_w.minEvictableIdleTimeMillis=30000
db_w.logAbandoned=false
db_w.removeAbandoned=true
db_w.removeAbandonedTimeout=60
db_w.jdbcInterceptors=org.apache.tomcat.jdbc.pool.interceptor.ConnectionState;org.apache.tomcat.jdbc.pool.interceptor.StatementFinalizer
#---------------------Read---------------------------------
db_r.driverClassName=com.mysql.jdbc.Driver
db_r.url=jdbc:mysql://127.0.01:3306/address_shipping
db_r.username=root
db_r.password=root
db_r.jmxEnabled=true
db_r.testOnBorrow=false
db_r.testWhileIdle=true
db_r.testOnReturn=false
db_r.validationInterval=30000
db_r.validationQuery=select 1
db_r.timeBetweenEvictionRunsMillis=30000
db_r.initialSize=5
db_r.maxActive=20
db_r.maxIdle=5
db_r.minIdle=5
db_r.maxWait=30000
db_r.minEvictableIdleTimeMillis=30000
db_r.logAbandoned=false
db_r.removeAbandoned=true
db_r.removeAbandonedTimeout=60
db_r.jdbcInterceptors=org.apache.tomcat.jdbc.pool.interceptor.ConnectionState;org.apache.tomcat.jdbc.pool.interceptor.StatementFinalizer
```
以上，备忘录。
